# ------------------------------------------------------------------
# Task Assignment App - developer commands
# Usage: make help
# Requires: FVM (pinned SDK in .fvmrc), bash (Git Bash on Windows).
# ------------------------------------------------------------------

.DEFAULT_GOAL := help
SHELL := bash

# Use the FVM-pinned SDK. Override with FLUTTER=flutter DART=dart if needed.
FLUTTER ?= fvm flutter
DART    ?= fvm dart
ADB     ?= adb

# APP = watch | mobile, ENV = dev | staging | prod
APP    ?= mobile
ENV    ?= dev
DEVICE ?=
# Extra --dart-define flags, e.g. DEFINES="--dart-define=API_BASE_URL=https://..."
DEFINES ?=

APP_DIR  := apps/app_$(APP)
ENTRY    := lib/main_$(ENV).dart
DEVICE_FLAG := $(if $(DEVICE),-d $(DEVICE),)
APK_PATH := $(APP_DIR)/build/app/outputs/flutter-apk/app-$(ENV)-release.apk
SYMBOLS  := build/symbols/$(APP)-$(ENV)

# Watch is built for arm64 only to keep the APK small (doc 18)
ARCH_FLAG := $(if $(filter watch,$(APP)),--target-platform android-arm64,)

PACKAGES := $(wildcard packages/*)
APPS     := $(wildcard apps/*)
ALL_PKGS := $(PACKAGES) $(APPS)
# Dependency order (core <- ui_kit <- feature_auth, feature_task <-
# feature_availability <- app_shell <- apps): a package's generated code can
# reference generated types of the packages before it.
CODEGEN_ORDER := packages/core packages/ui_kit packages/feature_auth \
    packages/feature_task packages/feature_availability packages/app_shell \
    $(filter-out packages/core packages/ui_kit packages/feature_auth \
        packages/feature_task packages/feature_availability packages/app_shell, \
        $(PACKAGES)) $(APPS)

.PHONY: help check-args doctor bootstrap codegen codegen-watch l10n analyze format format-check \
	    test test-one goldens icons verify run run-watch run-mobile build-apk build-watch build-mobile \
	    build-debug install devices logcat shorebird-release shorebird-patch clean clean-all setup-check

help: ## Show this help
	@echo "Task Assignment App"
	@echo ""
	@echo "Variables: APP=watch|mobile (default mobile)  ENV=dev|staging|prod (default dev)  DEVICE=<adb id>  DEFINES=..."
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

check-args:
	@case "$(APP)" in watch|mobile) ;; *) echo "APP must be watch or mobile"; exit 1;; esac
	@case "$(ENV)" in dev|staging|prod) ;; *) echo "ENV must be dev, staging or prod"; exit 1;; esac
	@test -d "$(APP_DIR)" || { echo "$(APP_DIR) not found"; exit 1; }

doctor: ## Check the Flutter and Dart toolchain
	$(FLUTTER) doctor -v

setup-check: ## Report which external configs (Firebase, Shorebird, signing) are present
	@for app in watch mobile; do for env in dev staging prod; do \
	    f=apps/app_$$app/android/app/src/$$env/google-services.json; \
	    if [ -f $$f ]; then echo "OK      $$f"; else echo "MISSING $$f"; fi; \
	done; done
	@for app in watch mobile; do \
	    if [ -f apps/app_$$app/shorebird.yaml ]; then echo "OK      apps/app_$$app/shorebird.yaml"; else echo "MISSING apps/app_$$app/shorebird.yaml (run: shorebird init)"; fi; \
	    if [ -f apps/app_$$app/android/key.properties ]; then echo "OK      apps/app_$$app/android/key.properties"; else echo "MISSING apps/app_$$app/android/key.properties (release signing)"; fi; \
	done

bootstrap: ## Install dependencies for the whole workspace
	$(FLUTTER) pub get

codegen: ## Run build_runner (freezed, retrofit, injectable, drift) in every package
	@for pkg in $(CODEGEN_ORDER); do \
	    if grep -q "build_runner" $$pkg/pubspec.yaml 2>/dev/null; then \
	        echo "==> codegen: $$pkg"; \
	        (cd $$pkg && $(DART) run build_runner build) || exit 1; \
	    fi; \
	done

codegen-watch: ## Watch and regenerate code for one package: make codegen-watch PKG=packages/feature_task
	@test -n "$(PKG)" || { echo "Usage: make codegen-watch PKG=packages/feature_task"; exit 1; }
	cd $(PKG) && $(DART) run build_runner watch

l10n: ## Generate localization files (ARB lives in packages/ui_kit/lib/l10n)
	cd packages/ui_kit && $(FLUTTER) gen-l10n

analyze: format-check ## Format check + static analysis for every package
	@for pkg in $(ALL_PKGS); do \
	    echo "==> analyze: $$pkg"; \
	    (cd $$pkg && $(FLUTTER) analyze --no-pub) || exit 1; \
	done

# Hand-written Dart files only: generated code (*.g.dart, *.freezed.dart,
# *.config.dart, *.module.dart, l10n) is owned by its generator. Files are
# passed in batches (xargs -n) to stay under the Windows command-line limit;
# xargs exits non-zero if any batch fails.
FIND_SOURCES = find apps packages -name '*.dart' \
    -not -path '*/.dart_tool/*' -not -path '*/build/*' -not -path '*/l10n/generated/*' \
    -not -name '*.g.dart' -not -name '*.freezed.dart' -not -name '*.config.dart' -not -name '*.module.dart'

format: ## Format all hand-written Dart code
	$(FIND_SOURCES) | xargs -n 60 $(DART) format

format-check: ## Fail if any hand-written Dart file is not formatted (used in CI)
	$(FIND_SOURCES) | xargs -n 60 $(DART) format --output=none --set-exit-if-changed

test: ## Run all tests with coverage
	@for pkg in $(ALL_PKGS); do \
	    if [ -d $$pkg/test ]; then \
	        echo "==> test: $$pkg"; \
	        (cd $$pkg && $(FLUTTER) test --no-pub --coverage) || exit 1; \
	    fi; \
	done

test-one: ## Run tests of one package: make test-one PKG=packages/feature_task
	@test -n "$(PKG)" || { echo "Usage: make test-one PKG=packages/feature_task"; exit 1; }
	cd $(PKG) && $(FLUTTER) test --coverage

icons: ## Regenerate launcher + notification icons from the logo (Windows: needs powershell)
	powershell -NoProfile -ExecutionPolicy Bypass -File tool/icons/generate_icon_sources.ps1

goldens: ## Regenerate golden files (review the diff before committing)
	@for pkg in $(PACKAGES); do \
	    if grep -rq "goldenTest(" $$pkg/test 2>/dev/null; then \
	        echo "==> goldens: $$pkg"; \
	        (cd $$pkg && $(FLUTTER) test --update-goldens) || exit 1; \
	    fi; \
	done

verify: bootstrap codegen l10n analyze test ## Full pre-PR gate (same as CI)

run: check-args ## Run an app: make run APP=watch ENV=dev DEVICE=<id>
	cd $(APP_DIR) && $(FLUTTER) run --flavor $(ENV) -t $(ENTRY) $(DEVICE_FLAG) $(DEFINES)

run-watch: ## Shortcut: run the watch app (ENV=dev by default)
	$(MAKE) run APP=watch

run-mobile: ## Shortcut: run the mobile app (ENV=dev by default)
	$(MAKE) run APP=mobile	

build-debug: check-args ## Debug APK: make build-debug APP=watch ENV=dev
	cd $(APP_DIR) && $(FLUTTER) build apk --debug --flavor $(ENV) -t $(ENTRY) $(DEFINES)

build-apk: check-args ## Release APK: make build-apk APP=watch ENV=prod DEFINES="--dart-define=..."
	cd $(APP_DIR) && $(FLUTTER) build apk --release --flavor $(ENV) -t $(ENTRY) \
	    --obfuscate --split-debug-info=$(SYMBOLS) --tree-shake-icons $(ARCH_FLAG) $(DEFINES)
	@echo "APK: $(APK_PATH)"

build-watch: ## Shortcut: release APK of the watch app (ENV=prod by default)
	$(MAKE) build-apk APP=watch ENV=$(if $(filter command line environment,$(origin ENV)),$(ENV),prod)

build-mobile: ## Shortcut: release APK of the mobile app (ENV=prod by default)
	$(MAKE) build-apk APP=mobile ENV=$(if $(filter command line environment,$(origin ENV)),$(ENV),prod)

install: check-args ## Install the built release APK on a device (DEVICE=<id>)
	$(ADB) $(if $(DEVICE),-s $(DEVICE),) install -r $(APK_PATH)

devices: ## List connected adb devices
	$(ADB) devices -l

logcat: ## Show Flutter and FCM logs from the device
	$(ADB) $(if $(DEVICE),-s $(DEVICE),) logcat -v time flutter:V FirebaseMessaging:V *:S

# Shorebird ships its own Flutter fork; pin it to the FVM version (.fvmrc /
# `fvm flutter --version`) so releases build with the tested SDK.
# Patches always reuse the Flutter version of their release.
SHOREBIRD_FLUTTER ?= 3.47.5
# apk for MDM / direct install (default), aab for the Play Store.
SHOREBIRD_ARTIFACT ?= apk

shorebird-release: check-args ## Create a Shorebird release: make shorebird-release APP=watch ENV=prod
	cd $(APP_DIR) && shorebird release android --flutter-version=$(SHOREBIRD_FLUTTER) --artifact $(SHOREBIRD_ARTIFACT) --flavor $(ENV) -t $(ENTRY) $(ARCH_FLAG) -- $(DEFINES)
	@echo "Output: $(APP_DIR)/build/app/outputs/$(if $(filter apk,$(SHOREBIRD_ARTIFACT)),flutter-apk/app-$(ENV)-release.apk,bundle/$(ENV)Release/app-$(ENV)-release.aab)"

shorebird-patch: check-args ## Push a Shorebird patch: make shorebird-patch APP=watch ENV=prod
	cd $(APP_DIR) && shorebird patch android --flavor $(ENV) -t $(ENTRY) -- $(DEFINES)

clean: ## Clean build outputs of every package
	@for pkg in $(ALL_PKGS); do \
	    echo "==> clean: $$pkg"; \
	    (cd $$pkg && $(FLUTTER) clean) || exit 1; \
	done

clean-all: clean ## Clean and remove generated files (*.g.dart, *.freezed.dart, *.config.dart, *.module.dart)
	find apps packages -type f \( -name "*.g.dart" -o -name "*.freezed.dart" -o -name "*.config.dart" -o -name "*.module.dart" \) -delete
