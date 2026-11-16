# Multi-Device Task Assignment App (Wearable Watch, Mobile, Tablet)

> **Revision 6.** Added **Appendix A: UI Specification** (design tokens, components and per-platform screens taken from the Figma screenshots, plus design gaps). **Revision 5 content:** Monorepo with separate watch and mobile apps, shared-device shift-end logout, alert and vibration design, Asia/Jakarta time handling, permission readiness check, missed-task explanations, version gate with auto update, feature flags (Vendor Technician as the example), hardened event handling, performance work, testing plan and a Makefile.

## 1. Project Overview & Scope

A cross-platform application built with **Flutter**, delivering **task assignment** to technicians across three form factors:

1. **Android Smartphone (primary hub):** Email/password sign-in, check-in/check-out, scanning the watch QR code to log the watch in, and responding to live task assignments.
2. **Wearable Watch Scanner (Newland WD1 II):** **Shared device** that stays at the plant. Zero-touch login via QR, glanceable task popups with Terima / Tolak, check-in/check-out and task history. Sessions end automatically at the end of the day (section 4.3).
3. **Android / iOS Tablet:** Same task assignment flow as the phone, adapted to a larger screen.

### 1.1 In scope (current phase)

| Area | Platforms |
| ----- | ----- |
| Sign-in (email/password) | Phone, Tablet |
| Watch QR pairing / auto-login | Phone (scanner), Watch (QR display) |
| Availability (Check In / Check Out) | Phone, Tablet, Watch |
| Task assignment (popup, accept / reject / timeout, result and missed-task screens) | Phone, Tablet, Watch |
| Task history ("Riwayat Penugasan") | Phone, Tablet, Watch |
| Shift-end auto check-out and logout | Watch (mandatory), Phone and Tablet (policy flag) |
| App version gate and auto update | All |
| Permission readiness check | All |

### 1.2 Out of scope (future phases)

Vendor Technician login and flow (wired behind a feature flag only, section 14), home dashboard extras, notification center, autonomous maintenance, tags, WO request, profile and language settings, and supervisor dashboards. They are not designed or specified in this document.

## 2. Roles

| Role | Scope in this phase |
| ----- | ----- |
| **Technician** | Full flow: sign in, check in, receive and respond to tasks, pair a watch |

The role returned at login is stored in the session so more roles (Vendor Technician) can be added later without reworking auth.

## 3. Platform Feature Breakdown

> The screens must match the designs. Visual details, tokens and per-screen specs are in **Appendix A**.

### 3.1 Android Phone

* **Sign-in:** Email and password with validation states ("Email tidak valid!", "Password salah!"), a "Tetap masuk di perangkat ini" checkbox, and a disabled Masuk button until both fields are filled. The "Masuk sebagai Vendor Technician" button is controlled by the `vendor_technician_login` feature flag (off by default, section 14). Loading, network-error and "device clock is wrong" states must be designed.
* **Readiness check:** before Check In the app verifies permissions, clock and connectivity (section 12).
* **Availability:** "Siap mulai bekerja?" screen with an Unavailable banner and a **Check In** button. After check-in it shows "Check In Berhasil!" with a timestamp (Jakarta time) and an Available banner. **A Check Out button must be added when Available** (the current designs only show Check In). Check Out is disabled while a task is In Progress.
* **Watch pairing:** "Scan QR Code" opens the camera scanner. After a scan, a confirmation shows the watch short ID ("Masuk ke Watch …1234?") before pairing.
* **Task assignment:** popup with a 60s countdown, task details, and **Terima** / **Tolak** (with confirmation). Result screens: Penugasan Diterima, Penugasan Dialihkan (rejected), Waktu Habis (timeout), plus the missed-task explanations in section 10.3. After accepting, the task is shown as In Progress until the technician taps the completion button.
* **History:** list of In Progress, Selesai and Ditolak/Habis Waktu items, with the reason for missed items.
* **Version gate:** blocking "Perbarui Aplikasi" screen or a soft prompt (section 13).

### 3.2 Wearable Watch (Newland WD1 II)

* **Zero-touch login:** shows a dynamic QR code on startup ("Selamat Datang Kembali", then "Scan QR Code" with "Buat Ulang QR Code" when expired).
* **Availability:** one-tap Check In and "Check Out atau Unavailable".
* **Task popup:** high-contrast full-screen popup with countdown, strong vibration and sound, large Terima / Tolak buttons, rejection confirmation and the same result screens as the phone.
* **History:** simplified scrolling list.
* **Shift end:** a warning banner 15 minutes before the end of the day, then automatic check-out and logout back to the QR screen (section 4.3).
* **Hardware key:** the side button can trigger Terima with a long press (section 17.2).

### 3.3 Tablet

* The same sign-in, availability and task assignment flow as the phone, using the tablet layout of the designs (centered dialogs, wider content).
* No supervisor or master-detail features in this phase.

## 4. Availability, Task State Machine & Session Lifecycle

### 4.1 Technician availability and task flow

```
Unavailable ──(Check In)──► Available ──(Check Out)──► Unavailable
                               │
                               │ (server assigns a task)
                               ▼
                           Assigned  ── 60s window ──┐
                          │        │                  │
                     (Terima)   (Tolak)         (timeout)
                          │        │                  │
                          ▼        └────────┬─────────┘
                      Accepted              ▼
                          │         Reassigned to another technician
                          ▼         → technician becomes Unavailable
                     In Progress   (mobile UI state: blocks new
                          │         tasks and Check Out)
                      (Selesai)
                          ▼
                        Done
```

| From | Trigger | To | Notes |
| ----- | ----- | ----- | ----- |
| Unavailable | Check In | Available | Requires network and a passed readiness check |
| Available | Check Out | Unavailable | Queueable offline (see 16) |
| Available | Server assigns task | Assigned | Server starts a 60s timer |
| Assigned | Terima | Accepted | Requires network, server decides |
| Assigned | Tolak (confirmed) | Reassigned | App calls the reject API; reassignment is handled by the backend. User becomes Unavailable |
| Assigned | 60s elapsed | Reassigned ("Waktu Habis") | Same outcome as reject: user becomes Unavailable and must check in again |
| Accepted | Accept confirmed by server | In Progress | Mobile UI state, see rule 6 |
| In Progress | Selesai | Done | Queueable offline |
| Any | Shift end reached | Session ended | See 4.3 |

### 4.2 Rules

1. **The server owns the clock.** The assignment carries `assigned_at` and `expires_at` (server time). The client countdown is display-only and derived from `expires_at` and the server offset using a monotonic stopwatch (section 7.3). An accept that arrives after expiry is rejected by the server and the client shows Waktu Habis.
2. **Server is the single source of truth.** Accept, reject and complete are requests; the UI moves to the new state only after the server confirms (except the queueable actions in section 16).
3. **One active response per user.** A technician may be signed in on a phone and a watch at once. When one device responds, the server sends `task.resolved` and every other device dismisses its popup.
4. **Idempotency.** Accept, reject and complete send an `Idempotency-Key` header so retries are safe.
5. **Locked and backgrounded app.** An assignment must still reach the user (sections 9 and 10).
6. **In Progress is a mobile UI state.** From Accepted until the user taps the completion button, the app keeps the pending task visible, **disables Check Out** (with the message "Masih ada penugasan yang berjalan"), and does not present a new assignment popup (a client guard; the backend remains responsible for not assigning). The state is persisted locally so it survives an app restart or process kill, and is reconciled with `GET /tasks/current` on launch.
7. **Reject and timeout are backend decisions.** The app only calls accept or reject. Reassignment, retries and escalation are the backend's concern.
8. **Event ordering.** Task events carry a monotonic `version` and are deduplicated (section 7.2).

