---
name: add-api-endpoint
description: Add or change a backend endpoint (Retrofit API, DTO, repository, fake backend, contract doc). Use when the backend contract changes or a feature needs a new call.
---

# Add or change an API endpoint

1. **Contract first.** Update `docs/api_contract.md` (request, response, error codes). New error codes go
   into `ApiErrorCode` in `packages/core/lib/src/error/failure.dart` and `failureText` in
   `packages/ui_kit/lib/src/failure_text.dart` (Indonesian copy in the ARB).
2. **DTO** in the owning feature's `lib/src/data/*_dtos.dart` as a freezed class with `fromJson`.
   Field names are camelCase; `build.yaml` maps them to snake_case. Enums get an `unknown` member and
   `@JsonKey(unknownEnumValue: ...)`.
3. **Retrofit method** in `lib/src/data/*_api.dart` with a relative path (no leading `/`).
   * Unauthenticated: `@Extra({RequestFlags.skipAuth: true})`.
   * Mutating task/availability call: `@Header('Idempotency-Key') String key`; get the key from the
     repository's per-action key map so retries reuse it.
4. **Repository** method returns `Result<T>` via `_errors.guard(...)`. Never throw.
   If the action is queueable (doc 16), enqueue through `OutboxService` and register a handler that maps
   the result with `TaskRepository.outcomeFor`.
5. **Fake backend**: implement the route in `packages/core/lib/src/network/fake/fake_backend.dart`.
6. `make codegen`, then tests: repository/bloc test with mocktail; error mapping for each new code.
7. `make verify`.
