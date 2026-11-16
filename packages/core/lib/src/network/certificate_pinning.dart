import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Public-key (SPKI) pinning helpers (doc 17.1).
///
/// A pin is `base64(sha256(SubjectPublicKeyInfo DER))`, the same format as
/// OkHttp / Android network-security-config pins. Generate one with:
///
/// ```
/// openssl x509 -in cert.pem -pubkey -noout \
///   | openssl pkey -pubin -outform der \
///   | openssl dgst -sha256 -binary | openssl enc -base64
/// ```
///
/// Ship at least two pins (current key and backup key) so a certificate
/// rotation cannot lock out the fleet.
abstract final class CertificatePinning {
  /// Returns true when [certificateDer] carries one of [pins].
  /// Returns false for unparsable certificates (fail closed).
  static bool matches(Uint8List certificateDer, List<String> pins) {
    final spki = extractSpki(certificateDer);
    if (spki == null) return false;
    return pins.contains(pinOf(spki));
  }

  static String pinOf(Uint8List spkiDer) =>
      base64.encode(sha256.convert(spkiDer).bytes);

  /// Extracts the raw `SubjectPublicKeyInfo` element from an X.509 DER
  /// certificate:
  ///
  /// ```
  /// Certificate ::= SEQUENCE { tbsCertificate, signatureAlgorithm, signature }
  /// TBSCertificate ::= SEQUENCE { [0] version OPTIONAL, serialNumber,
  ///   signature, issuer, validity, subject, subjectPublicKeyInfo, ... }
  /// ```
  static Uint8List? extractSpki(Uint8List der) {
    try {
      final cert = _Der(der, 0).read();
      if (cert.tag != 0x30) return null;
      final tbs = _Der(der, cert.valueStart).read();
      if (tbs.tag != 0x30) return null;
      final reader = _Der(der, tbs.valueStart);
      var element = reader.read();
      if (element.tag == 0xA0) element = reader.read(); // explicit version
      // element is serialNumber; skip signature, issuer, validity, subject.
      for (var i = 0; i < 4; i++) {
        reader.read();
      }
      final spki = reader.read();
      if (spki.tag != 0x30) return null;
      return Uint8List.sublistView(der, spki.start, spki.end);
    } on RangeError {
      return null;
    } on FormatException {
      return null;
    }
  }
}

class _Tlv {
  const _Tlv(this.tag, this.start, this.valueStart, this.end);
  final int tag;
  final int start;
  final int valueStart;
  final int end;
}

/// Minimal DER reader: single-byte tags, definite lengths only.
class _Der {
  _Der(this._bytes, this._offset);

  final Uint8List _bytes;
  int _offset;

  _Tlv read() {
    final start = _offset;
    final tag = _bytes[_offset++];
    var length = _bytes[_offset++];
    if (length & 0x80 != 0) {
      final count = length & 0x7F;
      if (count == 0 || count > 4) throw const FormatException('bad length');
      length = 0;
      for (var i = 0; i < count; i++) {
        length = (length << 8) | _bytes[_offset++];
      }
    }
    final valueStart = _offset;
    final end = valueStart + length;
    if (end > _bytes.length) throw const FormatException('truncated');
    _offset = end;
    return _Tlv(tag, start, valueStart, end);
  }
}
