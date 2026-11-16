---
name: upgrade-dependencies
description: Upgrade Flutter, Dart packages or Android Gradle versions safely in the workspace. Use when bumping SDKs or libraries.
---

# Upgrade dependencies

1. `fvm flutter pub outdated` at the root. Upgrade one area at a time
   (codegen stack, Firebase, notifications, networking, UI).
2. Use `fvm flutter pub add <pkg>` inside the member package (keeps constraints consistent). Afterwards
   restore that member's `analysis_options.yaml` to `include: ../../analysis_options.yaml` (pub rewrites it).
3. Read each package's CHANGELOG for breaking changes. Known hot spots:
   * `flutter_local_notifications`: AGP / compileSdk / desugaring requirements (`apps/*/android/app/build.gradle.kts`).
   * `firebase_messaging`: token API (see DECISIONS D-03).
   * `freezed`, `retrofit_generator`, `injectable_generator`, `drift_dev`: run `make codegen` and review the diff.
4. Gradle plugin versions live in `apps/*/android/settings.gradle.kts`; verify versions exist on
   Google Maven before using them (READMEs are sometimes ahead of releases).
5. `make verify`, then `make build-debug APP=watch ENV=dev` and `APP=mobile`.
6. Confirm the watch APK still has no camera/ML Kit classes.
7. Native or plugin changes require a new APK release, not a Shorebird patch.
