# Architecture rules

These are invariants from the spec. Breaking one is a bug, even if tests pass.

## Layers and state

* Feature packages have `data/` (Retrofit API, DTOs, repository) and `presentation/<area>/{bloc,cubit,view,widgets}/`
  (layout and naming in `dart-conventions.md`). No domain layer.
* Use a **Bloc** when the actions need `bloc_concurrency` (droppable/sequential/restartable) or events come from
  several sources (push, timers, lifecycle). Otherwise use a **Cubit** (D-02).
* Repositories return `Result<T>` and never throw; wrap remote calls in `ErrorMapper.guard`. Blocs only see `Failure`s.
* User actions that hit the network (Terima, Tolak, Batalkan, Check In, Check Out) are Bloc events with `droppable()`.
* `TaskSessionBloc` is the **only** listener of work-order events (socket and FCM, D-21); `AvailabilityBloc`
  follows `status:changed`/snapshots, `SessionCubit` follows `session:ended`. App-scoped: `SessionCubit`, `TaskSessionBloc`,
  `AvailabilityBloc`, `ShiftEndCubit`, `AppGateCubit` (created in `app_shell`). Everything else is screen-scoped and closed with the screen.
* Cancel timers, subscriptions and vibration in `close()`/`dispose()`.

## Server authority and time

* The server owns the clock and the state. Move UI state only after server confirmation, except the
  queueable action (Check Out via `OutboxService`). There is no Selesai (D-22).
* The state snapshot is the truth: redraw from it on every (re)connect, never from old local state.
* **Never call `DateTime.now()`** in app code. Use `AppClock.serverNowUtc()` for decisions and `AppClock.format*`
  (Asia/Jakarta, `id_ID`) for display. Countdowns use `CountdownCubit` (monotonic Stopwatch).
* Network-required actions are disabled offline (`OnlineBuilder`): Check In, Terima, Tolak, pairing.

## Task flow invariants

* Event ordering/dedupe goes through `TaskEventProcessor` (work-order ids in Drift). Do not bypass it.
* No second popup while a task is Assigned or In Progress; Check Out and logout are blocked while In Progress.
* Decline, cancel, timeout, late delivery and offline-missed make the user Unavailable (`availabilityLost`).
* A 409 "already answered" is normal (other device or timer first): close quietly.
* Every end of an assignment produces an explanation (pending results in Drift) unless the reason is silent.
* Alerts stop on every exit from Assigned (handled in `TaskSessionBloc.onChange`).

## Session

* Only `SessionCubit.end()` ends a session; trigger it through `SessionEventBus.requestEnd`.
* The wipe (`AuthRepository.endSession` + `LocalSessionWiper`) must clear: FCM token, secure storage
  (except the enrolled device id), Drift session tables, visible alerts.
* Watch always logs out at shift end; mobile only with `auto_logout_mobile`. Never mid-job.
* Restart for a Shorebird patch only at a safe point (after shift-end logout on the watch).

## Delivery (D-21)

* Socket: `RealtimeService` (manual reconnect, new signature per connection) + `ForegroundKeepAlive` while signed in.
* The remote setting `task_delivery` (socket/fcm/both) picks the channels; never hard-code one.
* Watch requests are signed by `DeviceSigningInterceptor` (must stay the last request interceptor).

## FCM background isolate

* `firebaseBackgroundMessageHandler` has no GetIt. Keep it tiny; open Drift directly; never import feature packages.

## DI

* Each package registers through its `@module` in `src/di/*_module.dart` (injectable micro-package).
  The apps compose them in `app_shell/lib/src/di.dart`. Prefer `@lazySingleton`; blocs are `@injectable` factories.