### 4.3 Shared-device session lifecycle (shift end)

The watch is not taken home. Employees switch at the end of the day, so every session must end by itself.

* The login response (and `GET /session`) includes `session_expires_at` (UTC, derived from the plant's end-of-day in Asia/Jakarta) and `grace_seconds`. **The server is authoritative**: at that time it checks the user out, revokes the session and sends `session.revoked`. The client mirrors this locally so it also works offline.
* The client schedules the cutoff with the corrected server clock, and re-evaluates on app start, resume, boot and connectivity change. If the device was off (battery dead, rebooted) and the cutoff has passed, the session is dropped at startup before any screen is shown.
* **Warning:** 15 minutes before the cutoff, show a non-blocking banner ("Sesi berakhir pukul 15:40").
* **At the cutoff, if no task is In Progress:** best-effort `POST /availability/check-out` and `POST /auth/logout`, then delete the FCM token, wipe secure storage and the local queue (the server has already checked the user out, so queued items are not needed), and return to the QR screen (watch) or the login screen. This is also the safe moment for a Shorebird restart or an app update (section 13).
* **At the cutoff, if a task is In Progress:** do not log the user out in the middle of a job. Show a blocking banner ("Selesaikan penugasan untuk mengakhiri sesi"), end the session as soon as the task is completed, and force it after `grace_seconds` (the backend decides what happens to the task).
* Applies to the **watch always**. For phones and tablets, auto check-out at shift end is always on and the logout is controlled by the `auto_logout_mobile` flag (a phone that goes home with the worker normally keeps "Tetap masuk di perangkat ini").
* Manual Keluar remains available at any time (subject to rule 6).

## 5. Tech Stack

| Area | Technology / Library | Reason |
| ----- | ----- | ----- |
| **Framework** | Flutter, Dart pub workspaces (Melos optional) | One codebase, separate apps per form factor |
| **Architecture** | Simplified Clean Architecture (Data and Presentation), feature-first packages | Faster than a full Domain layer, scales with features |
| **State management** | flutter_bloc (Cubit) + bloc_concurrency | Predictable states; `droppable()` blocks double taps |
| **Models** | freezed + json_serializable | Immutable states and models |
| **DI** | get_it + injectable (micro-packages per feature) | Easy mocking and testing, lazy singletons |
| **Routing** | go_router | Declarative routing, deep link from push into the task popup |
| **Networking** | dio + retrofit | Auth interceptor (single-flight refresh), idempotency keys, error mapping |
| **Local DB** | drift (plain SQLite) | Offline queue and in-progress state. It holds no secrets, so SQLCipher is not needed |
| **Secure storage** | flutter_secure_storage | Tokens only |
| **Push** | firebase_messaging + flutter_local_notifications | FCM-first delivery on all devices |
| **Remote config / flags** | firebase_remote_config | Feature flags and kill switches (section 14) |
| **Crash reporting** | firebase_crashlytics | One tool on all devices |
| **Permissions** | permission_handler | Readiness check (section 12) |
| **Alerts** | vibration, flutter_local_notifications | Vibration patterns and insistent alert (section 10) |
| **Time** | timezone, intl (`id_ID`) | Asia/Jakarta display (section 11) |
| **Version info** | package_info_plus, pub_semver | Version gate (section 13) |
| **Updates** | shorebird_code_push, MDM (Ndevor) for full APKs | Dart patches and full updates |
| **Camera and barcode** | mobile_scanner (mobile app only, QR format only) | Watch pairing scan |
| **QR rendering** | qr_flutter (watch app only) | Display the pairing QR |
| **Connectivity** | connectivity_plus | Offline banner and queue flush |
| **Wakelock** | wakelock_plus | Only on QR screens and the visible popup |
| **Localization** | flutter_localizations + intl | Indonesian copy and formats |
| **Testing** | flutter_test, bloc_test, mocktail, fake_async, clock, alchemist (goldens), integration_test | Section 20 |

## 6. Repository Structure (monorepo)

The watch must not ship phone-only native libraries (camera, ML Kit), and phone plugins must not be able to break the watch build, so the two apps are separate packages that share code.

```
repo/
├── apps/
│   ├── app_watch/                  # Newland WD1 II (QR display, no scanner)
│   │   ├── lib/main_dev.dart, main_staging.dart, main_prod.dart
│   │   └── android/ (flavors: dev, staging, prod)
│   └── app_mobile/                 # Phone and tablet (scanner, responsive layouts)
│       ├── lib/main_dev.dart, main_staging.dart, main_prod.dart
│       └── android/ (flavors: dev, staging, prod)
├── packages/
│   ├── core/                       # network, push, offline, time, permissions, flags, version, session, error, theme tokens
│   ├── ui_kit/                     # shared widgets: buttons, banners, dialogs, countdown badge
│   ├── feature_auth/               # data/ + presentation/ (login, pairing)
│   ├── feature_availability/       # data/ + presentation/ (check in / out, readiness)
│   └── feature_task/               # data/ + presentation/ (assignment, popups, history)
├── Makefile
├── pubspec.yaml                    # workspace root
└── .github/workflows/              # CI
```

Each package exposes an injectable micro-package initializer; each app composes them in `bootstrap()`.

## 7. Architecture, State & Event Handling

### 7.1 Data flow

```
[ Remote API (Dio/Retrofit) | FCM | Drift DB ]
                       ▲
[ Repository Implementation ]  <--- maps exceptions to Failures, merges sources
                       ▲
[ Cubit ]                      <--- emits UI states
                       ▲
[ Presentation View / Screen ]
```

* An **app-scoped `TaskSessionCubit`** is the only listener for FCM task events. It owns the current task, the In Progress flag and the dedupe list. Screen-level cubits are created per screen and closed with it. Avoid other long-lived singletons.

### 7.2 Event ordering and deduplication

FCM can deliver duplicates and out-of-order messages (for example `task.resolved` before `task.assigned`).

* Every event has `task_id` and a monotonic `version`. Ignore any event whose version is lower than or equal to the stored version for that task.
* Keep a short-lived list (about one hour) of resolved task IDs in Drift. A late `task.assigned` for a resolved task is discarded, or shown as a missed task if it was never seen (section 10.3).
* Sending a receipt (`delivered`) for a duplicate is harmless; the backend must treat it as idempotent.

### 7.3 Monotonic countdown (and fewer rebuilds)

Never count down with `DateTime.now()`. Capture the remaining time once at receipt, then count with a `Stopwatch`:

```dart
class CountdownCubit extends Cubit<int> {
  CountdownCubit({required AppClock clock, required DateTime expiresAtUtc})
      : _initial = expiresAtUtc.difference(clock.serverNowUtc()),
        super(0) {
    _watch.start();
    _tick();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
  }

  final Duration _initial;
  final Stopwatch _watch = Stopwatch();
  late final Timer _timer;

  void _tick() {
    final secs = (_initial - _watch.elapsed).inSeconds.clamp(0, 60);
    emit(secs);            // Cubit ignores equal states, so the UI updates once per second
    if (secs == 0) _timer.cancel();
  }

  @override
  Future<void> close() {
    _timer.cancel();
    _watch.stop();
    return super.close();
  }
}
```

* Only the small `CountdownBadge` widget listens to this cubit (`BlocBuilder` or `BlocSelector`). The rest of the popup is `const` and never rebuilds each second.
* A wrong device clock cannot break the window because only the stopwatch and the offset captured at receipt are used. The offset is refreshed from the `Date` header of every API response.
* Cancel timers and subscriptions in `close()`; test that nothing keeps ticking after the popup is closed.

### 7.4 Concurrency

Use `bloc_concurrency` for user actions: `droppable()` on Terima, Tolak, Check In, Check Out and Selesai so a double tap sends a single request.

### 7.5 FCM background handler rules

* The handler is a **top-level function** annotated `@pragma('vm:entry-point')`.
* It runs in a **separate isolate with no GetIt graph**. Keep it tiny: parse the payload, dedupe against Drift (open it directly), show the notification, send the receipt.
* Handle `getInitialMessage()` and notification taps for cold starts, and keep a pending task through the auth guard so a popup is not lost when the app redirects during login or startup.

## 8. Authentication, Pairing & Shared-Device Sessions

### 8.1 Sign-in and session

* Login returns an access token, a refresh token, the role, and the session policy (`session_expires_at`, `grace_seconds`). Tokens are kept in `flutter_secure_storage`.
* **Single-flight refresh.** The Dio interceptor uses one shared refresh future. If several requests get `401` at the same time they wait for the same refresh, so a rotating refresh token is not burned by parallel calls. If the refresh fails, sign out.
* **"Tetap masuk di perangkat ini"** keeps the refresh token across restarts. When off, the session ends when the app is closed.
* **Check-out never wipes the phone or tablet login.** It only sets availability to Unavailable (except at shift end per 4.3).
* **Wipe on session end.** Logout, unpair, `session.revoked` and shift end all do: call the server logout, `FirebaseMessaging.deleteToken()`, unregister the token on the server, wipe secure storage and local state. The server binds an FCM token to the current session only, so the next worker on a shared watch cannot receive the previous user's assignments.
* **Backup and storage failures.** Set `android:allowBackup="false"` plus data-extraction rules so encrypted data is never restored onto another device. If secure storage cannot be decrypted (Keystore reset), wipe it and show the login screen instead of looping.

### 8.2 Pairing sequence

The phone never sends a `user_id`. The server derives the user from the phone's bearer token. FCM carries only a **signal**, never tokens.

```
[Watch]                      [Backend]                     [Android Phone]
   │                             │                               │
   ├─ 1. POST /watch/pair-sessions { device_id, fcm_token }      │
   │                             ├─ create nonce (TTL 30s,       │
   │                             │  single use), bound to        │
   │                             │  device_id                    │
   │◄─ 2. { session_id, pair_code, short_id, expires_at } ───────┤
   │   show QR = { pair_code, device_id }                        │
   │   (while QR is visible: poll session status every ~2s)      │
   │                             │          3. Scan QR ◄─────────┤
   │                             │   4. phone shows "Masuk ke Watch …short_id?"
   │                             │◄─ 5. POST /watch/pair (after the user confirms)
   │                             │   Authorization: Bearer <user token>
   │                             │   { pair_code, device_id }    │
   │                             ├─ validates nonce, not expired,│
   │                             │  not used, device matches     │
   │                             ├─ binds watch to user,         │
   │                             │  invalidates the watch's      │
   │                             │  previous session             │
   │◄─ 6. FCM data: { type: "watch.paired", session_id } ────────┤
   │   (or the next poll sees status = paired)                   │
   ├─ 7. POST /watch/pair-sessions/{session_id}/claim ──────────►│
   │◄─ 8. { session_token, refresh_token, user, session policy } (HTTPS)
   ▼ Home (logged in)                           9. 200 OK ──────►▼
```

Rules:

1. The `pair_code` is server generated, single use, TTL 30s. The watch requests a new session every 30s while the QR is visible and shows "Buat Ulang QR Code" when expired or offline.
2. A screenshot or photo replay fails because the code is single use, short lived and bound to `device_id`.
3. `409` if the code was already used, `410` if expired; the phone shows a clear message for each.
4. **Tokens are never sent through FCM.** FCM only sends the `watch.paired` signal; the watch claims its session over HTTPS. The short status poll (QR screen only, screen already held awake) covers a delayed push.
5. The **confirm step with the watch short ID** prevents pairing the wrong watch in a room with several watches.
6. Re-pairing a watch invalidates its previous session.
7. Rate limit pair-session creation per device and pairing attempts per user.

## 9. Task Delivery (FCM-first)

### 9.1 Decision

The delivered Newland WD1 II units have the Google Play Store, so Google Play Services is available and **FCM is used on watch, phone and tablet**. A persistent socket plus a foreground service drains the battery over a full shift, while FCM uses the single shared Google connection the OS already maintains. Still check Google Play Services availability at runtime and show a clear warning at check-in if it is missing.

### 9.2 Delivery design (all devices)

* Register with `POST /devices/fcm-token { device_id, fcm_token }` on login and whenever the token refreshes.
* The backend sends **high-priority, data-only** messages with a **TTL of about 60s** and the payload in 9.4.
* On receipt the app **immediately shows a full-screen-intent notification** on a dedicated high-importance channel, which opens the task popup via GoRouter deep link. Android deprioritizes high-priority messages that do not show a visible notification, and starting an activity directly from the background is restricted, so always use the notification plus full-screen intent.
* The popup computes remaining time from `expires_at` (7.3). If the message arrives after `expires_at`, show the Waktu Habis missed-task screen (10.3) instead of an actionable popup.
* In the foreground, handle the message directly and show the popup without a notification.
* Send a **delivery receipt** (`POST /tasks/{id}/delivered`) when the message is received.
* On launch, resume and connectivity restored, call `GET /tasks/current` to recover anything FCM missed.

### 9.3 Presence and reachability

FCM gives the backend no presence. Instead of a periodic heartbeat (WorkManager runs at 15 minutes at best and is unreliable under Doze), use:

* the **delivery receipt as the real test**: if no receipt arrives within a few seconds of sending, the backend can reassign immediately instead of waiting for the full 60s (backend decision);
* "last seen" from any API call and from foreground activity;
* a visible **Offline indicator** and a readiness warning in the app, because a technician who looks Available but is offline will miss tasks.

### 9.3a Watch and field settings

* Request exemption from battery optimization via Ndevor MDM, and keep the app out of the restricted standby bucket (the main factor in FCM latency on rugged devices).
* The WD1 II runs Android 13: test `POST_NOTIFICATIONS` and full-screen intent behavior on that version, and grant permissions through MDM so workers never see permission dialogs.
* No foreground service and no persistent connection. Wi-Fi dead spots remain a known problem: show the offline indicator, recover state with `GET /tasks/current`, and log connectivity loss and delivery latency (section 20) so coverage can be mapped.

### 9.4 Message contract (proposed)

```json
{
  "type": "task.assigned",
  "task_id": "…",
  "version": 1,
  "machine_code": "FAR012",
  "area": "Produksi",
  "category": "Tools Problem",
  "assigned_at": "2026-10-27T02:37:59Z",
  "expires_at": "2026-10-27T02:38:59Z"
}
```

Other types: `task.resolved` (with `resolution_reason`, see 10.3), `task.reassigned`, `session.revoked`, `watch.paired` (signal only). All timestamps are UTC.

### 9.5 Real-hardware validation (WD1 II)

1. Delivery latency (server send to popup shown), p50 and p95, with the screen on, screen off, and after long idle (Doze), on Wi-Fi.
2. Behavior after a Wi-Fi drop and reconnect, and after a reboot.
3. Battery drain over a full shift.
4. That the 60s window still leaves enough response time at p95 latency.

If p95 latency is too high for a 60s window, the contingency is a short-lived connection while Available. It is not part of the default design.

## 10. Alerts, Vibration & Missed-Task Explanations

### 10.1 Alert behavior

The plant is loud and the watch is worn, so **vibration is the primary signal**, sound is secondary.

| Aspect | Behavior |
| ----- | ----- |
| Background / locked | Full-screen-intent notification on channel `task_alert_v1` (importance max, vibration on, sound on) |
| Vibration pattern | Strong repeating pattern until the user responds or time runs out, for example 600 ms on, 300 ms off, 600 ms on, 1200 ms pause |
| Sound | Looping (insistent) alert until the notification is cancelled |
| Escalation | In the last 10 seconds the countdown turns red and the vibration becomes faster |
| Screen | Activity shows over the lock screen and turns the screen on (`showWhenLocked`, `turnScreenOn`) |
| Dismiss | The popup is not dismissible by back or outside tap. It survives rotation and process death (state rebuilt from `expires_at`) |
| After response | Vibration and sound stop immediately on Terima, Tolak, timeout, or `task.resolved` from another device |

Implementation notes:

* **Channel settings cannot be changed after creation** (importance, sound, vibration). Version the channel ID (`task_alert_v1`, `task_alert_v2`) and delete the old one when changing it.
* Background alert: configure the vibration pattern and insistent flag on the notification. Foreground alert: loop the pattern with the `vibration` package and cancel it in `close()`.
* Check `canUseFullScreenIntent()` on Android 14+ (it is not granted by default to non-calling apps) and fall back to a heads-up notification with a clear warning in the readiness check.

```dart
const taskChannel = AndroidNotificationChannel(
  'task_alert_v1',
  'Penugasan Baru',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
);

final taskDetails = AndroidNotificationDetails(
  taskChannel.id,
  taskChannel.name,
  category: AndroidNotificationCategory.alarm,
  fullScreenIntent: true,
  timeoutAfter: 60000,                           // auto-cancel with the 60s window
  vibrationPattern: Int64List.fromList([0, 600, 300, 600, 1200]),
  additionalFlags: Int32List.fromList([4]),      // FLAG_INSISTENT: repeat sound until cancelled
  visibility: NotificationVisibility.public,
);
```

### 10.2 Physical key

A long press of about 500 ms on the WD1 II side button accepts the task. A short press does nothing, to prevent accidental accepts. Tolak is never triggered by a hardware key.

### 10.3 Missed and resolved task explanations

A missing popup is confusing, so every end of an assignment produces a clear message. The backend sends `resolution_reason`; the app also derives some cases locally.

| Reason | When | Message (Indonesian) |
| ----- | ----- | ----- |
| `timeout` | No response within 60s | "Waktu Habis. Karena tidak ada respon, tugas ini telah dialihkan ke teknisi lain." |
| `rejected` | The user tapped Tolak | "Penugasan Dialihkan. Karena kamu menolak penugasan, tugas ini telah dialihkan ke teknisi lain." |
| `late_delivery` | The push arrived after `expires_at` | "Waktu Habis. Penugasan masuk terlambat dan sudah dialihkan ke teknisi lain. Periksa koneksi perangkat." |
| `offline_missed` | The device was offline during the window (derived from `GET /tasks/current` or history after reconnect) | "Perangkat tidak terhubung saat penugasan masuk. Tugas ini telah dialihkan." |
| `taken_by_other_device` | Another device of the same user responded | Dismiss the popup silently and show the result in history. |
| `cancelled` | Cancelled by the backend | "Penugasan dibatalkan." |

* Machine, area and problem are always shown in full on the result screen (no ellipsis on critical text).
* Each result screen has the same buttons as the designs: "Check In (UNAVAILABLE)" and "Kembali ke Beranda".
* A result that could not be shown (process killed, screen off) is stored in Drift and shown at the next app resume, then marked as seen. It also appears in history with its reason.

## 11. Time Display (Asia/Jakarta)

* All API timestamps are UTC ISO-8601. **All displayed times use Asia/Jakarta (WIB, UTC+7), regardless of the device time zone**, because the plant is in Jakarta and a wrongly configured device must not show wrong shift times.
* Use the `timezone` package (initialize once at startup with the `Asia/Jakarta` location) and `intl` with the `id_ID` locale (`initializeDateFormatting('id_ID')`).
* One `AppClock` service is the only source of time in the app: `serverNowUtc()` (device time plus server offset), `jakartaNow()`, and `format*` helpers. Widgets never call `DateTime.now()` directly.
* Example display format matching the design: `Sen, 27 Okt 2026 | 09:16` via `DateFormat('EEE, d MMM y | HH:mm', 'id_ID')` applied to the Jakarta-converted time.
* Shift-end logic (section 4.3) uses the same clock.
* **Wrong device clock.** A drained factory scanner can boot with a wrong date, which also breaks TLS certificate validation. Detect large offsets (from the `Date` header) and show "Periksa tanggal dan jam perangkat" instead of a generic network error.

## 12. Permissions & Readiness Check

Silent failures (missed alerts) are the main business risk, so the app verifies its own readiness.

| Check | Phone / Tablet | Watch | On failure |
| ----- | ----- | ----- | ----- |
| Network reachable | Yes | Yes | Block Check In |
| Device clock within tolerance | Yes | Yes | Block Check In, show message |
| Notification permission (`POST_NOTIFICATIONS`) | Yes | Yes (pre-granted by MDM) | Block Check In, offer "Buka Pengaturan" |
| Task alert channel enabled | Yes | Yes | Block Check In |
| Full-screen intent allowed (Android 14+) | Yes | Verify | Warn, continue |
| Google Play Services available | Yes | Yes | Block Check In |
| Battery optimization exempt | Yes | Yes (MDM) | Warn, continue |
| Camera permission | Yes (scanner only, requested when tapping Scan QR Code) | Not used | Explain and offer settings |
| App version supported | Yes | Yes | Version gate (section 13) |

* Implemented with `permission_handler` plus the notification plugin's own checks, behind one `ReadinessService` that returns a list of results. Each result has `severity` (block, warn), a message and an optional action (`openAppSettings`).
* Run the check on each Check In tap, at app start for the watch, and on app resume. When a critical item fails, show a compact checklist with the item and a fix button rather than failing silently.
* Request permissions in context (notification at first Check In, camera at first Scan QR Code), with a short explanation before the system dialog.

## 13. App Version Gate & Auto Update

### 13.1 Version check

`GET /app/config?app=watch|mobile&platform=android&version=1.4.2&build=57` returns:

```json
{
  "min_version": "1.4.0",
  "latest_version": "1.5.0",
  "update_mode": "force | soft | none",
  "apk": { "url": "https://…", "sha256": "…", "release_notes": "…" },
  "server_time": "2026-10-27T02:15:00Z"
}
```

| Condition | Behavior |
| ----- | ----- |
| Current < `min_version` | **Blocking** "Perbarui Aplikasi" screen. The user cannot sign in or check in |
| Current < `latest_version` and mode `soft` | Dismissible prompt, repeated at most once per shift |
| Current >= `latest_version` | Continue |
| Check fails (offline) | Use the last cached result. Allow continuing only if the last known state was compliant, and re-check at the next connectivity |

* Compare with `pub_semver` plus the build number. Check on startup (before login), on resume after more than a few hours, and at shift end.
* The check also returns `server_time`, which refreshes the clock offset.

### 13.2 Auto update paths

| Update type | Mechanism | When it is applied |
| ----- | ----- | ----- |
| Dart code fix | **Shorebird patch** via `shorebird_code_push` (check, download in the background) | On the **next app restart**, done at a safe moment: after the shift-end logout, or when no task is Assigned or In Progress. Never restart during an assignment |
| Full APK (native, plugin, permission change, or version below `min_version`) | **Ndevor MDM push** (preferred, silent on managed devices) | Scheduled outside shift hours |
| Full APK fallback | In-app download, verify `sha256`, then install through the system installer (needs the install-unknown-apps permission and shows a confirmation unless the app is device owner) | User action in the blocking screen |

* A Shorebird patch belongs to a specific release version, so `min_version` and `latest_version` refer to **release** versions.
* The shift-end logout is the natural update point: the watch is idle and the next worker starts on a fresh app.
* Verify the current `shorebird_code_push` API and MDM silent-install options with the vendors before implementing.

## 14. Feature Flags

* Provider: **Firebase Remote Config** behind a small `FeatureFlags` interface so the provider can be replaced.
* **Compiled-in defaults** guarantee behavior when offline or before the first fetch. Fetch on startup (minimum fetch interval 12 h in prod, 0 in dev) and listen for real-time config updates; apply changes at a safe point (for example the next screen build) rather than mid-popup.
* Flags are not security controls. The backend must enforce permissions.

| Flag | Default | Purpose |
| ----- | ----- | ----- |
| `vendor_technician_login` | `false` | Shows the "Masuk sebagai Vendor Technician" entry (feature not built yet) |
| `auto_logout_mobile` | `false` | Logs phones and tablets out at shift end (the watch always logs out) |
| `in_app_apk_update` | `false` | Enables the in-app APK download fallback (13.2) |

Example, using Vendor Technician:

```dart
enum FeatureFlag {
  vendorTechnicianLogin('vendor_technician_login', false),
  autoLogoutMobile('auto_logout_mobile', false),
  inAppApkUpdate('in_app_apk_update', false);

  const FeatureFlag(this.key, this.defaultValue);
  final String key;
  final bool defaultValue;
}

abstract interface class FeatureFlags {
  bool isEnabled(FeatureFlag flag);
}

@LazySingleton(as: FeatureFlags)
class RemoteConfigFeatureFlags implements FeatureFlags {
  RemoteConfigFeatureFlags(this._rc);
  final FirebaseRemoteConfig _rc;

  @override
  bool isEnabled(FeatureFlag flag) {
    try {
      return _rc.getBool(flag.key);
    } catch (_) {
      return flag.defaultValue;
    }
  }
}

// login_screen.dart
if (getIt<FeatureFlags>().isEnabled(FeatureFlag.vendorTechnicianLogin)) {
  OutlinedButton(
    onPressed: () => context.push(Routes.vendorLogin), // route is registered only when the feature package exists
    child: Text(l10n.loginAsVendorTechnician),
  ),
}
```

In this phase the flag stays off, so the button is hidden. When the Vendor Technician feature is built, only the flag value and the new route are added.

## 15. Responsive & Multi-Device UI Strategy

* **Watch:** its own app (`app_watch`) with its own theme and screens. No runtime form-factor guessing.
* **Phone / Tablet:** one app (`app_mobile`) that picks the layout by `shortestSide`, so rotation does not change the choice.

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget phoneLayout;
  final Widget? tabletLayout;
  const ResponsiveLayout({super.key, required this.phoneLayout, this.tabletLayout});

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    return shortestSide >= 600 ? (tabletLayout ?? phoneLayout) : phoneLayout;
  }
}
```

### Watch UI rules

1. **Large action buttons:** touch targets of at least `64x64 dp` for Terima and Tolak.
2. **Zero text typing:** login is purely QR driven.
3. **Glanceable full-screen popups:** high-contrast banner and a clear countdown.
4. **Never truncate critical text** on an assignment popup. Show machine, area and problem in full.
5. **Offline indicator** always visible while the connection is down.

### Tablet rules

* Dialogs have a maximum width (for example 480-560 dp) and are centered.
* Content columns are width constrained so sign-in and lists do not stretch edge to edge.
* Support both orientations.

## 16. Network Resilience & Offline Policy

**Always require network (no queue, no optimistic UI):** Check In, Terima, Tolak, watch pairing. When offline show "Tidak ada koneksi" and disable the action.

**Optimistic and queueable:** Check Out (not while a task is In Progress) and Selesai.

Queue design:

* Stored in **Drift (plain SQLite)**. It contains only the action, task ID, an `Idempotency-Key` and the client timestamp. Tokens and personal data never go in the queue.
* The server records both the client timestamp and its receive time, and may flag implausible gaps.
* Retry with backoff when connectivity returns. Cap the queue size and drop entries older than the shift end.
* On conflict (the task was already closed or reassigned) show a message and reconcile from the server.
* The queue is wiped at shift-end logout; the server has already auto-checked out the user (4.3).

## 17. Security & Hardware

### 17.1 Security

* **Pairing:** see 8.2 (server-side user binding, nonce, TTL, device binding, confirm step, rate limits).
* **Tokens:** short-lived access token, rotating refresh token, wiped by the events in 8.1.
* **Transport:** HTTPS only. Certificate (public key) pinning with **at least two pins** (current and backup) and a rotation plan, so an expired pin cannot lock out the whole fleet.
* **Device integrity:** the watch relies on MDM enrollment. Phones and tablets use the **Play Integrity API** on login and pairing requests, verified by the backend.
* **Storage:** `allowBackup="false"`, secure-storage failure handling (8.1), no secrets in Drift.
* **Logging:** never log tokens, QR payloads, credentials or FCM tokens. Disable the Dio logging interceptor in release builds.
* **Flags are not security controls** (section 14).

### 17.2 Hardware (WD1 II)

* Listen to the side button key events. A long press (about 500 ms) accepts the task while a popup is visible; there is no hardware Tolak.
* Keep the screen awake only while the QR or popup screens are visible.

## 18. Performance & Memory

* **Startup:** use `@lazySingleton` for everything except the minimum. Before the first frame initialize only Firebase, secure storage and the session check; open Drift, Remote Config fetch, version check and timezone data lazily or after the first frame. Keep a lightweight splash and decide the first route (login, QR screen, home, version gate, session expired) in one place.
* **Countdown and rebuilds:** see 7.3. Keep the popup tree `const` where possible and isolate every ticking widget.
* **Lifecycles:** cubits are created per screen with `BlocProvider` and closed with it; cancel timers, vibration loops and stream subscriptions in `close()`/`dispose()`.
* **Lists:** history uses cursor pagination and `ListView.builder`; cached history is cleared at logout.
* **Assets:** precompile SVG with `vector_graphics`; limit the scanner to `BarcodeFormat.qrCode`; no large images on the watch.
* **APK size and speed:** the watch app has no camera or ML Kit dependency (monorepo split), is built for `android-arm64` only, and release builds use `--obfuscate --split-debug-info --tree-shake-icons`. Test on the WD1 II with `--profile`, and verify rendering (Impeller is the default on Android).
* **Battery:** no foreground service, no persistent connection, wakelock only while the QR or popup is visible, and no polling outside the QR screen.
* **CI:** cache `build_runner` outputs and pub caches to keep code generation (freezed, retrofit, injectable, drift) fast.

## 19. Build, Flavors, CI/CD & OTA

### 19.1 Flavors and environments

Each app has `dev`, `staging` and `prod` flavors, each with its own entry point (`lib/main_<env>.dart`), API base URL, Firebase project and app id suffix.

| App | Entry points | Target |
| ----- | ----- | ----- |
| `app_watch` | `main_dev.dart`, `main_staging.dart`, `main_prod.dart` | Newland WD1 II |
| `app_mobile` | `main_dev.dart`, `main_staging.dart`, `main_prod.dart` | Phones and tablets |

### 19.2 Makefile

A `Makefile` at the repo root wraps all common commands (`make help` lists them):

```
make bootstrap                 # pub get for the workspace
make codegen                   # build_runner in every package
make run APP=watch ENV=dev     # run an app (APP=watch|mobile, ENV=dev|staging|prod, DEVICE=<id>)
make test                      # all tests with coverage
make analyze                   # flutter analyze + format check
make build-apk APP=watch ENV=prod
make install APP=watch ENV=prod
make shorebird-release APP=watch ENV=prod
make shorebird-patch APP=watch ENV=prod
make clean
```

### 19.3 CI/CD

* On every pull request: `make bootstrap codegen analyze test`.
* On merge to main: build `dev` flavors of both apps and upload them as artifacts.
* On a version tag: build signed release APKs for both apps, run `make shorebird-release`, and publish the app config (`min_version`, `latest_version`) through the backend.
* Secrets (keystore, API keys, Firebase files) live in the CI secret store.

### 19.4 Base deployment and OTA

* Initial APKs are pushed to the WD1 II through **Ndevor MDM**. Phone and tablet APKs go through MDM or manual install.
* **Shorebird** patches Dart code only. Changes to native code, plugins, permissions, notification channels or the manifest need a new APK. Roll patches out to a staging track and a small group first, keep a rollback path, enable patch signing if the plan supports it, and verify current limits in the Shorebird docs.
* Keep release versions compatible with the API contract and version the API.

## 20. Testing

| Level | Tooling | What to cover |
| ----- | ----- | ----- |
| Unit | `flutter_test`, `mocktail`, `fake_async`, `clock` | Countdown, event ordering and dedupe, state machine, session policy, clock and Jakarta formatting, version comparison, feature flag defaults, offline queue |
| Cubit | `bloc_test` | Login, check in/out, assignment, `droppable()` behavior, In Progress blocking |
| Widget / golden | `alchemist` or `golden_toolkit` | Sign-in states, popup, result and missed-task screens at watch, phone and tablet sizes |
| Integration | `integration_test` with a fake backend | Login, check in, accept / reject / timeout, watch pairing, shift-end logout |
| Real device | WD1 II, one phone, one tablet | FCM latency (9.5), alert vibration and sound, battery over a shift, Doze, reboot, Wi-Fi drop |

Key cases that must have tests:

1. The countdown stays correct when the device clock is changed (monotonic), and stops ticking after close.
2. `task.resolved` arriving before `task.assigned`, duplicate events, and a late assignment after `expires_at`.
3. Parallel `401` responses trigger exactly one token refresh.
4. A double tap on Terima sends one request.
5. Shift end: no logout while a task is In Progress, forced logout after the grace period, expired session detected at cold start, FCM token deleted and storage wiped.
6. Times are shown in Asia/Jakarta when the device time zone is something else.
7. Version gate: force, soft, none, and offline-with-cache.
8. `vendor_technician_login` hides and shows the button according to the flag and falls back to the default when Remote Config is unavailable.
9. Readiness check blocks Check In for each critical failure.

```dart
test('countdown reaches zero after 60s without relying on DateTime.now()', () {
  fakeAsync((async) {
    final clock = FakeAppClock(serverNowUtc: DateTime.utc(2026, 10, 27, 2, 38));
    final cubit = CountdownCubit(
      clock: clock,
      expiresAtUtc: DateTime.utc(2026, 10, 27, 2, 39),
    );
    expect(cubit.state, 60);
    async.elapse(const Duration(seconds: 30));
    expect(cubit.state, 30);
    async.elapse(const Duration(seconds: 31));
    expect(cubit.state, 0);
    cubit.close();
  });
});
```

Also track in production: assignment delivery latency, missed deliveries, accept and timeout rate, connectivity-loss count, queue flush failures, and crash-free sessions (Crashlytics).

## 21. API Contract (proposed, align with backend)

| Purpose | Method and path |
| ----- | ----- |
| Login | `POST /auth/login` |
| Refresh token | `POST /auth/refresh` |
| Logout | `POST /auth/logout` |
| Session info (policy, expiry) | `GET /session` |
| Check In / Check Out | `POST /availability/check-in`, `POST /availability/check-out` |
| Current state (recover missed state) | `GET /tasks/current` |
| Accept / Reject | `POST /tasks/{id}/accept`, `POST /tasks/{id}/reject` |
| Complete | `POST /tasks/{id}/complete` |
| Delivery receipt | `POST /tasks/{id}/delivered` |
| History (paged, filterable) | `GET /tasks/history?status=&cursor=` |
| Register / remove FCM token | `POST /devices/fcm-token`, `DELETE /devices/fcm-token` |
| Create watch pair session | `POST /watch/pair-sessions` |
| Pair watch (phone) | `POST /watch/pair` |
| Claim watch session | `POST /watch/pair-sessions/{id}/claim` |
| Unpair watch | `POST /watch/unpair` |
| App version config | `GET /app/config` |
| Server time | `Date` header on every response (offset), `server_time` in `/app/config` |

Standard error format: `{ "code": "TASK_EXPIRED", "message": "…" }`. Codes include `TASK_EXPIRED`, `TASK_ALREADY_RESOLVED`, `PAIR_CODE_USED`, `PAIR_CODE_EXPIRED`, `SESSION_EXPIRED`, `APP_VERSION_UNSUPPORTED`, `UNAUTHORIZED`.

## 22. Decisions & Remaining Checks

### Decided

* Vendor Technician is deferred and only wired behind the `vendor_technician_login` flag (off).
* Reject and timeout set the user to Unavailable; the user must check in again.
* In Progress is a mobile UI state that blocks new tasks and Check Out until completion.
* Reassignment, retries and escalation are handled by the backend.
* FCM is the delivery channel on all devices, including the watch (Play Store present).
* The watch is shared: sessions end automatically at the end of the day.
* Stack stays Drift + Retrofit + Freezed + Injectable, with Drift as plain SQLite (no SQLCipher).
* Monorepo with separate watch and mobile apps, and a root Makefile.

### To verify or agree

1. **FCM latency on the WD1 II** under battery optimization (9.5).
2. **End-of-day cutoff source:** is `session_expires_at` a fixed plant time or per shift, and how long is `grace_seconds`?
3. **Forgotten check-out and in-progress at cutoff:** confirm with the backend what happens to a task still In Progress when the grace period ends.
4. **Delivery receipt use:** does the backend reassign early when a receipt is missing, and what is the timeout?
5. **MDM capabilities:** silent APK install, battery optimization exemption and permission pre-grant on Ndevor.
6. **Shorebird plan limits** (patch signing, rollout tracks) and the current `shorebird_code_push` API.

---

## Appendix A. UI Specification (from the Figma screenshots)

The app UI must look like the provided designs for the **watch**, **sign-in (phone and tablet)**, **Android phone** and **tablet**. Values below were read from the screenshots (colors were sampled from the pixels). Confirm exact tokens against the Figma file before finalizing.

### A.1 Design tokens

| Token | Value | Used for |
| ----- | ----- | ----- |
| `primary` (blue) | `#155DFC` | Check In, Lanjut, Kembali ke Beranda, machine icon tile, links |
| `success` (green) | `#16A34A` | Terima, Available text, success check, Selesai |
| `danger` (red) | `#DC2626` | Tolak, UNAVAILABLE, alert icons, Waktu Habis and Dialihkan icons, errors |
| `brand` (Mattel red) | `#E81C2C` | Sign-in and watch welcome/QR primary buttons, logo, "MATTEL" wordmark |
| `brand-disabled` | `#F38D95` | Disabled Masuk button |
| `danger-surface` | `#FBEBEB` | Unavailable banner, UNAVAILABLE badge background |
| `success-surface` | `#E8F6ED` | Available banner, AVAILABLE badge background |
| `info-surface` | `#E6F3FA` | Instruction boxes (blue text) |
| `neutral-950` | `#0A0A0A` | Primary text, history icon button, countdown chip |
| `neutral-500` | about `#737373` | Subtitles and captions |
| `neutral-400` | `#A3A3A3` | Placeholders, disabled |
| `neutral-200` | `#E5E5E5` | Borders, dividers |
| `neutral-100` | `#F5F5F5` | Secondary buttons (Scan QR Code, Batal, Kembali ke Beranda) |
| `scan-accent` | `#FDB623` | QR scanner corner brackets and scan line |
| `scrim` | black at about 20-50% | Behind modals |

