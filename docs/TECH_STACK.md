# Tech stack and architecture

What the project uses, and why. Versions are the ones resolved in `pubspec.lock` at the time of writing
(Flutter 3.47.5 / Dart 3.13.4, pinned with FVM in `.fvmrc`). The product spec is
[project_main_documentation.md](project_main_documentation.md); deviations are in [DECISIONS.md](DECISIONS.md).

## 1. The problem in one paragraph

Technicians in a noisy plant must receive a task, answer within 60 seconds, and never miss one silently.
One of the devices (the Newland WD1 II wrist scanner) is **shared** between workers and must log out by
itself at the end of the day. Wi-Fi has dead spots, device clocks can be wrong, and the watch is a
low-power Android 13 device. Most technical choices below follow from these four facts:
**reliability of delivery, shared devices, unreliable network, low-end hardware.**

## 2. Repository shape

```
apps/app_watch        WD1 II app        (no camera, arm64 only)
apps/app_mobile       phone + tablet    (camera scanner, responsive)
packages/core         infrastructure (no UI except tiny helpers)
packages/ui_kit       design system + Indonesian strings
packages/feature_auth             sign-in, session, watch pairing
packages/feature_task             assignment, countdown, results, history
packages/feature_availability     check in/out, readiness, shift end, home
packages/app_shell    composition shared by both apps
packages/device_bridge  small Android plugin
```

Dependency direction (enforced by convention, see `.kiro/steering/architecture-rules.md`):

```
core ◄── ui_kit ◄── feature_auth ─┐
                └── feature_task ─┴─◄ feature_availability ◄── app_shell ◄── app_watch / app_mobile
core uses device_bridge
```

**Why a monorepo with two apps instead of one app with runtime detection**

* The watch must not ship the camera and ML Kit libraries (APK size, startup time, native crash surface).
  Separate apps make that a build-time guarantee; we check it on every `verify-pre-pr` run.
* A phone-only plugin upgrade cannot break the watch build.
* All business logic is shared through packages, so the two apps differ only in their routes and a few screens.

**Why Dart pub workspaces (not Melos)**: one `pubspec.lock`, one `pub get`, no extra tool. The Makefile
covers the multi-package loops Melos would give us.

**Why `app_shell` and `device_bridge` exist** (not in the original spec): see DECISIONS D-01.

## 3. Architecture inside a feature

```
Retrofit API / FCM / Drift
        ▲
Repository  ── returns Result<T>, maps every exception to a Failure
        ▲
Bloc / Cubit ── immutable freezed states
        ▲
Screen  ── built from ui_kit widgets
```

* **No domain layer** (spec section 5): the app is mostly server-driven, so use cases would be thin
  pass-throughs. Repositories hold the little logic there is.
* **`Result<T>` instead of exceptions**: blocs never need `try/catch`, and every error path is visible in
  the type. `ErrorMapper` turns Dio/TLS/socket errors into `NoConnectionFailure`, `DeviceClockFailure`,
  `SessionExpiredFailure` or `ApiFailure(code)`.
