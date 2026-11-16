# Deployment

How to build, release, patch and roll back both apps. One-time account setup (Firebase, Shorebird,
keystore, MDM) is in [SETUP.md](SETUP.md); this document assumes it is done. Run `make setup-check`
to see which files are still missing.

## 1. Environments

| Flavor | Entry point | Android application id | Backend | Firebase project | Shorebird track |
| --- | --- | --- | --- | --- | --- |
| `dev` | `lib/main_dev.dart` | `com.altimeda.mattel.<app>.dev` | fake (default) or `API_BASE_URL` | dev | `staging` |
| `staging` | `lib/main_staging.dart` | `com.altimeda.mattel.<app>.staging` | staging URL (required) | staging | `staging` |
| `prod` | `lib/main_prod.dart` | `com.altimeda.mattel.<app>` | prod URL (required) | prod | `stable` |

`<app>` is `watch` or `mobile`. The three flavors install side by side on one device.

Rules enforced at startup or build time:

* The entry point and `--flavor` must match, otherwise the app stops at startup (the FCM background
  isolate reads the flavor, so a mismatch would send receipts to the wrong backend).
* Staging and prod refuse the fake backend and require an `https://` `API_BASE_URL`.
* Prod release builds refuse to start with fewer than two `CERT_PINS`.

Build-time values are passed with `DEFINES`, for example:

```
DEFINES="--dart-define=API_BASE_URL=https://api.example.com/v1 --dart-define=CERT_PINS=<pin1>,<pin2>"
```

Use the **same DEFINES** for a release and every patch of that release.

## 2. What kind of update do I need?

| Change | Delivery |
| --- | --- |
| Dart code only (logic, UI, copy, Dart dependencies without native code) | **Shorebird patch** |
| Native code, Flutter plugins, Gradle, AndroidManifest, permissions, notification channel, app icon, Flutter SDK version | **New APK** via MDM |
| Raising `min_version` (forcing users off a version) | **New APK** first, then update the backend config |
| Turning a feature on or off | **Remote Config** flag, no build |

When unsure, ship an APK. A patch that needs native changes will fail at runtime.

## 3. Versioning

* Version lives in `apps/<app>/pubspec.yaml` as `x.y.z+build`. The build number is the Android
  `versionCode` and must **always increase**, otherwise Android refuses the update.
* Watch and mobile are versioned independently.
* A Shorebird patch does **not** change the version. `min_version` and `latest_version` on the backend
  always refer to release (APK) versions.
* Git tag format for a release: `v<x.y.z>` (CI builds both apps from the tag).

## 4. Release (new APK)

### 4.1 Prepare

1. Bump `version:` in the app's `pubspec.yaml`.
2. `make verify` (format, analyze, all tests) and `make build-debug APP=<app> ENV=dev` as a smoke test.
3. Run the integration test on an emulator or device (`cd apps/app_<app> && fvm flutter test integration_test --flavor dev`).
4. Test the staging flavor on real hardware: at least one WD1 II, one phone, one tablet. Use the checklist in §8.

### 4.2 Build through CI (recommended)

Push a tag `vX.Y.Z`. The `release` job in `.github/workflows/ci.yml`:

1. writes the keystore and the prod `google-services.json` from secrets,
2. runs `make shorebird-release APP=<app> ENV=prod` with the prod DEFINES (this creates the Shorebird
   release **and** the signed APK),
3. uploads the APK as a build artifact.

Required secrets and variables are listed in SETUP.md §3.

### 4.3 Build locally (fallback)

```
make shorebird-release APP=watch ENV=prod DEFINES="--dart-define=API_BASE_URL=... --dart-define=CERT_PINS=..."
```

Requires `shorebird login`, `apps/app_watch/shorebird.yaml`, `apps/app_watch/android/key.properties`
and the prod `google-services.json`.

Without Shorebird (no patching possible for this build):

```
make build-apk APP=watch ENV=prod DEFINES="..."
```

This adds `--obfuscate --split-debug-info=build/symbols/<app>-<env> --tree-shake-icons`, and
`--target-platform android-arm64` for the watch.

> **Check the signature.** If no release keystore is found, Gradle falls back to the **debug** key so
> local builds still work. A debug-signed APK cannot update an installed release and must never be
> distributed. Verify with `apksigner verify --print-certs <apk>` before uploading.

> **Keep the keystore safe.** Every future update must be signed with the same key. Losing it means
> uninstalling the app on every device.

### 4.4 Keep the debug symbols

Obfuscated builds produce symbol files in `build/symbols/<app>-<env>`. Archive them per version, and
upload them to Crashlytics so stack traces are readable:

```
firebase crashlytics:symbols:upload --app=<FIREBASE_ANDROID_APP_ID> build/symbols/<app>-prod
```

### 4.5 Roll out with Ndevor MDM

1. Upload the signed APK to Ndevor.
2. Target a **pilot group** first (a few watches and phones), outside shift hours.
3. Confirm the MDM policies are still applied after install: battery optimization exemption,
   `POST_NOTIFICATIONS` and full-screen intent pre-granted (spec 9.3a).
