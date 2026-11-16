import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpDate;
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../push/push_message.dart';
import '../../realtime/realtime_event.dart';
import '../../realtime/realtime_models.dart';
import '../../realtime/realtime_service.dart';

/// In-memory implementation of the technician backend (docs/api_contract.md)
/// for the dev flavor with `USE_FAKE_BACKEND=true` and for integration tests.
/// Never used outside dev (enforced by `AppConfig`).
///
/// Behaviour:
/// * Login with KPK [demoKpk] and password [demoPassword] (or the `62…`
///   form). 5 wrong attempts lock the KPK (429 with `retryAfter`).
/// * After Check In a work order is assigned after [assignDelay] with a 60 s
///   window. No answer: auto-declined at 65 s and the technician is checked
///   out. An accepted job is completed after [repairDuration].
/// * Watch: enrollment code [demoEnrollmentCode]; a pairing is approved by
///   "the phone" automatically after [autoPairDelay].
/// * Events go to the fake socket ([realtime]) and, as FCM data messages,
///   to [pushMessages]; the app dedupes them.
class FakeBackend {
  FakeBackend({
    this.assignDelay = const Duration(seconds: 6),
    this.autoPairDelay = const Duration(seconds: 8),
    this.responseWindow = const Duration(seconds: 60),
    this.autoDeclineDelay = const Duration(seconds: 65),
    this.repairDuration = const Duration(seconds: 45),
    this.autoPairWatch = true,
    DateTime Function()? now,
  }) : _now = now ?? (() => DateTime.now().toUtc());

  static const demoKpk = '31';
  static const demoPassword = '081234567890';
  static const demoEnrollmentCode = 'K7M2Q9XD4B';
  static const _name = 'Mulyadi Santoso';
  static const _shift = 'S1';

  final Duration assignDelay;
  final Duration autoPairDelay;
  final Duration responseWindow;
  final Duration autoDeclineDelay;
  final Duration repairDuration;
  final bool autoPairWatch;
  final DateTime Function() _now;

  final _push = StreamController<Map<String, dynamic>>.broadcast();
  final _uuid = const Uuid();
  final _random = Random();

  late final FakeRealtimeService realtime = FakeRealtimeService._(this);
  late final HttpClientAdapter adapter = _FakeAdapter(this);

  /// FCM-style data messages (string values, see `PushMessage`).
  Stream<Map<String, dynamic>> get pushMessages => _push.stream;

  // Session
  String? _token;
  String? _sessionId;
  bool _watchSession = false;
  int _failedLogins = 0;
  DateTime? _lockedUntil;

  // Attendance
  bool _checkedIn = false;
  DateTime? _checkedInAt;
  final List<Map<String, Object?>> _attendance = [];

  // Work orders
  Map<String, Object?>? _pending;
  Map<String, Object?>? _active;
  int _counter = 0;
  Timer? _assignTimer;
  Timer? _declineTimer;
  Timer? _repairTimer;
  final List<Map<String, Object?>> _history = [];

  // Watch
  String? _deviceId;
  final Map<String, Map<String, Object?>> _pairings = {};
  final List<Map<String, Object?>> _pairedWatches = [];

  void dispose() {
    _assignTimer?.cancel();
    _declineTimer?.cancel();
    _repairTimer?.cancel();
    unawaited(_push.close());
    unawaited(realtime._close());
  }

  // ---------------------------------------------------------------- routing

  Future<_Reply> _handle(RequestOptions o) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final path = o.uri.path.replaceFirst(RegExp('^/+'), '');
    final body = _decode(o.data);
    final m = o.method.toUpperCase();

    if (m == 'POST' && path == 'technician-auth/login') return _login(body);
    if (m == 'POST' && path == 'shared-devices/enroll') return _enroll(body);
    if (path.startsWith('shared-devices/')) {
      if (!_signed(o)) return _Reply.error(401, 'Invalid device signature');
      if (m == 'GET' && path == 'shared-devices/me') return _deviceMe();
      if (m == 'POST' && path == 'shared-devices/pairings') {
        return _createPairing();
      }
      final p = RegExp(r'^shared-devices/pairings/([^/]+)(/exchange)?$')
          .firstMatch(path);
      if (p != null && m == 'GET' && p[2] == null) return _pairing(p[1]!);
      if (p != null && m == 'POST' && p[2] != null) return _exchange(p[1]!);
    }