* **Two reds on purpose:** the Mattel brand red is for sign-in and the watch welcome and QR screens, while `danger` red is for alert and destructive actions in the task flow. The task flow's primary action color is blue.
* **Typography:** a clean geometric sans (looks like Inter). Title 20-24 bold, section title 16-18 semibold, body 14, caption 12, badges 9-10 uppercase semibold. Use the font bundled in the app, not a network font.
* **Shape:** cards and dialogs about 12-16 dp radius, buttons 8-10 dp, chips and badges fully rounded, thin 1 dp `neutral-200` borders, very light shadow on dialogs.
* **Icons:** line icons in the Lucide style (circle-alert, map-pin, timer, refresh-cw, check, hourglass, x-circle, scan). Use one icon set for consistency.
* **Language:** all UI copy is Indonesian. The sign-in screen currently mixes English ("Welcome Back", "Enter your details to access your account"); decide with the designer and drive all copy from the ARB files.

```dart
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary, required this.success, required this.danger, required this.brand,
    required this.dangerSurface, required this.successSurface, required this.infoSurface,
    required this.text, required this.textMuted, required this.border, required this.surfaceMuted,
  });
  final Color primary, success, danger, brand;
  final Color dangerSurface, successSurface, infoSurface;
  final Color text, textMuted, border, surfaceMuted;

  static const light = AppColors(
    primary: Color(0xFF155DFC), success: Color(0xFF16A34A), danger: Color(0xFFDC2626),
    brand: Color(0xFFE81C2C), dangerSurface: Color(0xFFFBEBEB), successSurface: Color(0xFFE8F6ED),
    infoSurface: Color(0xFFE6F3FA), text: Color(0xFF0A0A0A), textMuted: Color(0xFF737373),
    border: Color(0xFFE5E5E5), surfaceMuted: Color(0xFFF5F5F5),
  );
  // copyWith / lerp omitted
}
```

