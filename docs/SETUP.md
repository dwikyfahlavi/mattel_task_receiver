# Setup

## 1. Toolchain

* FVM with the SDK in `.fvmrc` (currently Flutter 3.47.5 / Dart 3.13.4). All `make` targets call `fvm flutter`.
* Android SDK with platform 37 (installed automatically by Gradle on first build) and JDK 17.
* `make` and `bash` (Git Bash on Windows).

```
make bootstrap codegen l10n   # once after clone
make run APP=mobile ENV=dev   # fake backend, no credentials needed
make run APP=watch ENV=dev
make verify                   # same gate as CI
make setup-check              # lists missing Firebase / Shorebird / signing files
```

The dev flavor without `API_BASE_URL` runs the **in-memory fake backend** (`packages/core/lib/src/network/fake/fake_backend.dart`): sign in with `budi.andika@mattel.test` / `Password123`; a task arrives about 6 s after Check In; the watch QR pairs automatically after about 8 s.

## 2. Runtime configuration (`--dart-define`)

| Define | Required | Purpose |
| --- | --- | --- |
| `API_BASE_URL` | staging, prod (dev optional) | Backend base URL, `https://` only |
| `CERT_PINS` | prod release (at least 2) | Comma-separated base64 SHA-256 SPKI pins, current and backup |
| `USE_FAKE_BACKEND` | no | `true` forces the fake backend (dev only; refused elsewhere) |
| `WATCH_ACCEPT_KEYCODES` | no | Android key codes of the WD1 II side button (default `131,132,133,134,280,293,294`) |

Pass them with `make run DEFINES="--dart-define=API_BASE_URL=https://..."`.

Generate a pin from the server certificate:

```
openssl s_client -connect api.example.com:443 </dev/null | openssl x509 -pubkey -noout \
  | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```

## 3. Credentials and accounts you must provide

Nothing below is in the repository. The app builds and runs without them (Firebase features switch off with a log warning), but production needs all of them.

