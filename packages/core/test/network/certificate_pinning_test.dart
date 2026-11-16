import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Self-signed P-256 certificate and its pin, generated with openssl:
  //   openssl x509 -pubkey -noout | openssl pkey -pubin -outform der
  //   | openssl dgst -sha256 -binary | base64
  const certDer =
      'MIIBiTCCAS+gAwIBAgIUB4luQjjM16RNTAxacGEBzeTKAkYwCgYIKoZIzj0EAwIwGjEYMBYGA1UEAwwPYXBpLm1hdHRlbC50ZXN0MB4XDTI2MTEwOTAzMzcwMVoXDTM2MTEwNjAzMzcwMVowGjEYMBYGA1UEAwwPYXBpLm1hdHRlbC50ZXN0MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEWDSc4ZPIE6M6dIlLvpb1eKN821hWHei83/ucROAAzx/kd5A7hNg51ftsU6aJR44eTDYRbeinNd5W2xE9S7lSc6NTMFEwHQYDVR0OBBYEFGjUKkWhc6eKlD8Fa+h1ik4X+Ex9MB8GA1UdIwQYMBaAFGjUKkWhc6eKlD8Fa+h1ik4X+Ex9MA8GA1UdEwEB/wQFMAMBAf8wCgYIKoZIzj0EAwIDSAAwRQIgPjVDItuaXVi3AUsn6huvYNAUXzs/JyVAGqtCP7QBMNoCIQCfACK7o27l84X+VjMcHoQ1UxadNQqVwEnPyeuELnSGhg==';
  const expectedPin = 'sqtMPLqoE7sJzvBR0W89pDk1OfJ/bD9qI8n8CjNTDps=';

  final der = base64.decode(certDer);

  test('SPKI pin matches the openssl-computed value', () {
    final spki = CertificatePinning.extractSpki(der);
    expect(spki, isNotNull);
    expect(CertificatePinning.pinOf(spki!), expectedPin);
  });

  test('matches when the pin is one of several (current + backup)', () {
    expect(
      CertificatePinning.matches(der, ['backupPin=', expectedPin]),
      isTrue,
    );
  });

  test('fails closed for unknown pins and garbage input', () {
    expect(CertificatePinning.matches(der, ['other=']), isFalse);
    expect(
      CertificatePinning.matches(base64.decode('AAEC'), [expectedPin]),
      isFalse,
    );
  });
}