Tokens live in `packages/core` (theme) and the components below in `packages/ui_kit`, so the watch and mobile apps share one look. Only sizing differs per app (watch scale, tablet max widths).

### A.2 Shared components (`ui_kit`)

| Component | Design |
| ----- | ----- |
| `AppLogoHeader` | Red circular Mattel logo with "MATTEL" wordmark |
| `UserHeader` | Blue circle avatar with initials ("BA"), name (bold), role "Technician", and a status badge. Right side: round black icon button that opens history |
| `StatusBadge` | Tiny uppercase pill: UNAVAILABLE (red text on `danger-surface`) or AVAILABLE (green text on `success-surface`) |
| `StatusBanner` | Full-width rounded box, centered title and subtitle. Unavailable: red "Unavailable / Tidak menerima penugasan". Available: green "Available / Siap menerima penugasan" |
| `AppButton` | Variants: primary (blue), success (green), danger (red), brand (red, sign-in/watch), secondary (neutral-100), outlined; full width, with optional leading icon and trailing badge (for example "Check In" with an UNAVAILABLE badge) |
| `CountdownChip` | Black pill with a timer icon and `00:59`. Turns red in the last 10 seconds (section 10.1). Only this widget rebuilds each second |
| `MachineCard` | Bordered card with a blue rounded icon tile and the machine code (for example FAR012) |
| `InfoRow` | Icon plus label: location in blue ("Area Produksi"), problem in red ("Tools Problem"), time in black ("Waktu Diterima" with the date below) |
| `InfoBox` | `info-surface` rounded box with small blue text and an optional info icon |
| `ResultDialog` | Large circle icon (green check, red refresh, or red timer), bold title, grey body, `MachineCard` row with the problem tag on the right, `InfoBox`, and action buttons |
| `ConfirmDialog` | "Tolak Penugasan?" with grey body, danger "Tolak" and secondary "Batal" |
| `HistoryItem` | Bordered row: leading status icon (blue hourglass, green check, red x), title and subtitle, trailing status text ("In Progress" blue, "Selesai" green, "Ditolak/Habis Waktu" red) with the date under it |
| `ScannerOverlay` | Full-screen camera with amber corner brackets, scan line, and a zoom slider with minus and plus |
| `TextField` | Label above, left icon, rounded border, states: empty, focused (grey double ring), error (red label, border and message) |

