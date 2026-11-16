import 'dart:async';
import 'dart:io' as io;

import 'package:meta/meta.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:web_socket/io_web_socket.dart' show IOWebSocket;
import 'package:web_socket/web_socket.dart' as ws;

import '../device/device_identity.dart';
import '../logging/app_logger.dart';
import '../network/pinned_http_client.dart';
import '../storage/token_store.dart';
import 'realtime_event.dart';

/// Which credentials the socket uses.
enum RealtimeMode {
  /// Signed in (phone token, or watch signature + token).
  paired,

  /// Watch showing the pairing QR: device signature only; receives
  /// `pairing:approved` only.
  unpaired,
}

/// The one socket to `<backend>/technician` (backend guide, part 1 step 2).
///
/// HTTP does the actions, the socket tells what happened. There is no push:
/// while a technician is signed in the socket must stay connected, and after
/// every reconnect the app redraws from `state:snapshot`.
abstract class RealtimeService {
  Stream<RealtimeEvent> get events;

  /// Emits on every connect / disconnect.
  Stream<bool> get connectionChanges;
  bool get isConnected;

  /// The requested mode, or null when stopped.
  RealtimeMode? get mode;

  /// Starts (or switches to) [mode] and keeps reconnecting until [stop].
  void start(RealtimeMode mode);

  /// Disconnects and stops reconnecting.
  Future<void> stop();

  /// Retries now instead of waiting for the backoff (resume, network back).
  void reconnectNow();

  /// `work-order:ack`. True when the server answered `{ ok: true }`.
  Future<bool> ack(String workOrderId);
}

/// Builds the handshake `auth` for one connection. Signed handshakes are
/// single use, so it is called again for every connection.
class RealtimeAuth {
  RealtimeAuth({required TokenStore tokens, RequestSigner? signer})
    : _tokens = tokens,
      _signer = signer;

  final TokenStore _tokens;
  final RequestSigner? _signer;

  Future<Map<String, dynamic>> build(RealtimeMode mode) async {
    final token = _tokens.current?.accessToken;
    final signer = _signer;
    if (signer == null) return {'token': token};
    final paired = mode == RealtimeMode.paired;
    return signer.socketAuth(
      sessionId: paired ? _tokens.sessionId : null,
      token: paired ? token : null,
    );
  }
}

class SocketIoRealtimeService implements RealtimeService {
  SocketIoRealtimeService({
    required Uri url,
    required RealtimeAuth auth,
    List<String> certificatePins = const [],
    @visibleForTesting this.backoff = defaultBackoff,
  }) : _url = url,
       _auth = auth,
       _pins = certificatePins;

  final Uri _url;
  final RealtimeAuth _auth;
  final List<String> _pins;
  final List<Duration> backoff;