    if (!_authorized(o)) return _Reply.error(401, 'Unauthorized');

    if (m == 'GET' && path == 'technician-auth/me') return _me();
    if (m == 'POST' && path == 'technician-auth/logout') return _logout();
    if (m == 'GET' && path == 'technicians/me/state') {
      return _Reply.ok(_snapshot());
    }
    if (m == 'GET' && path == 'technicians/me/profile') return _profile();
    if (m == 'GET' && path == 'technicians/me/attendance') {
      return _paged(_attendance.reversed.toList(), o.uri.queryParameters);
    }
    if (m == 'POST' && path == 'technicians/me/check-in') return _checkIn();
    if (m == 'POST' && path == 'technicians/me/check-out') return _checkOut();
    if (m == 'POST' && path == 'technicians/me/unpair') return _unpairSelf();
    if (m == 'GET' && path == 'technicians/me/devices') return _devices();
    final unpair = RegExp(r'^technicians/me/devices/([^/]+)/unpair$')
        .firstMatch(path);
    if (m == 'POST' && unpair != null) return _unpairWatch(unpair[1]!);
    if (m == 'GET' && path == 'technicians/me/pairings/preview') {
      return _preview(o.uri.queryParameters['code']);
    }
    if (m == 'POST' && path == 'technicians/me/pairings/approve') {
      return _approve(body['code'] as String?);
    }
    if (m == 'GET' && path == 'technicians/me/work-orders') {
      return _workOrders(o.uri.queryParameters);
    }
    final wo = RegExp(
      r'^technicians/me/work-orders/([^/]+)(?:/(accept|decline|cancel))?$',
    ).firstMatch(path);
    if (wo != null) {
      final id = wo[1]!;
      return switch ((m, wo[2])) {
        ('GET', null) => _workOrderDetail(id),
        ('POST', 'accept') => _accept(id),
        ('POST', 'decline') => _decline(id),
        ('POST', 'cancel') => _cancel(id),
        _ => _Reply.error(404, 'Not found'),
      };
    }
    return _Reply.error(404, 'Unknown fake route $m $path');
  }

  bool _authorized(RequestOptions o) =>
      _token != null && o.headers['Authorization'] == 'Bearer $_token';

  bool _signed(RequestOptions o) =>
      _deviceId != null && o.headers['X-Device-Id'] == _deviceId;

  // ------------------------------------------------------------------ auth

  _Reply _login(Map<String, Object?> body) {
    final now = _now();
    final locked = _lockedUntil;
    if (locked != null && now.isBefore(locked)) {
      return _Reply.error(
        429,
        'Too many failed login attempts',
        extra: {'retryAfter': locked.difference(now).inSeconds},
      );
    }
    final kpk = '${body['kpk'] ?? ''}';
    final password = '${body['password'] ?? ''}'.replaceFirst(
      RegExp('^62'),
      '0',
    );
    if (kpk != demoKpk || password != demoPassword) {
      if (++_failedLogins >= 5) {
        _lockedUntil = now.add(const Duration(minutes: 15));
        _failedLogins = 0;
      }
      return _Reply.error(401, 'Invalid KPK or password');
    }
    _failedLogins = 0;
    _watchSession = false;
    return _Reply.ok(
      _issueToken(const Duration(days: 30)),
      message: 'Login successful',
    );
  }

  Map<String, Object?> _issueToken(Duration ttl) {
    _sessionId = _uuid.v4();
    final expires = _now().add(ttl);
    String b64(Map<String, Object?> m) =>
        base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '');
    _token = [
      b64({'alg': 'none', 'typ': 'JWT'}),
      b64({
        'sub': demoKpk,
        'session_id': _sessionId,
        'exp': expires.millisecondsSinceEpoch ~/ 1000,
      }),
      'fake',
    ].join('.');
    return {
      'access_token': _token,
      'expires_at': _iso(expires),
      'technician': _technician(),
    };
  }

  Map<String, Object?> _technician() => {
    'kpk': int.parse(demoKpk),
    'name': _name,
    'shift': _shift,
  };

  _Reply _me() =>
      _Reply.ok({'technician': _technician(), 'session_id': _sessionId});

  _Reply _logout() {
    _endSession('LOGOUT', notify: false);
    return _Reply.ok(null, message: 'Logged out');
  }

  void _endSession(String reason, {required bool notify}) {
    if (notify) realtime._send(RealtimeEvent.sessionEnded, {'reason': reason});
    _token = null;
    _sessionId = null;
    _assignTimer?.cancel();
  }

  _Reply _profile() => _Reply.ok({
    ..._technician(),
    'is_active': true,
    'member_since': '2025-03-02T00:00:00.000Z',
    'phone_number_masked': '6281*****890',
  });

  // ------------------------------------------------------------ attendance

  Map<String, Object?> _status() => {
    'checked_in': _checkedIn,
    'checked_in_at': _checkedIn ? _iso(_checkedInAt!) : null,
    'is_available': _checkedIn && _active == null,
    'is_on_break': false,
    'shift': _shift,
  };

  Map<String, Object?> _snapshot() => {
    'self': {
      'kind': _watchSession ? 'SHARED' : 'PERSONAL',
      'technician_id': int.parse(demoKpk),
      'session_id': _sessionId,
      'device_id': _watchSession ? _deviceId : null,
    },
    'status': _status(),
    'pending_work_order': _pending,
    'active_work_order': _active,
    'paired_watches': _watchSession ? null : _pairedWatches,
  };

  _Reply _checkIn() {
    final outcome = _checkedIn
        ? 'ALREADY_CHECKED_IN'
        : (_attendance.isNotEmpty ? 'RESUMED' : 'CHECKED_IN');
    if (!_checkedIn) {
      _checkedIn = true;
      _checkedInAt = _now();
      _attendance.add({
        'id': _uuid.v4(),
        'date': _iso(_now()).substring(0, 10),
        'shift': _shift,
        'status': 'OPEN',
        'checked_in_at': _iso(_checkedInAt!),
        'checked_out_at': null,
        'worked_minutes': null,
        'is_available': true,
        'is_on_break': false,
      });
      _statusChanged('CHECK_IN');
      _scheduleAssignment();
    }
    return _Reply.ok({
      'outcome': outcome,
      'shift': _shift,
      'date': _iso(_now()).substring(0, 10),
      'checked_in_at': _iso(_checkedInAt!),
    });
  }

  _Reply _checkOut() {
    if (!_checkedIn) return _Reply.ok({'outcome': 'NOT_CHECKED_IN'});
    final at = _checkedInAt;
    _doCheckOut('CHECK_OUT');
    return _Reply.ok({
      'outcome': 'CHECKED_OUT',
      'shift': _shift,
      'checked_in_at': at == null ? null : _iso(at),
    });
  }

  void _doCheckOut(String reason) {
    _checkedIn = false;
    _assignTimer?.cancel();
    if (_attendance.isNotEmpty) {
      final row = _attendance.last;
      final started = DateTime.parse(row['checked_in_at']! as String);
      row
        ..['status'] = 'CLOSED'
        ..['checked_out_at'] = _iso(_now())
        ..['worked_minutes'] = _now().difference(started).inMinutes
        ..['is_available'] = false;
    }
    _statusChanged(reason);
  }

  void _statusChanged(String reason) => _event(RealtimeEvent.statusChanged, {
    'status': _status(),
    'reason': reason,
    'by': {'source': 'system', 'device_kind': null, 'device_id': null},
    'at': _iso(_now()),
  });

  // ----------------------------------------------------------- work orders

  void _scheduleAssignment({Duration? delay}) {
    _assignTimer?.cancel();
    _assignTimer = Timer(delay ?? assignDelay, () {
      if (!_checkedIn || _pending != null || _active != null) return;
      if (_token == null) return;
      _counter++;
      final now = _now();
      final machines = ['FAR339', 'INJ204', 'PNT031', 'ASM118'];
      final issues = ['Changeover', 'Tools Problem', 'Mesin Berhenti'];
      final wo = <String, Object?>{
        'id': _uuid.v4(),
        'request_id':
            'WO-${now.year}-${(193 + _counter).toString().padLeft(5, '0')}',
        'status': 'PENDING',
        'shift': _shift,
        'created_at': _iso(now),
        'respond_by': _iso(now.add(responseWindow)),
        'machine': {
          'id': machines[_random.nextInt(machines.length)],
          'cell_position': 'B-${10 + _random.nextInt(20)}',
        },
        'issue': issues[_random.nextInt(issues.length)],
        'repair_id': _uuid.v4(),
      };
      _pending = wo;
      _record(wo, 'WAITING');
      _event(RealtimeEvent.workOrderAssigned, {'work_order': wo});
      _declineTimer?.cancel();
      _declineTimer = Timer(autoDeclineDelay, () {
        if (_pending?['id'] != wo['id']) return;
        _pending = null;
        _record(wo, 'DECLINED');
        _updated(wo, 'AUTO_DECLINED', system: true);
        _doCheckOut('AUTO_DECLINED');
      });
    });
  }

  _Reply? _answerGuard(String id) {
    if (!_checkedIn) return _Reply.error(409, 'You are not checked in');
    if (_pending?['id'] != id) {
      final known = _history.any((h) => h['id'] == id);
      return known
          ? _Reply.error(409, 'This work order was already answered')
          : _Reply.error(404, 'Work order not found');
    }
    return null;
  }

  _Reply _accept(String id) {
    if (_active != null && _pending?['id'] == id) {
      return _Reply.error(409, 'You are currently marked as unavailable');
    }
    final guard = _answerGuard(id);
    if (guard != null) return guard;
    final wo = {..._pending!, 'status': 'ACCEPTED'};
    _declineTimer?.cancel();
    _pending = null;
    _active = {...wo, 'accepted_at': _iso(_now())};
    _record(wo, 'IN_PROGRESS');
    _updated(wo, 'ACCEPTED');
    _statusChanged('ACCEPTED');
    _repairTimer?.cancel();
    _repairTimer = Timer(repairDuration, () {
      if (_active?['id'] != id) return;
      final done = {..._active!, 'status': 'COMPLETED'};
      _active = null;
      _record(done, 'COMPLETED');
      _updated(done, 'COMPLETED', system: true);
      _statusChanged('REPAIR_FINISHED');
      if (_checkedIn) _scheduleAssignment(delay: assignDelay * 3);
    });
    return _Reply.ok({
      'work_order': wo,
      'status': _status(),
    }, message: 'Work order accepted');
  }

  _Reply _decline(String id) {
    final guard = _answerGuard(id);
    if (guard != null) return guard;
    final wo = {..._pending!, 'status': 'DECLINED'};
    _declineTimer?.cancel();
    _pending = null;
    _record(wo, 'DECLINED');
    _updated(wo, 'DECLINED');
    _doCheckOut('DECLINED');
    return _Reply.ok({
      'work_order': wo,
      'status': _status(),
    }, message: 'Work order declined');
  }

  _Reply _cancel(String id) {
    if (_active?['id'] != id) {
      return _Reply.error(409, 'You have not accepted this work order');
    }
    final wo = {..._active!, 'status': 'DECLINED'};
    _repairTimer?.cancel();
    _active = null;
    _record(wo, 'DECLINED');
    _updated(wo, 'CANCELLED');
    _doCheckOut('CANCELLED');
    return _Reply.ok({
      'work_order': wo,
      'status': _status(),
    }, message: 'Work order cancelled');
  }

  void _updated(
    Map<String, Object?> wo,
    String reason, {
    bool system = false,
  }) => _event(RealtimeEvent.workOrderUpdated, {
    'work_order': wo,
    'reason': reason,
    'by': system
        ? {'source': 'system', 'device_kind': null, 'device_id': null}
        : {
            'source': 'mobile',
            'device_kind': _watchSession ? 'SHARED' : 'PERSONAL',
            'device_id': _watchSession ? _deviceId : null,
          },
    'at': _iso(_now()),
  });

  void _record(Map<String, Object?> wo, String display) {
    _history.removeWhere((h) => h['id'] == wo['id']);
    final finished = display == 'COMPLETED';
    _history.add({
      ...wo,
      'display_status': display,
      'updated_at': _iso(_now()),
      'repair': {
        'reason': null,
        'problem_started_at': wo['created_at'],
        'action_started_at': display == 'IN_PROGRESS' || finished
            ? _iso(_now())
            : null,
        'finished_at': finished ? _iso(_now()) : null,
      },
    });
  }

  _Reply _workOrders(Map<String, String> q) {
    final wanted = (q['status'] ?? '')
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();
    final items = _history.reversed
        .where((h) => wanted.isEmpty || wanted.contains(h['display_status']))
        .toList();
    return _paged(items, q);
  }

  _Reply _workOrderDetail(String id) {
    for (final h in _history) {
      if (h['id'] == id) {
        final machine = h['machine'];
        return _Reply.ok({
          ...h,
          'machine': {
            if (machine is Map) ...machine,
            'type': 'Injection Molding',
          },
          'issue_action': 'Ganti nozzle dan kalibrasi ulang',
        });
      }
    }
    return _Reply.error(404, 'Work order not found');
  }

  _Reply _paged(List<Map<String, Object?>> all, Map<String, String> q) {
    final page = int.tryParse(q['page'] ?? '') ?? 1;
    final perPage = int.tryParse(q['perPage'] ?? '') ?? 20;
    if (perPage > 100) {
      return _Reply.error(400, 'perPage must not be greater than 100');
    }
    final start = (page - 1) * perPage;
    final slice = all.skip(start).take(perPage).toList();
    return _Reply(200, {
      'status_code': 200,
      'message': 'OK',
      'data': slice,
      'pagination': {
        'page': page,
        'per_page': perPage,
        'total_data': all.length,
        'total_pages': all.isEmpty ? 0 : (all.length / perPage).ceil(),
      },
    });
  }

  // ----------------------------------------------------------------- watch

  _Reply _enroll(Map<String, Object?> body) {
    if (body['code'] != demoEnrollmentCode ||
        body['public_key'] is! String ||
        body['signature'] is! String) {
      return _Reply.error(401, 'Invalid or expired enrollment code');
    }
    _deviceId = _uuid.v4();
    return _Reply.ok({
      'device': {'id': _deviceId, 'name': 'Watch 1', 'location': 'Line B'},
      'public_key_fingerprint': 'fake',
    });
  }

  _Reply _deviceMe() => _Reply.ok({
    'id': _deviceId,
    'name': 'Watch 1',
    'location': 'Line B',
    'is_active': true,
  });

  _Reply _createPairing() {
    // Asking again cancels the previous pairing.
    for (final p in _pairings.values) {
      if (p['status'] == 'PENDING') p['status'] = 'CANCELLED';
    }
    final id = _uuid.v4();
    final code = _uuid.v4().replaceAll('-', '').substring(0, 20);
    final pairing = <String, Object?>{
      'pairing_id': id,
      'code': code,
      'status': 'PENDING',
      'expires_at': _iso(_now().add(const Duration(seconds: 60))),
    };
    _pairings[id] = pairing;
    if (autoPairWatch) {
      Timer(autoPairDelay, () {
        if (pairing['status'] != 'PENDING') return;
        _approvePairing(pairing);
      });
    }
    return _Reply(201, {
      'status_code': 201,
      'message': 'Created',
      'data': {
        'pairing_id': id,
        'expires_at': pairing['expires_at'],
        'qr_payload': jsonEncode({'v': 1, 't': 'pair', 'code': code}),
      },
    });
  }

  void _approvePairing(Map<String, Object?> pairing) {
    pairing['status'] = 'APPROVED';
    realtime._send(RealtimeEvent.pairingApproved, {
      'pairing_id': pairing['pairing_id'],
    });
  }

  String _pairingStatus(Map<String, Object?> p) {
    final status = p['status']! as String;
    final expired = !_now().isBefore(
      DateTime.parse(p['expires_at']! as String),
    );
    return status == 'PENDING' && expired ? 'EXPIRED' : status;
  }

  _Reply _pairing(String id) {
    final p = _pairings[id];
    if (p == null) return _Reply.error(404, 'Pairing not found');
    return _Reply.ok({
      'pairing_id': id,
      'status': _pairingStatus(p),
      'expires_at': p['expires_at'],
    });
  }

  _Reply _exchange(String id) {
    final p = _pairings[id];
    final status = p == null ? 'EXPIRED' : _pairingStatus(p);
    if (p == null || status != 'APPROVED') {
      return _Reply.error(409, 'Pairing is $status, not approved');
    }
    p['status'] = 'CONSUMED';
    _watchSession = true;
    final grant = _issueToken(const Duration(hours: 12));
    _pairedWatches
      ..clear()
      ..add({
        'session_id': _sessionId,
        'device': {'id': _deviceId, 'name': 'Watch 1', 'location': 'Line B'},
        'paired_at': _iso(_now()),
        'expires_at': grant['expires_at'],
      });
    return _Reply.ok(grant);
  }

  _Reply _preview(String? code) {
    final p = _pairingByCode(code);
    if (p == null) {
      return _Reply.error(404, 'Pairing code is invalid or expired');
    }
    return _Reply.ok({
      'device': {'name': 'Watch 1', 'location': 'Line B'},
      'expires_at': p['expires_at'],
    });
  }

  _Reply _approve(String? code) {
    if (_watchSession) return _Reply.error(403, 'Not a personal phone session');
    final p = _pairingByCode(code);
    if (p == null) {
      return _Reply.error(404, 'Pairing code is invalid or expired');
    }
    _approvePairing(p);
    return _Reply.ok({
      'device': {'name': 'Watch 1', 'location': 'Line B'},
    });
  }

  Map<String, Object?>? _pairingByCode(String? code) {
    for (final p in _pairings.values) {
      if (p['code'] == code && _pairingStatus(p) == 'PENDING') return p;
    }
    return null;
  }

  _Reply _devices() {
    if (_watchSession) return _Reply.error(403, 'Not a personal phone session');
    return _Reply.ok(_pairedWatches);
  }

  _Reply _unpairWatch(String sessionId) {
    final watch = _pairedWatches.where((w) => w['session_id'] == sessionId);
    if (watch.isEmpty) return _Reply.error(404, 'No such paired watch');
    final wasCheckedIn = _checkedIn;
    if (_checkedIn) _doCheckOut('CHECK_OUT');
    _pairedWatches.removeWhere((w) => w['session_id'] == sessionId);
    realtime._send(RealtimeEvent.watchUnpaired, {
      'session_id': sessionId,
      'reason': 'UNPAIRED',
    });
    return _Reply.ok({'checked_out': wasCheckedIn});
  }

  _Reply _unpairSelf() {
    if (!_watchSession) return _Reply.error(400, 'Not a shared watch session');
    final wasCheckedIn = _checkedIn;
    if (_checkedIn) _doCheckOut('CHECK_OUT');
    _pairedWatches.clear();
    _endSession('LOGOUT', notify: false);
    _watchSession = false;
    return _Reply.ok({'checked_out': wasCheckedIn});
  }

  // ------------------------------------------------------------------ utils

  /// Delivers [name] over the socket and, as an FCM data message, over push.
  void _event(String name, Map<String, Object?> payload) {
    realtime._send(name, payload);
    if (!_push.isClosed) _push.add(PushMessage.encode(name, payload));
  }

  String _iso(DateTime t) => t.toUtc().toIso8601String();

  Map<String, Object?> _decode(Object? data) {
    if (data is Map) return data.cast<String, Object?>();
    if (data is String && data.isNotEmpty) {
      final decoded = jsonDecode(data);
      if (decoded is Map) return decoded.cast<String, Object?>();
    }
    return const {};
  }
}