### A.3 Watch UI (landscape, about 4:3, WD1 II 640x480)

| Screen | Content |
| ----- | ----- |
| Welcome | Logo, "MATTEL", "Selamat Datang Kembali", "Masuk ke akun Anda menggunakan QR Code", brand button "Masuk dengan QR Code", copyright |
| QR | Logo, "Scan QR Code", large QR on white, brand button "Buat Ulang QR Code", copyright. Shows the expired or offline state when the code cannot refresh |
| Home, Unavailable | `UserHeader` with UNAVAILABLE badge, title "Siap mulai bekerja?", subtitle, `StatusBanner` (red), primary button "Check In" |
| Home, Available | Title "Check In Berhasil!", date line `Sen, 27 Okt 2026 | 09:16` (Jakarta time), green banner, danger button "Check Out atau Unavailable" |
| Task popup | Card: "Penugasan Baru" with red alert icon, `CountdownChip`, `MachineCard`, area and problem rows, side-by-side **Terima** (green) and **Tolak** (red) buttons |
| Accepted | "Penugasan Diterima!" with check, machine, area, problem, "Waktu Diterima" with date, primary button "Kembali ke Beranda" |
| Reject confirm | "Tolak Penugasan?", "Task akan dialihkan ke teknisi lain", danger "Tolak" and secondary "Batal" |
| Dialihkan / Waktu Habis | Red circle icon, title, short message, machine row with problem tag, "Check In" button with the UNAVAILABLE badge, secondary "Kembali ke Beranda" |
| History | Back arrow, "Riwayat Penugasan", `HistoryItem` list |

