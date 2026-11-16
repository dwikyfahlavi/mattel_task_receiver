---
name: release-and-patch
description: Cut a release APK, push a Shorebird patch, or decide between them; bump versions and update the version gate. Use for any shipping task.
---

# Release or patch

## Decide
* **Shorebird patch**: Dart-only changes. `make shorebird-patch APP=<app> ENV=prod DEFINES="..."`.
  Patches apply on the next restart; the watch restarts itself only after the shift-end logout.
* **New APK (release)**: any change to native code, plugins, dependencies with native parts, permissions,
  manifest, Gradle, notification channels, or `min_version`. Distribute through Ndevor MDM.

## Release steps
1. Bump `version:` in `apps/<app>/pubspec.yaml` (`x.y.z+build`, build always increases).
2. `make verify`, then `make build-debug APP=<app> ENV=dev` as a smoke test.
3. Tag `vX.Y.Z` -> CI builds signed prod APKs via `make shorebird-release`.
4. Publish `min_version` / `latest_version` / `update_mode` on the backend (`GET app/config`).
   Use **release** versions (a patch keeps the release version).
5. Roll out to the staging track / a small group first; keep the previous APK for rollback.

## Requirements
* Prod builds need `API_BASE_URL` and at least two `CERT_PINS` (the build refuses otherwise).
* Shorebird: `shorebird.yaml` in each app (`shorebird init`), `SHOREBIRD_TOKEN` in CI.
* Signing: `android/key.properties` locally or the `ANDROID_KEY*` CI secrets.
