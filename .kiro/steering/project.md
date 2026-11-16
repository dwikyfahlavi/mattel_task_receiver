# Project: Mattel Task Receiver

Flutter monorepo (Dart pub workspace) delivering task assignments to technicians on a Newland WD1 II
watch, Android phones and Android/iOS tablets. The specification is
#[[file:docs/project_main_documentation.md]]; decisions taken during implementation are in
#[[file:docs/DECISIONS.md]]. When the code and the spec disagree, check DECISIONS.md first, then ask.

Developer docs: `docs/TECH_STACK.md` (why each library), `docs/MAINTENANCE.md` (where to change what),
`docs/DEPLOYMENT.md` (release, patch, rollback). Keep them in sync when the stack or the release process changes.

## Layout and dependency direction

`core <- ui_kit <- feature_auth, feature_task <- feature_availability <- app_shell <- apps/app_watch, apps/app_mobile`
(`device_bridge` is an Android plugin used by core). Never add an edge against this direction.

* Camera scanning lives in `packages/camera_scanner` (apps only, both may use it, D-25); feature packages receive
  a scan callback and never depend on camera packages.
* Backend contract: `docs/api_contract.md` and `docs/technician-app-implementation-guide (1).md`.
* `qr_flutter` is watch-only; feature packages receive renderers as callbacks.

## Commands (always through make / FVM)

* `make bootstrap codegen l10n` after pulling or editing models, APIs, DI or ARB files.
* `make verify` before declaring work done (format check, analyze, all tests).
* `make test-one PKG=packages/<name>` for a single package; `make goldens` to update goldens.
* `make build-debug APP=watch|mobile ENV=dev` to prove Android still builds after Gradle/manifest/plugin changes.
* Use `fvm flutter` / `fvm dart`, never a global SDK.

## Definition of done

1. Code generated and committed (`*.g.dart`, `*.freezed.dart`, `*.config.dart`, `*.module.dart`, l10n).
2. `make verify` green; new behavior has unit/bloc tests; new or changed screens have widget tests at
   every size in `TestScreens.all` (watch 427x320 and 320x240, phone, tablet portrait/landscape).
3. Copy only in `packages/ui_kit/lib/l10n/app_id.arb` (Indonesian).
4. API changes reflected in `docs/api_contract.md` and the fake backend.
5. Deviations from the spec recorded in `docs/DECISIONS.md`.