Watch rules:

* No illustration on the watch home screen (the designs have none) and a compact layout.
* **Touch targets at least 64 dp** for Terima, Tolak and the main buttons; the popup buttons are large and side by side.
* **No blur.** The designs show a blurred background behind some dialogs. Use a plain dark scrim on the watch, because `BackdropFilter` is expensive on a low-power GPU.
* Keep the body text readable on a 2.8" screen (minimum about 14 sp body and 12 sp caption), and check the tiny badge text on the real device.
* Skip the phone's two-step accept; the watch goes straight to the accepted details.

### A.4 Sign-in UI (phone and tablet)

* Layout: logo and "MATTEL" at the top-left of the form, "Welcome Back" title, grey subtitle, **Email** field (user icon, placeholder "Masukkan email Anda"), **Password** field (lock icon, placeholder "Masukkan password Anda"), checkbox "Tetap masuk di perangkat ini", brand-red **Masuk** button, a divider, outlined "Masuk sebagai Vendor Technician" (shown only when the feature flag is on), and the copyright at the bottom.
* States from the designs: empty (Masuk disabled in light red), filled and focused (grey double ring), email error ("Email tidak valid!", red label, border and text), password error ("Password salah!").
* **Add** (not in the designs): loading state on the button, network error, locked or inactive account, device-clock error, and a show/hide password toggle.
* Tablet: keep the same content in a centered column with a maximum width of about 440-480 dp instead of stretching fields edge to edge.

