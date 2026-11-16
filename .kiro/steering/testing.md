---
inclusion: fileMatch
fileMatchPattern: "**/test/**"
---

# Testing conventions

* Unit and bloc tests: `flutter_test`, `mocktail`, `bloc_test`, `fake_async`. Register `registerFallbackValue`
  for custom types used with `any()` (a missing fallback breaks later tests in the same file).
* Drift: `AppDatabase(NativeDatabase.memory())`; close it in `tearDown`.
* Time: use a fake `AppClock`; for countdowns pass `stopwatchFactory: async.getClock(start).stopwatch` inside `fakeAsync`.
* Widget tests: wrap with `testApp(child, formFactor: ...)` from `package:ui_kit/testing.dart`, set
  `tester.view.physicalSize` to each `TestScreens.all` size with `devicePixelRatio = 1`, and assert
  `tester.takeException()` is null (catches overflows on the 320x240 watch).
* Provide `AppClock`, `ConnectivityService`, `FeatureFlags`, `PushService`, `RealtimeService` with `RepositoryProvider` as needed.
* Goldens: alchemist CI goldens only (`test/flutter_test_config.dart`). Never animate forever in a golden
  (no loading spinners). Update with `make goldens` and review the PNG diff.
* Required coverage from spec section 20: countdown monotonic and stops after close, out-of-order and
  duplicate events, 401 ends the session, socket+push dedupe, signed text layout, double tap sends one request, shift-end rules,
  Jakarta formatting, version gate modes, feature flag defaults, readiness blocking.
