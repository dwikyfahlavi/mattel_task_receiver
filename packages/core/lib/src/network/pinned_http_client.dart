import 'dart:io';

import 'certificate_pinning.dart';

/// A `dart:io` [HttpClient] that only trusts the platform store and, when
/// [pins] are given, only servers whose SPKI matches one of them.
///
/// Used for the Socket.IO websocket, which does not go through Dio. The pin
/// is checked on the TLS socket before any byte of the handshake (and the
/// token in it) is sent.
HttpClient pinnedHttpClient(List<String> pins) {
  final client = HttpClient()..badCertificateCallback = (_, _, _) => false;
  if (pins.isEmpty) return client;
  client.connectionFactory = (uri, proxyHost, proxyPort) async {
    final port = uri.hasPort ? uri.port : 443;
    final task = await SecureSocket.startConnect(uri.host, port);
    final verified = task.socket.then((socket) {
      final cert = socket.peerCertificate;
      if (cert == null || !CertificatePinning.matches(cert.der, pins)) {
        socket.destroy();
        throw const HandshakeException('Certificate pin mismatch');
      }
      return socket;
    });
    return ConnectionTask.fromSocket(verified, task.cancel);
  };
  return client;
}