### A.5 Android phone UI

| Screen | Content |
| ----- | ----- |
| Home, Unavailable | `UserHeader`, technician illustration with a red x badge, "Siap mulai bekerja?", subtitle, red `StatusBanner`, primary "Check In", secondary "Scan QR Code", caption "Masuk ke Watch dengan Scan QR Code" |
| Home, Available | Illustration with a green check badge, "Check In Berhasil!", date line, green banner, then the same buttons. **Design gap:** the main button must become **Check Out** here |
| QR scanner | Full-screen camera, amber corner brackets and scan line, zoom slider |
| Task popup | Dimmed home behind a centered card. "Penugasan Baru / Respon dalam 1 menit", `CountdownChip`, greeting "Halo, Budi. Ada mesin yang membutuhkan penanganan segera:", `MachineCard`, area and problem rows, blue `InfoBox`, **Terima** (green) and **Tolak** (red) stacked full width |
| Reject confirm | "Tolak Penugasan?" dialog with danger "Tolak" and "Batal" |
| Accepted, step 1 | Big green check, "Penugasan Diterima!", "Segera menuju lokasi dan tangani masalah tersebut", primary "Lanjut" |
| Accepted, step 2 | Detail card: heading "Penugasan Diterima!" and "Baca detail penugasan dengan teliti", machine, area, problem, "Waktu Diterima", `InfoBox`, primary "Kembali ke Beranda" |
| Dialihkan | Red refresh icon, "Penugasan Dialihkan!", "Halo, Budi. Karena kamu menolak penugasan, tugas ini telah dialihkan ke teknisi lain.", machine row, `InfoBox` ("Untuk menerima penugasan kembali, silakan lakukan Check In ulang dengan menekan tombol di bawah."), "Check In" with UNAVAILABLE badge, "Kembali ke Beranda" |
| Waktu Habis | Same layout with a red timer icon and "Karena tidak ada respon, tugas ini telah dialihkan ke teknisi lain." |
| History | "Riwayat Penugasan" list as in A.2 |

