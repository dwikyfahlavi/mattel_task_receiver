---
inclusion: fileMatch
fileMatchPattern: "**/*.dart"
---

# Dart and Flutter conventions

* Lints: root `analysis_options.yaml` (strict casts/raw types). Every member's `analysis_options.yaml`
  contains only `include: ../../analysis_options.yaml`; `pub add` sometimes rewrites it, so restore it.
* Folder layout (feature packages and `app_shell`):

  ```
  lib/src/
    data/       <feature>_api.dart, <feature>_dtos.dart, <feature>_repository.dart
    di/         <package>_module.dart
    presentation/<area>/
      bloc/     <name>_bloc.dart   <name>_event.dart   <name>_state.dart
      cubit/    <name>_cubit.dart  <name>_state.dart
      view/     <name>_screen.dart (full pages, dialogs/sheets as <name>_sheet.dart / <name>_dialog.dart)
      widgets/  <widget_name>.dart (reusable inside the area)
  ```

  * `<area>` is a screen or flow in snake_case (`task_session`, `history`, `watch_pairing`).
  * Event and state files are `part of '<name>_bloc.dart'` / `'<name>_cubit.dart'`; the bloc/cubit file holds
    all imports and the `part '<name>_bloc.freezed.dart';` line. Import only the bloc/cubit file.
  * One public class per file, file named after it. Private helpers used by that file only stay in it.
  * Public classes are exported from the package barrel (`lib/<package>.dart`); other packages never import `src/`.
  * Inside a package use relative imports (`../../task_session/bloc/task_session_bloc.dart`).
* Models and states: freezed 4 (`@freezed abstract class X with _$X` / `sealed class` for unions),
  json_serializable with snake_case set in `build.yaml` (no per-field `@JsonKey(name:)`).
  Unknown enum values map to an `unknown` member, never crash.
* Retrofit APIs use relative paths (`tasks/current`); unauthenticated endpoints add
  `@Extra({RequestFlags.skipAuth: true})`; mutating task/availability calls take `@Header('Idempotency-Key')`.
* UI: build from `ui_kit` components and `AppColors` tokens; no hard-coded colors or strings.
  Use `context.formFactor` / `ResponsiveLayout` / `MaxWidth`; never guess the device at runtime on the watch.
  Watch: Terima, Tolak and main buttons at least 64 dp, no blur, never truncate machine/area/problem text.
* Strings: add to `packages/ui_kit/lib/l10n/app_id.arb`, run `make l10n`, use `AppLocalizations.of(context)`.
* Logging: `AppLogger` only. Never log tokens, QR payloads, credentials, FCM tokens or request bodies.
* Keep the editor formatter on; run `make format` before committing.