* **Bloc vs Cubit**: Bloc where actions need `bloc_concurrency` (no double requests) or events from
  several sources must be ordered (`TaskSessionBloc`, `AvailabilityBloc`, `HistoryBloc`); Cubit everywhere
  else. Folder and file naming: [MAINTENANCE.md §3](MAINTENANCE.md#code-layout-and-naming).
* **App-scoped vs screen-scoped state**: only five objects live for the whole app (`SessionCubit`,
  `TaskSessionBloc`, `AvailabilityBloc`, `ShiftEndCubit`, `AppGateCubit`). Everything else is created by a
  screen and closed with it, so timers and subscriptions cannot leak.

## 4. Libraries and the reason for each

### State, models, DI, routing

| Library | Version | Used for | Why this one |
| --- | --- | --- | --- |
| flutter_bloc | 9.1.1 | All state | Predictable, testable state with `bloc_test`; the team standard in the spec. |
| bloc_concurrency | 0.3.0 | `droppable()` on Terima, Tolak, Check In/Out, Selesai | A double tap sends exactly one request, without manual flags. Needs Bloc events (not Cubit methods), which is why the two action-heavy holders are Blocs (D-02). |
| freezed / freezed_annotation | 4.0.1 / 3.1.0 | States, DTOs, unions | Immutable data with `==`, `copyWith` and sealed unions that the compiler checks in `switch`. |
| json_serializable | 6.15.2 | JSON | Generated, type-safe parsing; snake_case is configured once in `build.yaml`. |
| get_it + injectable | 9.3.0 / 3.0.0 | Dependency injection | Lazy singletons (fast startup) and one micro-package module per package, composed in `app_shell/lib/src/di.dart`. Tests replace dependencies with fakes. |
| go_router | 18.1.3 | Navigation | Declarative routes and one `redirect` that decides the first screen (splash, update, login/welcome, home). |

### Network and storage

| Library | Version | Used for | Why |
| --- | --- | --- | --- |
| dio | 5.11.1 | HTTP | Interceptors: auth with single-flight refresh, server time from the `Date` header, reachability, `SESSION_EXPIRED` handling, redacted debug log. Custom adapter for SPKI certificate pinning. |
| retrofit (+ generator) | 4.10.0 | API clients | Endpoints declared as annotated methods; less hand-written HTTP code. |
| drift (+ drift_flutter) | 2.35.4 / 0.3.1 | Local DB | Plain SQLite with typed queries. Holds the offline queue, the active task, event versions for dedupe, pending result screens and a small cache. It is opened from both the UI isolate and the FCM background isolate (`shareAcrossIsolates`). It stores no secrets, so no SQLCipher. |
| flutter_secure_storage | 11.2.0 | Tokens, session info, device id | Android Keystore / iOS Keychain. Read failures (Keystore reset) wipe the store and return to login instead of looping. |
| connectivity_plus | 7.3.2 | Online state | Combined with real request outcomes, because "Wi-Fi connected" does not mean "backend reachable". |
| uuid, crypto | 4.6.0 / 3.0.8 | Idempotency keys, device id; SHA-256 for pins and APK checks | Small, standard. |

### Push, alerts, device

| Library | Version | Used for | Why |
| --- | --- | --- | --- |
| firebase_messaging | 17.0.1 | Task delivery on all devices | The WD1 II has Google Play Services. FCM reuses the OS connection, so there is no foreground service and no battery drain from our own socket (spec 9.1). Still on the token API, see D-03. |
| flutter_local_notifications | 23.0.0 | Full-screen-intent alert on channel `task_alert_v1` | High-priority FCM messages must show a visible notification. A full-screen intent is the only allowed way to open the popup over the lock screen. Requires AGP 9.1.1, compileSdk 37 and core library desugaring. |
| vibration | 3.2.1 | Foreground alert loop | Vibration is the primary signal in a loud plant; faster pattern in the last 10 s. |
| wakelock_plus | 1.8.2 | Screen on | Only while the QR or the popup is visible (battery). |
| permission_handler | 13.0.2 | Notifications, camera, battery exemption | One API for the readiness checklist. |
| google_api_availability | 5.1.0 | Play Services check | Without Play Services FCM does not work, so Check In is blocked. |
| device_bridge (ours) | – | Full-screen-intent check, channel state, process restart, APK install | Not available in any plugin; about 150 lines of Kotlin. |

### Remote control and updates

| Library | Version | Used for | Why |
| --- | --- | --- | --- |
| firebase_remote_config | 7.0.1 | Feature flags | Behind a `FeatureFlags` interface with compiled-in defaults (all off), so the app behaves correctly offline and the provider can be replaced. |
| firebase_crashlytics | 6.0.1 | Crash and non-fatal reporting | One tool for all devices; `AppLogger` forwards warnings with errors. |
| shorebird_code_push | 2.0.7 | Dart-only patches | Fixes reach MDM-managed devices without a new APK. The watch applies a patch only at a safe point (after the shift-end logout). |
| package_info_plus, pub_semver | 10.2.2 / 2.2.1 | Version gate | Compare the installed version with `min_version` / `latest_version` from `GET app/config`. |

### Time and language

| Library | Version | Used for | Why |
| --- | --- | --- | --- |
| timezone | 0.11.2 | Asia/Jakarta conversion | All times are shown in WIB regardless of the device zone (spec 11). Only the 10-year database is loaded, lazily. |
| intl + flutter_localizations | 0.20.3 | `id_ID` formats, ARB strings | All copy is Indonesian and lives in one ARB file. |
| clock | 1.1.3 | Testable time source | `AppClock` is the only place that reads time; tests freeze it. |

### UI

| Library / asset | Version | Why |
| --- | --- | --- |
| Inter (bundled TTF, OFL) | 4.1 | The designs use Inter; bundled because a network font would fail offline (A.1). |
| lucide_icons_flutter | 4.0.2 | Same line-icon style as the designs (A.1). |
| mobile_scanner | 7.5.0 | QR scanning, **mobile app only**, QR format only. |
| qr_flutter | 4.1.0 | QR rendering, **watch app only** (passed in as a callback so feature packages stay camera- and QR-library free). |

### Testing

| Library | Version | Used for |
| --- | --- | --- |
| flutter_test, bloc_test, mocktail | –, 10.0.0, 1.0.5 | Unit, bloc and widget tests |
| fake_async | 1.3.3 | Countdown, polling and backoff without real waiting |
| alchemist | 0.14.1 | Golden tests in CI mode (text drawn as blocks, identical on Windows and Linux) |
| integration_test | SDK | End-to-end flows against the fake backend |

## 5. Design points worth knowing before changing code

1. **The server owns time and state.** The countdown uses a monotonic `Stopwatch` started from
   `expires_at` minus the server offset (`CountdownCubit`). Changing the device clock does nothing.
   When the local countdown ends, the app asks the server before showing "Waktu Habis".
2. **Events are deduplicated by version** in Drift (`TaskEventProcessor`). FCM can deliver duplicates
   and out-of-order messages; a `task.resolved` that arrives before its `task.assigned` is remembered.
3. **One listener for task pushes**: `TaskSessionBloc`. It also starts and stops the alert on every
   state change, so vibration cannot keep running after the popup closes.
4. **Offline policy**: Check In, Terima, Tolak and pairing need network and are disabled offline.
   Check Out and Selesai are queued in Drift (`OutboxService`) with backoff and idempotency keys.
5. **Session end is one code path**: `SessionCubit.end()` → server logout (best effort) →
   `LocalSessionWiper` (FCM token, secure storage, Drift session tables, alerts). Triggers: Keluar,
   `session.revoked`, refresh rejected, shift end.
6. **The FCM background handler** runs in a separate isolate without DI. It only parses, dedupes in
   Drift, shows or cancels the notification and sends the delivery receipt.
7. **Startup is light**: everything is a lazy singleton; Remote Config and the Shorebird check run after
   the first frame.
8. **The fake backend** (`core/lib/src/network/fake/fake_backend.dart`) implements the whole contract,
   so the dev flavor and the integration tests run without a server. It is refused outside dev.