  static const defaultBackoff = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 30),
  ];

  static const ackTimeout = Duration(seconds: 5);

  final _events = StreamController<RealtimeEvent>.broadcast();
  final _connection = StreamController<bool>.broadcast();

  sio.Socket? _socket;
  RealtimeMode? _mode;
  bool _connected = false;
  int _attempt = 0;
  int _generation = 0;
  Timer? _retry;

  @override
  Stream<RealtimeEvent> get events => _events.stream;

  @override
  Stream<bool> get connectionChanges => _connection.stream;

  @override
  bool get isConnected => _connected;

  @override
  RealtimeMode? get mode => _mode;

  @override
  void start(RealtimeMode mode) {
    if (_mode == mode && (_socket != null || _retry != null)) return;
    _mode = mode;
    _attempt = 0;
    unawaited(_open());
  }

  @override
  Future<void> stop() async {
    _mode = null;
    _generation++;
    _retry?.cancel();
    _retry = null;
    _closeSocket();
    _setConnected(false);
  }

  @override
  void reconnectNow() {
    if (_mode == null || _connected) return;
    _retry?.cancel();
    _retry = null;
    _attempt = 0;
    unawaited(_open());
  }

  Future<void> _open() async {
    final mode = _mode;
    if (mode == null) return;
    final generation = ++_generation;
    _closeSocket();
    Map<String, dynamic> auth;
    try {
      auth = await _auth.build(mode);
    } on Object catch (e, s) {
      AppLogger.error('Realtime auth could not be built', e, s);
      _scheduleRetry(generation);
      return;
    }
    if (generation != _generation || _mode != mode) return;

    // Automatic reconnect is off: it would resend the used nonce. Every
    // connection is a new socket with a new signature (part 2 step 5).
    final socket = sio.io(
      _url.toString(),
      sio.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .disableReconnection()
          .enableForceNew()
          .setAuth(auth)
          .setWebSocketConnector(_connect)
          .build(),
    );
    _socket = socket;

    socket.onConnect((_) {
      if (generation != _generation) return;
      _attempt = 0;
      _setConnected(true);
      AppLogger.info('Realtime connected (${mode.name})');
    });
    socket.onConnectError((error) {
      if (generation != _generation) return;
      final unauthorized = _messageOf(error)?.contains('Unauthorized') ?? false;
      AppLogger.warn(
        'Realtime connect failed${unauthorized ? ' (Unauthorized)' : ''}',
      );
      _setConnected(false);
      if (unauthorized) _emit(const RealtimeAuthRejected());
      _scheduleRetry(generation, slow: unauthorized);
    });
    socket.onDisconnect((reason) {
      if (generation != _generation) return;
      AppLogger.info('Realtime disconnected');
      _setConnected(false);
      _scheduleRetry(generation);
    });
    for (final name in RealtimeEvent.names) {
      socket.on(name, (data) {
        if (generation != _generation) return;
        final event = RealtimeEvent.parse(name, data);
        if (event is SessionEndedEvent) {
          // The server closes the socket; never reconnect with this token.
          _mode = null;
          _generation++;
          _retry?.cancel();
          _closeSocket();
          _setConnected(false);
        }
        _emit(event);
      });
    }
    socket.connect();
  }

  Future<ws.WebSocket> _connect(
    Uri uri, {
    Iterable<String>? protocols,
    Map<String, String>? headers,
  }) async {
    // Owned by the client: closed through IOWebSocket when the socket closes.
    // ignore: close_sinks
    final socket = await io.WebSocket.connect(
      uri.toString(),
      protocols: protocols,
      headers: headers,
      customClient: pinnedHttpClient(_pins),
    );
    return IOWebSocket.fromWebSocket(socket);
  }

  void _scheduleRetry(int generation, {bool slow = false}) {
    if (_mode == null || generation != _generation) return;
    _retry?.cancel();
    final index = slow
        ? backoff.length - 1
        : (_attempt < backoff.length ? _attempt : backoff.length - 1);
    _attempt++;
    _retry = Timer(backoff[index], () {
      _retry = null;
      if (generation == _generation) unawaited(_open());
    });
  }

  @override
  Future<bool> ack(String workOrderId) async {
    final socket = _socket;
    if (socket == null || !_connected) return false;
    final done = Completer<bool>();
    socket.emitWithAck(
      'work-order:ack',
      {'work_order_id': workOrderId},
      ack: (dynamic reply) {
        final ok = reply is Map && reply['ok'] == true;
        if (!done.isCompleted) done.complete(ok);
      },
    );
    return done.future.timeout(ackTimeout, onTimeout: () => false);
  }

  void _closeSocket() {
    final s = _socket;
    _socket = null;
    if (s == null) return;
    s
      ..clearListeners()
      ..dispose();
  }

  void _setConnected(bool value) {
    if (_connected == value) return;
    _connected = value;
    if (!_connection.isClosed) _connection.add(value);
  }

  void _emit(RealtimeEvent event) {
    if (!_events.isClosed) _events.add(event);
  }

  static String? _messageOf(Object? error) {
    if (error is Map) return error['message']?.toString();
    return error?.toString();
  }

  Future<void> dispose() async {
    await stop();
    await _events.close();
    await _connection.close();
  }
}