| What | Where it goes | How |
| --- | --- | --- |
| Firebase Android apps (one per package name, see the table below) | `apps/app_<app>/android/app/src/<env>/google-services.json` | Firebase console > Project settings > Your apps > Add app > Android. Enable Cloud Messaging, Remote Config, Crashlytics. One `google-services.json` may contain several apps: the Gradle plugin picks the client whose package name matches the build. |
| iOS (tablet) Firebase app | `apps/app_mobile/ios/Runner/GoogleService-Info.plist` | Firebase console. iOS flavors/schemes must be created in Xcode on a Mac. APNs key uploaded to Firebase. |
| Remote Config parameters | Firebase console | `vendor_technician_login`, `auto_logout_mobile`, `in_app_apk_update` (all boolean, default `false`) |
| Shorebird account and app ids | `apps/app_watch/shorebird.yaml`, `apps/app_mobile/shorebird.yaml` (commit them; app ids are not secret) | `shorebird login` once per machine, then `shorebird init` **inside each app folder** (`apps/app_watch`, `apps/app_mobile`), not at the repo root. Because of the `dev`/`staging`/`prod` flavors it creates one Shorebird app per flavor (6 in total) under `flavors:`. Packages need no init. CI: create an API key in the Shorebird Console (Account → API Keys) and store it as the `SHOREBIRD_TOKEN` secret. Check that each `shorebird.yaml` has a `flavors:` section with `dev`, `staging`, `prod`; on Windows, if init reports "no Java runtime found", apply the JDK-path workaround in MAINTENANCE.md §6 first. |
| Release keystore | `apps/<app>/android/key.properties` locally, CI secrets in CI | `storeFile`, `storePassword`, `keyAlias`, `keyPassword` |
| Backend URLs and pins | CI variables `PROD_API_BASE_URL`, `PROD_CERT_PINS` | From the backend team |
| Ndevor MDM | MDM console | Battery optimization exemption, POST_NOTIFICATIONS and full-screen intent pre-grant, silent APK install (doc 9.3a / 22 #5) |

### Package names (Firebase apps to register)

| App | dev | staging | prod |
| --- | --- | --- | --- |
| watch (`apps/app_watch`) | `com.altimeda.mattel.watch.dev` | `com.altimeda.mattel.watch.staging` | `com.altimeda.mattel.watch` |
| mobile (`apps/app_mobile`) | `com.altimeda.mattel.mobile.dev` | `com.altimeda.mattel.mobile.staging` | `com.altimeda.mattel.mobile` |
| mobile iOS (tablet) | – | – | bundle id `com.altimeda.mattel.mobile` |

Base ids live in `apps/*/android/app/build.gradle.kts` (`applicationId`, plus `applicationIdSuffix` per flavor).
**Never change them after the first MDM rollout**: Android treats a new package name as a different app.

Place the files:

```
apps/app_watch/android/app/src/{dev,staging,prod}/google-services.json
apps/app_mobile/android/app/src/{dev,staging,prod}/google-services.json
```

With one Firebase project per environment, the watch and mobile folders of the same flavor get the same file
(it lists both apps). With a single Firebase project, the same file goes into all six folders.

### CI secrets (`.github/workflows/ci.yml`)

`ANDROID_KEYSTORE_B64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`, `SHOREBIRD_TOKEN`, `WATCH_GOOGLE_SERVICES_DEV`, `WATCH_GOOGLE_SERVICES_PROD`, `MOBILE_GOOGLE_SERVICES_DEV`, `MOBILE_GOOGLE_SERVICES_PROD` (google-services files base64-encoded). Variables: `PROD_API_BASE_URL`, `PROD_CERT_PINS`.

## 4. Assets

Design sources are kept in `design/assets/` (not bundled). Bundled files:

| Asset | Bundled file | Used by | How it was produced |
| --- | --- | --- | --- |
| Mattel logo | `packages/ui_kit/assets/brands/logo.png` (512x512) | `AppLogoHeader` (both apps) | Rendered from `design/assets/brands/logo_transparent.svg` (it wraps a raster image) |
| "MATTEL" wordmark | `packages/ui_kit/assets/brands/wordmark.svg` | `AppLogoHeader` | Real vector, precompiled at build time by the `vector_graphics_compiler` asset transformer |
| Technician, Available / Unavailable | `apps/app_mobile/assets/illustrations/technician_{success,failed}.png` (600x600) | `TechnicianIllustration` (phone/tablet only; the watch shows none and does not bundle them) | Rendered from `design/assets/illustrations/*.svg` |

**Updating an asset.** Figma exports that contain photos/AI art come out as an SVG wrapping a base64 PNG
(1-2 MB, decoded on every load). Do not bundle those; render them to PNG at the size above with headless
Chrome, which reproduces the SVG exactly (crop, badge):

```
chrome --headless=new --disable-gpu --hide-scrollbars --default-background-color=00000000 ^
  --force-device-scale-factor=1 --window-size=600,600 --screenshot=out.png file:///C:/path/to/source.svg
```

Pure vector SVGs (no `<image>`) can be bundled directly with the transformer, like the wordmark.
`make test` checks that the logo, wordmark and both illustrations load.

### Launcher and notification icons

Generated from the logo by `make icons` (`tool/icons/generate_icon_sources.ps1`, Windows/PowerShell).
Intermediate sources go to `design/assets/icons/`; the Android resources are committed:

| Resource | Where | Notes |
| --- | --- | --- |
| Launcher icon, prod | `apps/*/android/app/src/main/res/mipmap-*/ic_launcher*.png`, `mipmap-anydpi-v26/ic_launcher.xml` | Adaptive (white background, logo in the safe zone), monochrome for Android 13 themed icons, legacy PNG for API 24-25 |
| Launcher icon, dev / staging | `apps/*/android/app/src/{dev,staging}/res/mipmap-*/` | Same icon with a **DEV** / **STG** badge so testers can tell installs apart |
| Notification icon | `apps/*/android/app/src/main/res/drawable-*/ic_stat_task.png` | White starburst silhouette with "MATTEL" cut out (Android renders small icons from alpha only), tinted brand red. Used by the task alert and as the FCM default icon; kept from resource shrinking by `res/raw/keep.xml` |

`flutter_launcher_icons` is not used: its latest release (0.14.4) requires `cli_util ^0.4`, which conflicts
with `vector_graphics_compiler` 1.3.6 (`^0.6`) needed for the wordmark.

The logo source is a 300x300 raster: enough for every on-device icon (largest 432 px), but a 1024 px
store/marketing icon or iOS App Store icon needs a vector logo from the designer. iOS app icons are added
with the iOS flavor setup on a Mac. Icon changes need a new APK (not a Shorebird patch).

## 5. Things to verify on the real WD1 II

* Side-button key code: run `make logcat`, press the button, and set `WATCH_ACCEPT_KEYCODES`.
* Logical screen size (427x320 or 320x240 dp); both are covered by widget tests.
* FCM latency, full-screen intent on Android 13, battery over a shift (doc 9.5).