### A.6 Tablet UI

* Same screens and copy as the phone, using centered dialogs about 480-560 dp wide.
* In the popup the **Terima and Tolak buttons sit side by side**, and the instruction text is not truncated.
* On the result dialogs, "Check In" (with badge) and "Kembali ke Beranda" sit side by side.
* The home content stays centered with a maximum width; do not stretch the illustration and buttons to the full tablet width. Support portrait and landscape.
* No master-detail or dashboard in this phase.

### A.7 Design gaps and decisions

| # | Observation in the designs | Decision |
| ----- | ----- | ----- |
| 1 | The Available home screen still shows "Check In" and has no Check Out | Show **Check Out** when Available (disabled while a task is In Progress, with the reason shown) |
| 2 | After accept, the text says to press the button when the work is done, but the only button is "Kembali ke Beranda" | Add an **In Progress card on Home** (machine, area, problem, accepted time) with a **Selesai** button. History entries in progress open the same details. New screen to design |
| 3 | The phone popup truncates the greeting ("...penang...") | Never truncate critical text. Let the popup scroll or wrap, and keep Terima and Tolak always visible |
| 4 | Dialihkan and Waktu Habis each have an Unavailable and an Available variant | Use the **Unavailable** variant only (decided) |
| 5 | The sample email in the sign-in design is `john.doe@gmai.com` | Typo in the mock data; use a valid-looking example in the designs and tests |
| 6 | Sign-in has no loading, network-error or show-password design | Add them (A.4) |
| 7 | Backgrounds are blurred behind dialogs | Use a dark scrim, no blur on the watch, and optionally blur only on phones and tablets |
| 8 | The accept flow is two steps on phone and tablet but one step on the watch | Keep as designed |
| 9 | The history entry point is the round icon at the top-right of Home | Keep, with an accessible label |

**Screens that exist in the doc but have no design yet** (to be designed in the same visual language): In Progress home state with Selesai, version gate ("Perbarui Aplikasi", force and soft), readiness checklist (section 12), offline banner and indicator, shift-end warning banner and "sesi berakhir" screen, missed-task variants (late delivery, offline, cancelled), watch QR expired or offline state, phone pairing confirmation ("Masuk ke Watch …1234?") with success and failure, session expired, empty history, and loading skeletons.

### A.8 Implementation and verification

* Build each screen from the `ui_kit` components so the watch, phone and tablet share the same look; only the layout and sizes change per app.
* Add **golden tests** for every screen and state above at watch, phone and tablet sizes (section 20), and review them against the Figma frames.
* Keep illustrations as optimized assets (SVG compiled with `vector_graphics`, or compressed PNG), used on phone and tablet only.
* Keep all copy in the ARB files (Indonesian), including the strings quoted in this appendix.
