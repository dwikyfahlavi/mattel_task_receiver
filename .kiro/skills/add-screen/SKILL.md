---
name: add-screen
description: Add or change a screen, dialog or UI text for watch, phone or tablet, including routing, l10n and the required size tests. Use for any UI work.
---

# Add or change a screen

1. **Copy**: add keys to `packages/ui_kit/lib/l10n/app_id.arb` (Indonesian; placeholders declared with
   `@key`), run `make l10n`.
2. **Build from `ui_kit`** (`AppButton`, `StatusBanner`, `MachineCard`, `InfoRow`, `InfoBox`, `ModalCard`,
   `showConfirmDialog`, ...). Colors only from `AppColors.of(context)`. New reusable pieces go into
   `packages/ui_kit/lib/src/widgets/` and the golden gallery.
3. **Form factors**: branch with `context.isWatch` / `context.isTablet` or `ResponsiveLayout`.
   * Watch (427x320 or 320x240 dp): compact, no illustrations, no blur, main action pinned and >= 64 dp,
     content scrollable, never truncate machine/area/problem.
   * Tablet: `MaxWidth` / `ModalCard` (480-560 dp), both orientations, buttons side by side where the design says so.
4. **Routing**: shared routes live in `packages/app_shell/lib/src/app/shell_app.dart`; app-specific ones in
   `apps/*/lib/src/*_app.dart` (`ShellRoutes`). Task popups/results are not routes; they are the
   `TaskOverlay`, driven by `TaskSessionBloc`.
5. **State**: screen-scoped cubit via `BlocProvider(create: ...)`; no new app-scoped singletons.
   Files: `presentation/<area>/cubit/<name>_cubit.dart` + `<name>_state.dart` (part of), or `bloc/` with
   `_bloc`, `_event`, `_state` when you need `droppable()`; the screen in `<area>/view/<name>_screen.dart`,
   reusable pieces in `<area>/widgets/`. Export new public classes from the package barrel.
6. **Tests** (required): widget test at every `TestScreens.all` size asserting `tester.takeException()`
   is null and the key texts/buttons exist. Add or update a golden if the screen is part of the design.
7. `make verify`; record any deviation from Appendix A in `docs/DECISIONS.md`.