4. After one shift without issues, roll out to all devices, scheduled outside shift hours.
5. Phones and tablets that are not managed: distribute the APK manually, or enable the in-app fallback
   (§6).

### 4.6 Update the version gate

Only after the APK is installed on the fleet, update `GET app/config` on the backend:

* `latest_version` = new version, `update_mode: soft` → users get a dismissible prompt once per shift day.
* `min_version` = new version (or `update_mode: force`) → older versions are blocked with "Perbarui Aplikasi".
  Do this only when old versions must stop working (for example a breaking API change).
* `apk: { url, sha256 }` only if the in-app fallback is used.

Raising `min_version` before the APK reaches the devices locks technicians out.

## 5. Shorebird patch (Dart-only fix)

1. Make the fix on a branch from the **release tag** that is installed on the devices.
   A patch applies to exactly one release version.
2. `make verify`.
3. Patch with the same flavor, entry point and DEFINES as the release:

```
make shorebird-patch APP=watch ENV=prod DEFINES="--dart-define=API_BASE_URL=... --dart-define=CERT_PINS=..."
```

4. How the app applies it (`PatchUpdater` in `core/lib/src/update/update_services.dart`):
   * The app checks and downloads in the background after the first frame and on resume.
   * **Watch**: restarts itself after the shift-end logout (no one signed in, nothing in progress).
   * **Phone/tablet**: the patch is applied on the next cold start.
   * Prod builds read the `stable` track; dev and staging builds read the `staging` track.
5. To pilot a patch, patch the **staging** flavor release first and test it on staging devices, then patch prod.
   Check the current Shorebird CLI and console for track promotion and patch rollback options; they
   change between Shorebird versions.

Do not patch changes listed under "New APK" in §2.

## 6. In-app APK fallback (unmanaged devices)

Disabled by default. To use it:

1. Set Remote Config `in_app_apk_update = true` for the target environment.
2. Host the signed APK on HTTPS and put `apk: { url, sha256 }` in `GET app/config`.
3. The update screen downloads it, verifies SHA-256, then opens the system installer. The user must
   allow "install unknown apps" for this app; Android always asks for confirmation unless the app is device owner.

## 7. Rollback

| Problem | Action |
| --- | --- |
| Bad Shorebird patch | Roll the patch back in the Shorebird console/CLI. Devices return to the release code on their next restart. |
| Bad feature behind a flag | Turn the Remote Config flag off. Applied on the next app start or resume. |
| Bad APK | Android does not allow installing a lower `versionCode`. Build the previous good code with a **higher** build number (e.g. `1.4.2+58` → re-release 1.4.1 code as `1.4.3+59`) and push it through MDM. |
| Version gate blocks users by mistake | Lower `min_version` / set `update_mode: none` on the backend. The blocking screen has a "Coba Lagi" button that rechecks immediately; otherwise devices recheck at the next app start, on resume after 3 hours, or on reconnect after an offline check. |

## 8. Release checklist (real devices, staging flavor)

* [ ] Phone: login, "Tetap masuk" on and off (kill app and reopen), wrong password, airplane mode message.
* [ ] Watch: QR login from the phone scanner, confirm step shows the right short id, "Buat Ulang QR Code".
* [ ] Check In passes readiness; turn off notifications → Check In blocked with a fix button.
* [ ] Task arrives with screen on, screen off, and app killed; full-screen popup, vibration, countdown.
* [ ] Terima (watch: side-button long press), Tolak with confirmation, timeout → Waktu Habis + Unavailable.
* [ ] Answer on phone while the watch shows the same popup → watch closes it silently.
* [ ] In Progress blocks Check Out; Selesai offline is queued and sent after reconnect.
* [ ] Shift end: banner 15 min before; logout at the cutoff (watch); no logout while In Progress.
* [ ] Times shown in WIB with the device set to another time zone.
* [ ] Version gate: soft prompt and force screen with a test config.
* [ ] Battery over a full shift and FCM latency (spec 9.5) for major releases.

## 9. CI reference

| Trigger | Job | Result |
| --- | --- | --- |
| Pull request | `verify` | `make bootstrap codegen l10n analyze test` and a check that generated files are committed |
| Push to `main` | `build-dev` | Debug APKs of both apps (dev flavor) as artifacts |
| Tag `v*` | `release` | Shorebird releases and signed prod APKs as artifacts (uploading to MDM stays manual) |

CI installs Flutter `3.47.5` (`FLUTTER_VERSION` in `ci.yml`). Keep it equal to `.fvmrc` / `fvm flutter --version`
and to `SHOREBIRD_FLUTTER` in the Makefile (Shorebird bundles its own Flutter; `--flutter-version` pins it,
check available versions with `shorebird flutter versions list`). When upgrading Flutter, change all three together.

## 10. iOS tablet

The code supports iOS, but iOS flavors (Xcode schemes and build configurations for dev/staging/prod),
signing, the APNs key in Firebase and `GoogleService-Info.plist` are **not set up yet**. This needs a
Mac with Xcode. Until then, iOS runs only for local testing with `lib/main_dev.dart` and no `--flavor`
(the startup check treats a missing flavor as dev and rejects the staging/prod entry points).
