# Mattel Task Receiver

Multi-device task assignment for technicians: Newland WD1 II watch, Android phone, Android/iOS tablet.
Specification: [docs/project_main_documentation.md](docs/project_main_documentation.md).

```
make bootstrap codegen l10n
make run APP=mobile ENV=dev      # fake backend: budi.andika@mattel.test / Password123
make run APP=watch ENV=dev
make verify                      # format, analyze, tests (same as CI)
make help
```

## Layout

```
apps/app_watch      WD1 II app (QR login, no camera)
apps/app_mobile     phone + tablet app (scanner, responsive)
packages/core       network, push, offline queue, time, permissions, flags, version, session, theme tokens
packages/ui_kit     shared widgets, theme, Indonesian ARB (lib/l10n/app_id.arb)
packages/feature_auth           sign-in, session lifecycle, watch pairing
packages/feature_task           assignment, countdown, popup, results, history
packages/feature_availability   check in/out, readiness, shift end, home
packages/app_shell  shared composition: DI, version gate, router guard, lifecycle, task overlay
packages/device_bridge  small Android plugin (full-screen intent check, restart, APK install)
```

Dependency direction: `core <- ui_kit <- feature_auth, feature_task <- feature_availability <- app_shell <- apps`.

Integration tests (device or emulator, fake backend): `cd apps/app_mobile && fvm flutter test integration_test --flavor dev` (same for `apps/app_watch`).

## Docs

* [docs/TECH_STACK.md](docs/TECH_STACK.md): what we use and why, architecture and key design points
* [docs/MAINTENANCE.md](docs/MAINTENANCE.md): onboarding, daily workflow, where to change what, troubleshooting
* [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md): environments, releases, Shorebird patches, MDM rollout, rollback, release checklist
* [docs/SETUP.md](docs/SETUP.md): toolchain, dart-defines, **credentials you must provide** (Firebase, Shorebird, signing, MDM)
* [docs/api_contract.md](docs/api_contract.md): request/response shapes the apps implement
* [docs/DECISIONS.md](docs/DECISIONS.md): implementation decisions and deviations
* `.kiro/steering`, `.kiro/skills`, `.kiro/workflows`: rules and playbooks for maintenance with Kiro