/// The fake socket. Connects instantly while a session (or an enrolled,
/// unpaired watch) exists and sends `state:snapshot` on every connect.
class FakeRealtimeService implements RealtimeService {
  FakeRealtimeService._(this._backend);

  final FakeBackend _backend;
  final _events = StreamController<RealtimeEvent>.broadcast();
  final _connection = StreamController<bool>.broadcast();
  RealtimeMode? _mode;
  bool _connected = false;

  /// Test hook: simulate a dropped connection.
  void simulateDrop() => _setConnected(false);

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
    _mode = mode;
    reconnectNow();
  }

  @override
  void reconnectNow() {
    final mode = _mode;
    if (mode == null) return;
    final allowed = mode == RealtimeMode.paired
        ? _backend._token != null
        : _backend._deviceId != null;
    if (!allowed) {
      _emit(const RealtimeAuthRejected());
      return;
    }
    scheduleMicrotask(() {
      if (_mode != mode) return;
      _setConnected(true);
      final raw = mode == RealtimeMode.paired
          ? _backend._snapshot()
          : {
              'self': {
                'kind': 'UNPAIRED_DEVICE',
                'device_id': _backend._deviceId,
              },
            };
      // Round-trip through JSON like the real socket.
      _emit(SnapshotReceived(StateSnapshot.parse(jsonDecode(jsonEncode(raw)))));
    });
  }

  @override
  Future<void> stop() async {
    _mode = null;
    _setConnected(false);
  }

  @override
  Future<bool> ack(String workOrderId) async {
    final pending = _backend._pending;
    if (pending?['id'] == workOrderId) pending!['status'] = 'READ';
    return _connected;
  }

  void _send(String name, Map<String, Object?> payload) {
    final mode = _mode;
    if (!_connected || mode == null) return;
    final forUnpaired = name == RealtimeEvent.pairingApproved;
    if (forUnpaired != (mode == RealtimeMode.unpaired)) return;
    if (name == RealtimeEvent.watchPaired ||
        name == RealtimeEvent.watchUnpaired) {
      if (_backend._watchSession) return; // phone only
    }
    // Round-trip through JSON like the real socket.
    final event = RealtimeEvent.parse(name, jsonDecode(jsonEncode(payload)));
    _emit(event);
    if (event is SessionEndedEvent) unawaited(stop());
  }

  void _emit(RealtimeEvent e) {
    if (!_events.isClosed) _events.add(e);
  }

  void _setConnected(bool v) {
    if (_connected == v) return;
    _connected = v;
    if (!_connection.isClosed) _connection.add(v);
  }

  Future<void> _close() async {
    await _events.close();
    await _connection.close();
  }
}

class _Reply {
  _Reply(this.status, this.body);

  /// Success envelope `{ status_code, message, data }`.
  factory _Reply.ok(Object? data, {String message = 'OK'}) =>
      _Reply(200, {'status_code': 200, 'message': message, 'data': data});

  /// NestJS error body `{ message, statusCode }`.
  factory _Reply.error(
    int status,
    String message, {
    Map<String, Object?> extra = const {},
  }) => _Reply(status, {'message': message, 'statusCode': status, ...extra});

  final int status;
  final Map<String, Object?>? body;
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._backend);

  final FakeBackend _backend;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final reply = await _backend._handle(options);
    final headers = {
      'date': [HttpDate.format(_backend._now())],
      Headers.contentTypeHeader: [Headers.jsonContentType],
    };
    return ResponseBody.fromString(
      jsonEncode(reply.body),
      reply.status,
      headers: headers,
    );
  }

  @override
  void close({bool force = false}) {}
}
