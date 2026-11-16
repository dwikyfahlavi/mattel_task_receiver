# API contract as implemented by the apps

Source of truth: the backend guide `docs/technician-app-implementation-guide (1).md` and the
dev Swagger at `https://api.mattel-dev.altimeda.com/api/docs` (technician subset saved in
`docs/backend/openapi-technician.json`; refresh it with `tool/api/extract_openapi.ps1`). The fake
backend (`packages/core/lib/src/network/fake/fake_backend.dart`) implements this contract.

Base URL: dev `https://api.mattel-dev.altimeda.com/` (no `/api` prefix). Socket: `<origin>/technician`.

## Conventions

* Success: `{ "status_code": 200, "message": "…", "data": … }`; paged lists add
  `pagination: { page, per_page, total_data, total_pages }` (`ApiEnvelopeInterceptor` unwraps it).
* Errors are NestJS style `{ "message": "…" | ["…"], "statusCode": 409 }` with **no code**.
  `ErrorMapper.classify` maps status + message to `ApiErrorCode` (keep it in sync if the wording changes;
  ask the backend for error codes).
* UTC ISO-8601 times; the `Date` header of every response corrects the clock.
* Phone: `Authorization: Bearer <token>` (30 days, no refresh). Any `401` ends the session.
* Watch: every call adds `X-Device-Id`, `X-Timestamp`, `X-Nonce`, `X-Signature` (`RequestSigner`), plus the
  bearer token after pairing (12 h). A `401` with `X-Server-Time` corrects the clock and retries once.
* No idempotency keys; double taps are stopped by `droppable()`; a repeated answer gets 409 "already answered".

## Endpoints

| Who | Endpoint | Body / query | `data` |
| --- | --- | --- | --- |
| phone | `POST technician-auth/login` | `{ kpk, password }` (KPK 1-9 digits, password = phone number) | `{ access_token, expires_at, technician: { kpk, name, shift } }`; 401 "Invalid KPK or password", 429 + `retryAfter` |
| phone | `GET technician-auth/me` / `POST technician-auth/logout` | – | session info / – |
| both | `GET technicians/me/state` | – | snapshot (below) |
| both | `POST technicians/me/check-in` | – | `{ outcome: CHECKED_IN\|RESUMED\|ALREADY_CHECKED_IN, shift, date, checked_in_at }` |
| both | `POST technicians/me/check-out` | – | `{ outcome: CHECKED_OUT\|NOT_CHECKED_IN, … }` (attendance only, never a logout) |
| both | `POST technicians/me/work-orders/{id}/accept\|decline\|cancel` | – | `{ work_order, status }`; 409 already answered / not checked in / unavailable / not accepted; 404 |
| both | `GET technicians/me/work-orders` | `status` (WAITING,IN_PROGRESS,COMPLETED,CANCELLED,DECLINED), `from`, `to`, `page`, `perPage` | `[work_order + display_status, updated_at, repair]` + pagination |
| both | `GET technicians/me/work-orders/{id}` | – | same + `machine.type`, `issue_action` |
| both | `GET technicians/me/profile` | – | `{ kpk, name, shift, is_active, member_since, phone_number_masked }` |
| both | `GET technicians/me/attendance` | `from`, `to`, `page`, `perPage` | `[{ id, date, shift, status: OPEN\|CLOSED, checked_in_at, checked_out_at, worked_minutes, … }]` |
| phone | `GET technicians/me/pairings/preview?code=` | – | `{ device: { name, location }, expires_at }`; 404 invalid/expired |
| phone | `POST technicians/me/pairings/approve` | `{ code }` | `{ device }` |
| phone | `GET technicians/me/devices` | – | `[{ session_id, device, paired_at, expires_at }]` |
| phone | `POST technicians/me/devices/{sessionId}/unpair` | – | `{ checked_out }` |
| watch | `POST shared-devices/enroll` (unsigned) | `{ code, public_key, signature }` | `{ device: { id, name, location }, public_key_fingerprint }` |
| watch | `POST shared-devices/pairings` | – | `{ pairing_id, expires_at (60 s), qr_payload }` |
| watch | `GET shared-devices/pairings/{id}` | – | `{ status: PENDING\|APPROVED\|CONSUMED\|EXPIRED\|CANCELLED }` |
| watch | `POST shared-devices/pairings/{id}/exchange` | – | same as login |
| watch | `POST technicians/me/unpair` | – | `{ checked_out }` (shift end) |

`work_order`: `{ id, request_id, status, shift, created_at, respond_by, machine: { id, cell_position }, issue, repair_id }`.
Snapshot: `{ self: { kind: PERSONAL|SHARED|UNPAIRED_DEVICE, … }, status: { checked_in, checked_in_at, is_available, is_on_break, shift }, pending_work_order, active_work_order, paired_watches }`.

## Socket events (`/technician`, Socket.IO v4, websocket, manual reconnect)

Handshake `auth`: phone `{ token }`; watch `{ device_id, timestamp, nonce, signature[, token] }`, signed text
method `SOCKET`, path `/technician`, single use. Received: `state:snapshot`, `status:changed`, `work-order:assigned`,
`work-order:updated` (`ACCEPTED|DECLINED|AUTO_DECLINED|CANCELLED|COMPLETED`, `by`), `session:ended`; phone only
`watch:paired`, `watch:unpaired`; unpaired watch only `pairing:approved`. Sent: `work-order:ack { work_order_id }`.

## Push (proposed to the backend, D-21)

Not sent by the backend yet; the app handles it when `task_delivery` is `fcm` or `both`.
FCM data-only, high priority, TTL ~60 s: `{ "event": "<socket event name>", "payload": "<socket payload as JSON text>" }`
(`work-order:assigned`, `work-order:updated`, `status:changed`, `session:ended`). Never tokens, never a snapshot.
Token registration (proposed): `POST devices/fcm-token { fcm_token, device_id? }`, `DELETE devices/fcm-token`.

## QR codes

* Watch pairing (from the backend, shown as is): `{"v":1,"t":"pair","code":"…"}`.
* Admin enrollment: `{"v":1,"code":"K7M2Q9XD4B"}` (no `t`), or the code typed / read by the hardware scanner.
