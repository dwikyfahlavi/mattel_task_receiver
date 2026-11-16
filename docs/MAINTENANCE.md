# Maintenance guide

For developers joining the project. Read [TECH_STACK.md](TECH_STACK.md) first for the why,
[DEPLOYMENT.md](DEPLOYMENT.md) for shipping, and [SETUP.md](SETUP.md) for accounts and credentials.

## 1. First day

```
fvm install                      # SDK from .fvmrc
make bootstrap codegen l10n
make verify                      # should be green before you change anything
make run APP=mobile ENV=dev      # fake backend: budi.andika@mattel.test / Password123
make run APP=watch ENV=dev       # QR pairs itself after ~8 s
```

Windows: run `make` from Git Bash (or PowerShell with Git's `bash` on PATH). Always use `fvm flutter` /
`fvm dart`; the global Flutter on a machine may be a different version.

## 2. Daily workflow

| When | Command |
| --- | --- |
| After pulling, or after editing a freezed model, Retrofit API, injectable module or Drift table | `make codegen` |
| After editing `packages/ui_kit/lib/l10n/app_id.arb` | `make l10n` |
| Tests of one package | `make test-one PKG=packages/feature_task` |
| Golden images changed on purpose | `make goldens`, then review the PNG diff |
| Before a pull request | `make verify` (same as CI) |
| After Gradle, manifest or plugin changes | `make build-debug APP=watch ENV=dev` and `APP=mobile` |

Generated files (`*.g.dart`, `*.freezed.dart`, `*.config.dart`, `*.module.dart`, `l10n/generated`) are
committed. CI fails if they are stale.

## 3. Where to change what

### Code layout and naming

Every feature package (and `app_shell`) follows the same shape:

```
lib/
  feature_task.dart                 barrel: the only file other packages import
  src/
    data/                           task_api.dart, task_dtos.dart, task_repository.dart
    di/                             feature_task_module.dart (+ generated .module.dart)
    presentation/
      task_session/bloc/            task_session_bloc.dart, task_session_event.dart, task_session_state.dart
      task_popup/cubit/             countdown_cubit.dart
      task_popup/view/              task_popup_screen.dart
      task_result/view/             task_accepted_screen.dart, task_result_screen.dart
      task_result/widgets/          in_progress_card.dart
      history/bloc/                 history_bloc.dart, history_event.dart, history_state.dart
      history/view/                 history_screen.dart, history_labels.dart
```

* `presentation/<area>/` groups one screen or flow. Inside it: `bloc/` or `cubit/` for state,
  `view/` for screens, sheets and dialogs, `widgets/` for reusable pieces of that area.
* Events and states are `part of` their bloc or cubit file. Import only `<name>_bloc.dart` /
  `<name>_cubit.dart`; generated freezed code is `<name>_bloc.freezed.dart` next to it.
* One public class per file, named after the class (`TaskResultScreen` → `task_result_screen.dart`).
* Shared UI components live in `ui_kit`, not in a feature's `widgets/`.

**Bloc or Cubit?** Use a **Bloc** when a user action hits the network and must not run twice
(`droppable()`), or when events come from several sources and need ordering (push, timers, lifecycle).
Everything else is a **Cubit**. Today: Blocs = `TaskSessionBloc`, `AvailabilityBloc`, `HistoryBloc`;
Cubits = `SessionCubit`, `LoginCubit`, `PairWatchCubit`, `WatchPairingCubit`, `ShiftEndCubit`,
`CountdownCubit`, `AppGateCubit`.

| Area | Package | State | Screens |
| --- | --- | --- | --- |
| Session | feature_auth | `session/cubit/` | – |
| Sign-in | feature_auth | `login/cubit/` | `login/view/login_screen.dart` |
| Watch QR login | feature_auth | `watch_pairing/cubit/` | `watch_pairing/view/watch_welcome_screen.dart`, `watch_qr_screen.dart` |
| Phone pairs a watch | feature_auth + app_mobile | `pair_watch/cubit/` | `apps/app_mobile/lib/src/pair_watch/view/scan_watch_screen.dart` |
| Check In / Out | feature_availability | `availability/bloc/` | `home/view/home_screen.dart` |
| Readiness | feature_availability | – (uses `ReadinessService`) | `readiness/view/readiness_sheet.dart` |
| Shift end | feature_availability | `shift_end/cubit/` | banner inside home |
| Task flow | feature_task | `task_session/bloc/`, `task_popup/cubit/` | `task_popup/view/`, `task_result/view/` |
| History | feature_task | `history/bloc/` | `history/view/history_screen.dart` |
| Version gate | app_shell | `gate/cubit/` | `UpdateRequiredScreen` in ui_kit |
| App root / routing | app_shell | – | `app/shell_app.dart`, `routing/`, `view/` |

### Find the file for a task

| I want to... | Go to |
| --- | --- |
| Change UI text | `packages/ui_kit/lib/l10n/app_id.arb` |
| Replace the logo, wordmark or illustrations | sources in `design/assets/`, bundled files and the export procedure in SETUP.md §4 |
| Change colors, radii, sizes | `packages/core/lib/src/theme/app_colors.dart` (`AppColors`, `AppShape`), `packages/ui_kit/lib/src/theme/app_theme.dart` |
| Change a shared widget | `packages/ui_kit/lib/src/widgets/` (update the golden gallery test) |
| Add or change an API call | the feature's `lib/src/data/` + `docs/api_contract.md` + fake backend (skill `add-api-endpoint`) |
| Change error messages for an API code | `ApiErrorCode` in `core/lib/src/error/failure.dart`, `failureText` in `ui_kit/lib/src/failure_text.dart` |
| Change task popup / results / history | `packages/feature_task/lib/src/presentation/` (`task_session/`, `task_popup/`, `task_result/`, `history/`) |
| Change push handling or event ordering | `core/lib/src/push/` (`push_event.dart`, `task_event_processor.dart`, `background_handler.dart`) and `TaskSessionBloc` (skill `push-and-alerts`) |
| Change the alert sound/vibration/channel | `core/lib/src/push/task_notifications.dart`, `core/lib/src/alerts/alert_service.dart` (channel changes need a new APK) |
| Change login, session, logout | `packages/feature_auth/` (`SessionCubit` is the only place that ends a session) |
| Change watch pairing | `feature_auth/lib/src/presentation/watch_pairing/` (watch), `feature_auth/lib/src/presentation/pair_watch/` + `apps/app_mobile/lib/src/pair_watch/view/scan_watch_screen.dart` (phone) |
| Change Check In/Out, readiness, shift end, home | `packages/feature_availability/` and `core/lib/src/permissions/readiness.dart`, `core/lib/src/session/shift_end_policy.dart` |
| Add a feature flag | `core/lib/src/flags/feature_flags.dart` (skill `add-feature-flag`) |
| Add a route | shared: `app_shell/lib/src/app/shell_app.dart` (paths in `app_shell/lib/src/routing/`); app-specific: `apps/*/lib/src/*_app.dart` |
| Change startup order or DI composition | `app_shell/lib/src/bootstrap.dart`, `app_shell/lib/src/di.dart`, `core/lib/src/startup/app_startup.dart` |
| Change offline queue behavior | `core/lib/src/offline/outbox_service.dart` |
| Change the version gate | `core/lib/src/version/version_gate.dart`, `app_shell/lib/src/gate/cubit/app_gate_cubit.dart` |
| Android build settings | `apps/*/android/app/build.gradle.kts`, `apps/*/android/settings.gradle.kts` (keep both apps in sync) |
| CI | `.github/workflows/ci.yml` |

### Remote config (D-23)

Every value below is read from **Firebase Remote Config first**, then the **Firestore document
`app_config/<env>`** (`dev`, `staging`, `prod`; same field names), then the compiled-in default. Keep both
in sync, or use only Firestore if the project stays on the Spark plan. Values apply at the next safe point
(app start, resume, shift end), never mid-popup.

| Key | Example | Default |
| --- | --- | --- |
| `vendor_technician_login`, `auto_logout_mobile`, `in_app_apk_update` | `true` | `false` |
| `task_delivery` | `socket`, `fcm`, `both` | `socket` |
| `shift_schedule` (Asia/Jakarta) | `{"S1":{"start":"07:00","end":"15:00"},"S2":{"start":"15:00","end":"23:00"},"S3":{"start":"23:00","end":"07:00"}}` | same |
| `shift_end_grace_minutes` | `30` | `30` |
| `watch_min_version`, `watch_latest_version`, `mobile_…` | `1.4.0` | none |
| `watch_update_mode`, `mobile_update_mode` | `force`, `soft`, `none` | `none` |
| `watch_apk_url`, `watch_apk_sha256`, `watch_release_notes` (and `mobile_…`) | – | none |

Firestore security rules: the apps only read `app_config/*`; allow `read: if true` on that collection and
no writes from clients.

### Backend changes

The contract is `docs/api_contract.md`. When the backend changes: update the DTOs in `data/`, the error
wording in `ErrorMapper.classify` (the backend sends messages, not codes), the fake backend, and refresh
`docs/backend/openapi-technician.json` with `powershell -File tool/api/extract_openapi.ps1`.

## 4. Rules that are easy to break

The full list is in `.kiro/steering/architecture-rules.md`. The ones reviewers see most:

* No `DateTime.now()` in app code; use `AppClock` (and its `format*` helpers for display).
* Network actions go through Bloc events with `droppable()`.
* Do not handle task pushes outside `TaskSessionBloc` / `TaskEventProcessor`.
* Cancel timers and subscriptions in `close()` / `dispose()`.
* No hard-coded strings or colors in widgets.
* The watch app must not depend on `mobile_scanner` or anything with camera/ML Kit.
* Every new screen needs a widget test at all `TestScreens.all` sizes.
* Never log tokens, QR payloads, credentials or FCM tokens.

## 5. Testing

* Tests live next to each package in `test/`. Shared helpers: `package:ui_kit/testing.dart`
  (`testApp`, `TestScreens`).
* Watch layouts are tested at 427x320 and 320x240 dp because the logical size of the WD1 II depends on
  its reported density. Overflows there are the most common UI bug.
* Integration tests (`apps/*/integration_test`) need a device or emulator and use the fake backend.
* Real-device checks before releases: DEPLOYMENT.md §8.

## 6. Troubleshooting

| Symptom | Cause / fix |
| --- | --- |
| Editor shows "The current Dart SDK version is 3.x. Because ... requires SDK version ^3.13.4" | The editor uses the global Flutter. `.vscode/settings.json` points it to `.fvm/flutter_sdk`; run `fvm install` and reload the window. |
| `shorebird init` / `release` fails with the same SDK error | `shorebird upgrade`; releases pin Flutter with `--flutter-version` (`SHOREBIRD_FLUTTER` in the Makefile). |
| `shorebird init` says "Skipping Android flavor detection: no Java runtime found" (Windows), `shorebird doctor --verbose` shows `JAVA_VERSION: not detected` | Shorebird bug: it runs `java -version` through `cmd.exe` and breaks on JDK paths with spaces (`C:\Program Files\...`). Point Flutter at a space-free link to the same JDK: `cmd /c mklink /J "%LOCALAPPDATA%\jdk-android-studio" "C:\Program Files\Android\Android Studio\jbr"`, then `fvm flutter config --jdk-dir="%LOCALAPPDATA%\jdk-android-studio"`. Confirm with `shorebird doctor --verbose`, then `shorebird init --force` in the app folder. |
| Ran `shorebird init` in the wrong folder | Delete the created `shorebird.yaml`, remove `shorebird.yaml` from that pubspec's `flutter: assets:`, delete the app in the Shorebird Console, then init inside `apps/app_watch` and `apps/app_mobile`. |
| `pub add` changed a package's `analysis_options.yaml` | Restore it to `include: ../../analysis_options.yaml`. |
| `pub get` warns about stray `.dart_tool` / `pubspec.lock` in a package | Delete them; the workspace has one lock file at the root. |
| Missing `*.g.dart` / `*.freezed.dart` / `*.module.dart` errors | `make codegen`. |
| `AppLocalizations` has no getter for a new key | `make l10n`. |
| `format-check` fails right after codegen | Generated files are excluded from formatting; run `make format` for hand-written files. |
| Gradle: plugin version "not found" | Check the version exists on Google Maven / Maven Central; READMEs on GitHub can be ahead of releases. |
| Gradle: "requires core library desugaring" / compileSdk errors | Required by flutter_local_notifications 23; keep `isCoreLibraryDesugaringEnabled`, compileSdk 37 and AGP >= 9.1.1. |
| Gradle warning about plugins applying KGP (firebase_*) | Harmless today; it goes away when those plugins migrate. Watch the changelogs. |
| App stops at start with "Entry point is X but the flavor is Y" | Run with matching `--flavor` and `-t lib/main_<flavor>.dart` (use `make run`). |
| App logs "Firebase is not configured" | No `google-services.json` for that flavor. The app still works without push; see SETUP.md. |
| "Periksa tanggal dan jam perangkat" on a device | Device clock is off by more than 5 minutes or TLS fails on a wrong date. Fix the device time. |
| Task never pops up on a device | Check the readiness checklist (notifications, channel, full-screen intent, Play Services, battery exemption) and `make logcat`. Tasks missed while offline are recovered from `GET tasks/current` on resume. |
| Side button does nothing on the watch | Find the key code with `make logcat` and set `WATCH_ACCEPT_KEYCODES`. |
| Golden test fails after a dependency upgrade | Review the image diff in `test/failures/`; if the change is intended, `make goldens`. |

## 7. Working with Kiro

* **Steering** (`.kiro/steering/`): project rules loaded automatically; update them when a rule changes.
* **Skills** (`.kiro/skills/`): step-by-step playbooks: `add-screen`, `add-api-endpoint`,
  `add-feature-flag`, `push-and-alerts`, `release-and-patch`, `upgrade-dependencies`.
* **Workflows** (`.kiro/workflows/`): `verify-pre-pr` (full gate + both APK builds),
  `spec-compliance-review` (read-only review against the spec), `upgrade-dependencies`.

## 8. Open items owned by the team

From spec section 22 and DECISIONS.md:

* Agree the API contract (`docs/api_contract.md`) with the backend, including the pair-session status endpoint.
* Plan the FCM token → FID migration with the backend (D-03).
* Confirm cutoff source and `grace_seconds`, and what happens to a task still In Progress after the grace period.
* Confirm Ndevor capabilities (silent install, permission pre-grant, battery exemption).
* Measure FCM latency and battery on the WD1 II (spec 9.5).
* Set up iOS flavors and signing on a Mac (DEPLOYMENT.md §10).
* Replace the placeholder logo and illustration.
