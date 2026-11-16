---
name: add-feature-flag
description: Add a Remote Config feature flag or kill switch with a safe compiled-in default. Use when gating unfinished or risky behavior.
---

# Add a feature flag

1. Add a value to `FeatureFlag` in `packages/core/lib/src/flags/feature_flags.dart`
   (`key` in snake_case, `defaultValue` = the safe behavior, usually `false`).
2. Read it with `context.read<FeatureFlags>().isEnabled(FeatureFlag.x)` in UI, or inject `FeatureFlags`
   in a bloc. Never read it inside the FCM background isolate.
3. Values are activated only at safe points (`applyPending()` on start/resume when no popup is open).
   Do not call `applyPending()` yourself mid-flow.
4. A flag that reveals a route must also require the route to exist (see `LoginScreen.onVendorLogin`).
5. Flags are not security controls: the backend still enforces permissions.
6. Tests: default value (`DefaultFeatureFlags()`), enabled (`DefaultFeatureFlags({flag: true})`),
   and the UI both ways.
7. Add the parameter in the Firebase console for every environment and list it in `docs/SETUP.md`.
