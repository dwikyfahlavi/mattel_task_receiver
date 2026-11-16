import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

AppConfig build({
  AppEnvironment env = AppEnvironment.dev,
  String url = '',
  String pins = '',
  String fake = '',
  String keys = '',
  bool release = false,
}) => AppConfig.fromValues(
  environment: env,
  kind: AppKind.mobile,
  rawBaseUrl: url,
  rawPins: pins,
  rawFake: fake,
  rawKeys: keys,
  isReleaseBuild: release,
);

void main() {
  test('dev without a base URL talks to the dev backend', () {
    final c = build();
    expect(c.useFakeBackend, isFalse);
    expect(c.apiBaseUrl.toString(), AppConfig.devBaseUrl);
  });

  test('the fake backend is opt-in in dev', () {
    final c = build(fake: 'true');
    expect(c.useFakeBackend, isTrue);
    expect(c.apiBaseUrl.toString(), AppConfig.fakeBaseUrl);
  });

  test('the socket goes to /technician on the API host', () {
    final c = build(url: 'https://api.example.com/');
    expect(c.realtimeUrl.toString(), 'https://api.example.com/technician');
  });

  test('fake backend is refused outside dev', () {
    expect(
      () => build(env: AppEnvironment.staging, url: 'https://x', fake: 'true'),
      throwsStateError,
    );
  });

  test('staging and prod require an https base URL', () {
    expect(() => build(env: AppEnvironment.staging), throwsStateError);
    expect(
      () => build(env: AppEnvironment.prod, url: 'http://x'),
      throwsStateError,
    );
  });

  test('prod release builds need two pins', () {
    expect(
      () => build(
        env: AppEnvironment.prod,
        url: 'https://x',
        pins: 'a=',
        release: true,
      ),
      throwsStateError,
    );
    final c = build(
      env: AppEnvironment.prod,
      url: 'https://x',
      pins: 'a=, b=',
      release: true,
    );
    expect(c.certificatePins, ['a=', 'b=']);
  });

  test('flavor names map to environments', () {
    expect(AppEnvironment.fromFlavor('prod'), AppEnvironment.prod);
    expect(AppEnvironment.fromFlavor('staging'), AppEnvironment.staging);
    expect(AppEnvironment.fromFlavor(null), AppEnvironment.dev);
  });

  test('watch key codes are parsed leniently', () {
    expect(build(keys: '293, x,294').watchAcceptKeyCodes, {293, 294});
  });
}
