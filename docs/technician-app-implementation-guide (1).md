# Technician app: implementation guide (phone app and watch app)

For the mobile developer. Build in the order of the steps; each step lists the API calls, what to do with the answer, and the traps.
Backend behaviour was checked against the code. To see every response and event in action, follow `technician-mobile-test-guide.md`.

## 0. The big picture

Two apps, one technician:

| | **Phone app** | **Watch app** (shared Android watch) |
|---|---|---|
| Who uses it | one technician, on their own phone | a different technician each shift |
| Proves who it is with | a technician token (JWT) | a **private-key signature on every request**, plus the technician token after pairing |
| Gets a job | yes | yes (the same job, at the same time) |
| Can accept / decline / cancel | yes | yes |
| Pairs the watch | **approves** the pairing | **creates** the pairing and logs in |

**HTTP does the actions, the socket tells you what happened.** Accept is an HTTP call; the other device finds out through a socket event.
Both apps keep one socket open to the backend while the technician is working.

Common facts:
- Every response is `{ "status_code": 200, "message": "…", "data": { … } }`. The examples below show only `data`.
- Errors are 4xx with a `message` (`401` bad or missing credentials, `403` wrong kind of device, `404` not found, `409` not allowed right now, `429` too many login attempts).
- Times are ISO 8601 strings in UTC.
- Technician token: valid up to 30 days on the phone, up to 12 hours on a watch. It dies earlier if the session is ended (logout, unpair, replaced).
- **No push notifications.** Jobs reach the app only through the socket. Keep the socket alive (an Android foreground service) and, after any reconnect, ask for the current state (step 3).

---

## Part 1. Phone app

### Step 1. Log in
`POST /technician-auth/login`
```json
{ "kpk": "31", "password": "081234567890" }
```
`kpk` is a string of 1 to 9 digits. `password` is the technician's phone number (temporary credential; a local `0…` or `62…` number both work).

200 `data`:
```json
{ "access_token": "eyJ…", "expires_at": "2026-12-11T…", "technician": { "kpk": 31, "name": "Mulyadi", "shift": "S1" } }
```
- Store the token in secure storage (Keychain / Keystore). Send `Authorization: Bearer <token>` on every call.
- `401` "Invalid KPK or password": show a generic error (the backend never says which part was wrong).
- `429`: show "try again in N seconds" using `retryAfter` (5 wrong attempts lock the KPK for 15 minutes).
- **Any later `401`** means the session ended: clear the token and show the login screen.

Also: `GET /technician-auth/me` (who am I, session id and expiry) and `POST /technician-auth/logout`.

### Step 2. Open the socket
Connect Socket.IO v4 to `<backend>/technician` (namespace `/technician`) with the handshake `auth` option `{ "token": "<access_token>" }`. Use the websocket transport.
```js
// any Socket.IO v4 client; shown in JavaScript
const socket = io(BASE_URL + '/technician', { auth: { token }, transports: ['websocket'] });
socket.on('connect_error', (e) => { /* e.message === 'Unauthorized' → token is invalid, go to login */ });
```
You can't join rooms or choose what you receive: the server decides from your token. The only event you may send is `work-order:ack` (step 7).

### Step 3. Draw the screen from the snapshot
Right after connecting, the server sends `state:snapshot`. The same content is available any time from `GET /technicians/me/state`.
```json
{
  "self": { "kind": "PERSONAL", "technician_id": 31, "session_id": "…", "device_id": null },
  "status": { "checked_in": false, "checked_in_at": null, "is_available": false, "is_on_break": false, "shift": "S1" },
  "pending_work_order": null,
  "active_work_order": null,
  "paired_watches": [ { "session_id": "…", "device": { "id": "…", "name": "Watch 1", "location": "Line B" }, "paired_at": "…", "expires_at": "…" } ]
}
```
- `status` decides the main screen: not checked in, checked in and free (`is_available`), or busy.
- `pending_work_order` is a job waiting for an answer: show the accept/decline prompt (step 6).
- `active_work_order` is an accepted, unfinished job: show the job screen.
- **Treat every snapshot as the truth and redraw from it.** Events sent while you were offline are lost. So on every (re)connect, rebuild the screen from the snapshot, never from your old state.

### Step 4. Check in and out
- `POST /technicians/me/check-in` (no body) → `{ "outcome": "CHECKED_IN" | "RESUMED" | "ALREADY_CHECKED_IN", "shift": "S1", "date": "…", "checked_in_at": "…" }`
- `POST /technicians/me/check-out` (no body) → `{ "outcome": "CHECKED_OUT", "shift": …, "checked_in_at": … }` or `{ "outcome": "NOT_CHECKED_IN" }`

Check-out is attendance only: **it does not log the technician out or end any session**. Use logout for that.
The socket confirms every change with `status:changed` (step 5), also when the *other* device caused it, so update the UI from the event, not only from your own call.

### Step 5. Listen to the events
All of these arrive on the same socket. Register a handler for each name.

| Event | Payload | What the app does |
|---|---|---|
| `state:snapshot` | the snapshot above | redraw everything |
| `status:changed` | `{ status, reason, by, at }` | replace the status; `reason` is why: `CHECK_IN`, `CHECK_OUT`, `ACCEPTED`, `DECLINED`, `AUTO_DECLINED`, `CANCELLED`, `REPAIR_FINISHED` |
| `work-order:assigned` | `{ work_order }` | **a new job**: show the prompt with a countdown (step 6) |
| `work-order:updated` | `{ work_order, reason, by, at }` | the job changed: `ACCEPTED`, `DECLINED`, `AUTO_DECLINED`, `CANCELLED`, `COMPLETED`. Close the prompt or the job screen |
| `watch:paired` / `watch:unpaired` | `{ session_id, device, … }` (+ `reason` on unpaired) | update the "my watches" list (phone only) |
| `session:ended` | `{ reason }` | this session is over (`LOGOUT`, `REPLACED`, `EXPIRED`, …). The server closes the socket. Go to login; do not reconnect with the old token |

**Who did it:** `by` is `{ "source": "mobile" | "whatsapp" | "system", "device_kind": "PERSONAL" | "SHARED", "device_id": null | "<watch id>" }`.
`device_id` is `null` when the technician's phone did it. So "accepted on the watch" means `by.device_kind == "SHARED"`. Use it to say "answered on your watch" and close the prompt.

The job object (`work_order`):
```json
{ "id": "…", "request_id": "WO-2026-00193", "status": "PENDING", "shift": "S1", "created_at": "…",
  "respond_by": "(created_at + 60 s)", "machine": { "id": "FAR339", "cell_position": "B-12" },
  "issue": "Changeover", "repair_id": "…" }
```

### Step 6. Show a job and let the technician answer
When `work-order:assigned` arrives (or `pending_work_order` is in the snapshot):
- Show machine, location and issue, with a countdown to `respond_by`. **Count down against the server's time, not your phone's:** read the `Date` header of any API response once and keep the offset.
- The server auto-declines at 65 s (a few seconds after the 60 s countdown), so a late tap can still work. Never rely on that: when the countdown ends, show "expired" and wait for `work-order:updated` with `AUTO_DECLINED`.

| Button | Call | Result |
|---|---|---|
| Accept | `POST /technicians/me/work-orders/{id}/accept` | job accepted, technician becomes busy |
| Decline | `POST /technicians/me/work-orders/{id}/decline` | job declined, **technician is checked out**, the next technician is asked |
| Cancel | `POST /technicians/me/work-orders/{id}/cancel` | only after accepting (something unforeseen happened): job given up, **technician is checked out** |

No body. Success is 200 with `data: { work_order, status }`, for example "Work order accepted" and `work_order.status = "ACCEPTED"`.
(A cancelled job is stored as `DECLINED`; the event says `CANCELLED`.)

Errors to handle, all `409` unless noted:
- "This work order was already answered": the **other device (or the timer) was first**. Not an error for the user: close the prompt and let the `work-order:updated` event tell the story.
- "You are not checked in": show the check-in screen (decline, cancel and auto-decline check the technician out, so they must check in again).
- "You are currently marked as unavailable": the technician already has an accepted job.
- "You have not accepted this work order": cancel is only for an accepted job.
- `404` "Work order not found".

Disable the buttons after a tap and wait for the answer, so a double tap doesn't produce a confusing 409.

### Step 7. Acknowledge the job (optional but recommended)
When `work-order:assigned` arrives, emit `work-order:ack` with `{ "work_order_id": "<id>" }`. The reply is `{ "ok": true }`.
It tells the backend the job reached a device: its status goes from `PENDING` to `READ`. It is safe to send from the phone and the watch.

### Step 8. Pair a watch (the phone approves)
The watch shows a QR. Scan it with the camera. Its text is JSON: `{ "v": 1, "t": "pair", "code": "AbC…" }`.
1. **Check `t == "pair"`.** If not, say "this is not a watch pairing code" (the admin's enrollment QR looks similar but has no `t`).
2. `GET /technicians/me/pairings/preview?code=<code>` → `{ "device": { "name": "Watch 1", "location": "Line B" }, "expires_at": "…" }`. Show the watch name and ask "Log in on Watch 1?".
3. On confirm: `POST /technicians/me/pairings/approve` with `{ "code": "<code>" }` → `{ "device": { "name": "…", "location": "…" } }`.
4. Show "waiting for the watch". The phone then receives `watch:paired` when the watch finishes. Nothing else is needed.

Notes: the QR lives only **60 seconds** (`404` "Pairing code is invalid or expired" → ask the watch for a new QR). Only the **phone** can approve: a watch token gets `403`.

### Step 9. My watches and unpair
- `GET /technicians/me/devices` → `[ { "session_id", "device": { "id", "name", "location" }, "paired_at", "expires_at" } ]`.
- `POST /technicians/me/devices/{session_id}/unpair` → `{ "checked_out": true | false }`. It **checks the technician out** and logs the watch out. The watch gets `session:ended`.
- Keep the list live with `watch:paired` and `watch:unpaired`.

### Step 10. Logout
`POST /technician-auth/logout`. Clear the token and close the socket. Logging in again on another phone replaces this session (`session:ended` with `REPLACED`).

### Step 11. Screens that need data: profile, my jobs, job detail, attendance
All four use the technician token (a watch adds its signature, as always). They return **only the logged-in technician's own data**.
Lists are newest first and paged: `page` (default 1) and `perPage` (default 20, at most 100). The answer carries a `pagination` block next to `data`:
`{ "page": 1, "per_page": 20, "total_data": 42, "total_pages": 3 }`.

**Profile.** `GET /technicians/me/profile`
```json
{ "kpk": 31, "name": "Mulyadi", "shift": "S1", "is_active": true, "member_since": "2025-03-02T…", "phone_number_masked": "6282*****037" }
```
The phone number is never returned in full (it is the temporary login password); only the masked form is.

**My jobs.** `GET /technicians/me/work-orders?status=&from=&to=&page=&perPage=`
- `status` (optional, comma separated): `WAITING`, `IN_PROGRESS`, `COMPLETED`, `CANCELLED`, `DECLINED`. Example: `status=WAITING,IN_PROGRESS`.
- `from` and `to` (optional, `YYYY-MM-DD`): jobs created on or after / on or before that day.

Each item is the same job object as the socket sends, plus how it ended and the repair times:
```json
{ "id": "…", "request_id": "WO-2026-00193", "status": "ACCEPTED", "shift": "S1", "created_at": "…", "respond_by": "…",
  "machine": { "id": "FAR339", "cell_position": "B-12" }, "issue": "Changeover", "repair_id": "…",
  "display_status": "IN_PROGRESS", "updated_at": "…",
  "repair": { "reason": null, "problem_started_at": "…", "action_started_at": null, "finished_at": null } }
```
Show `display_status`, not the raw `status`:

| `display_status` | Meaning |
|---|---|
| `WAITING` | asked, not answered yet |
| `IN_PROGRESS` | accepted, repair not finished |
| `COMPLETED` | repair finished, with the technician and their action recorded |
| `CANCELLED` | repair finished without a technician or an action recorded |
| `DECLINED` | declined, auto-declined, or cancelled by the technician (the backend does not tell these apart here) |

**One job.** `GET /technicians/me/work-orders/{id}`: the same object with more machine detail:
`"machine": { "id": "FAR339", "cell_position": "B-12", "type": "…" }` and `"issue_action": "…"`. `404` if the job is not this technician's.

**Attendance.** `GET /technicians/me/attendance?from=&to=&page=&perPage=`: one row per shift.
```json
{ "id": "…", "date": "2026-11-11", "shift": "S1", "status": "CLOSED", "checked_in_at": "…", "checked_out_at": "…",
  "worked_minutes": 462, "is_available": false, "is_on_break": false }
```
`status` is `OPEN` while the technician is still checked in (then `checked_out_at` and `worked_minutes` are `null`). Here `from`/`to` filter on the shift `date`.

Errors: `400` for a bad `status` value, a date that is not `YYYY-MM-DD`, or `perPage` above 100.
Use these for list screens. For what is happening right now (a waiting or active job), keep using the snapshot and the socket events.

### Phone checklist
- [ ] login, secure token storage, 401 → login screen
- [ ] socket with `auth.token`, snapshot on every connect
- [ ] check in / check out, status from `status:changed`
- [ ] job prompt with countdown, accept / decline / cancel, 409 "already answered" handled quietly
- [ ] `work-order:ack`
- [ ] scan, preview, approve a watch; watch list and unpair
- [ ] `session:ended` → login; reconnect after a drop and rebuild from the snapshot
- [ ] profile, my jobs (filters and paging), job detail, attendance history

---

## Part 2. Watch app (Android, shared by technicians)

The watch is a trusted *device* first (enrolled once), and a technician logs in on it each shift (paired).

```
setup (once):   make key pair ──► enroll with the admin's code
every shift:    create pairing QR ──► phone approves ──► exchange ──► logged in
while working:  signed requests + signed socket, same jobs as the phone
shift end:      unpair
```

### Step 1. The key pair (once, no API call)
Create it on the watch, in the Android Keystore, the first time the app is set up (before enrolling). It is not created at install and not on each launch.
Check first: if the alias already exists, skip this step.
```kotlin
const val ALIAS = "technician-watch-key"

fun createKeyPair(): java.security.KeyPair {
    val generator = KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, "AndroidKeyStore")
    generator.initialize(
        KeyGenParameterSpec.Builder(ALIAS, KeyProperties.PURPOSE_SIGN)
            .setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1"))   // P-256
            .setDigests(KeyProperties.DIGEST_SHA256)
            .setUserAuthenticationRequired(false)
            .build()
    )
    return generator.generateKeyPair()
}
```
- The private key never leaves the Keystore. Only the public key is sent to the backend.
- Public key to send: `keyPair.public.encoded` (X.509 SubjectPublicKeyInfo bytes), as **base64** without line breaks (`Base64.NO_WRAP`).
- Try hardware-backed keys (`KeyInfo.isInsideSecureHardware` / `securityLevel`) and tell the backend team what the Newland WD1 II supports.
- The key is lost on uninstall and factory reset. Then the admin issues a new enrollment code and the watch enrolls again.

### Step 2. Enroll (once per watch)
The admin creates the watch in the dashboard and gets a one-time code, shown as a QR `{"v":1,"code":"K7M2Q9XD4B"}` (or typed). The watch scans or types it, then:

`POST /shared-devices/enroll` (no auth header)
```json
{ "code": "K7M2Q9XD4B", "public_key": "<base64 DER public key>", "signature": "<base64 signature>" }
```
The **signature** is made with the private key over these lines, joined by `\n` (no trailing newline):
```
enroll
v1
<the code exactly as sent in "code">
<fingerprint = lowercase hex SHA-256 of the public key DER bytes>
```
200 `data`: `{ "device": { "id": "99c4d8a6-…", "name": "Watch 1", "location": "Line B" }, "public_key_fingerprint": "…" }`.
**Save `device.id`.** It goes in every later request. No secret is returned.
`401` "Invalid or expired enrollment code": wrong, used or expired (15 minutes), or the public key is already registered to another watch. `429`: too many wrong tries.

### Step 3. Signing every request
From now on **every** request to the backend carries four headers:

| Header | Value |
|---|---|
| `X-Device-Id` | the `device.id` saved at enrollment |
| `X-Timestamp` | Unix time in seconds |
| `X-Nonce` | random, 16 to 64 characters of `A-Za-z0-9_-`, **never reused** (16 random bytes as base64url without padding is fine) |
| `X-Signature` | base64 signature of the text below |

The text to sign, lines joined by `\n`, no trailing newline:
```
request
v1
<METHOD in capitals>
<path and query exactly as requested, e.g. /technicians/me/check-in>
<X-Timestamp>
<X-Nonce>
<lowercase hex SHA-256 of the raw request body; of the empty string if there is no body>
<session id; empty before pairing>
```
- **Session id:** after pairing, the `session_id` claim inside the technician token (decode the middle part of the JWT, base64url JSON). Before pairing it is an empty line.
- After pairing the request **also** carries `Authorization: Bearer <technician token>`.
- The backend allows ±60 seconds. If a request returns `401` and has an `X-Server-Time` response header (seconds), your clock is off: compute the offset, sign again and retry once. Keep the offset for later requests.
- A signed request works once (the nonce is used up), so build a fresh signature for every call, retries included.
- Every signature failure is the same `401 "Invalid device signature"`; the backend log says why.

Kotlin, as an OkHttp interceptor (`sessionId` is empty before pairing):
```kotlin
class SigningInterceptor(
    private val deviceId: () -> String,
    private val sessionId: () -> String,       // "" before pairing
    private val token: () -> String?,          // null before pairing
    private val clockOffsetSeconds: () -> Long
) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        val body = Buffer().also { request.body?.writeTo(it) }.readByteArray()
        val pathAndQuery = request.url.encodedPath + (request.url.encodedQuery?.let { "?$it" } ?: "")
        val timestamp = (System.currentTimeMillis() / 1000 + clockOffsetSeconds()).toString()
        val nonce = Base64.encodeToString(Random.nextBytes(16), Base64.URL_SAFE or Base64.NO_WRAP or Base64.NO_PADDING)

        val text = listOf("request", "v1", request.method.uppercase(), pathAndQuery, timestamp, nonce,
            sha256Hex(body), sessionId()).joinToString("\n")

        val signed = request.newBuilder()
            .header("X-Device-Id", deviceId())
            .header("X-Timestamp", timestamp)
            .header("X-Nonce", nonce)
            .header("X-Signature", sign(text))
            .apply { token()?.let { header("Authorization", "Bearer $it") } }
            .build()
        return chain.proceed(signed)
    }
}

fun sign(text: String): String {
    val key = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }.getKey(ALIAS, null) as PrivateKey
    val signature = Signature.getInstance("SHA256withECDSA").apply { initSign(key); update(text.toByteArray(Charsets.UTF_8)) }.sign()
    return Base64.encodeToString(signature, Base64.NO_WRAP)
}

fun sha256Hex(bytes: ByteArray) = MessageDigest.getInstance("SHA-256").digest(bytes).joinToString("") { "%02x".format(it) }
```
The reference implementation of the same signing is `misc/device-sim/device-sim.js` (Node). Compare your output with it if the backend answers 401.

### Step 4. Pair: show the QR, wait, exchange
1. **Create the pairing.** `POST /shared-devices/pairings` (signed, no body) → 201 `data`:
   ```json
   { "pairing_id": "6f1c…", "expires_at": "(60 seconds)", "qr_payload": "{\"v\":1,\"t\":\"pair\",\"code\":\"AbC…\"}" }
   ```
2. **Show `qr_payload` as a QR code**, exactly as the text it is. It is valid for 60 seconds; asking again cancels the previous one, so **create a new pairing about every 55 seconds** while the QR is on screen.
3. **Wait for the phone.** Best: the unpaired socket (step 5) delivers `pairing:approved` `{ "pairing_id" }`. Fallback if the socket is down: poll `GET /shared-devices/pairings/{pairing_id}` (signed) every 2 seconds; `data.status` is `PENDING`, `APPROVED`, `CONSUMED`, `EXPIRED` or `CANCELLED`.
4. **Exchange, as soon as it is approved** (you have 60 seconds): `POST /shared-devices/pairings/{pairing_id}/exchange` (signed, no body) → 200 `data`:
   ```json
   { "access_token": "eyJ…", "expires_at": "(12 hours)", "technician": { "kpk": 31, "name": "Mulyadi", "shift": "S1" } }
   ```
   Store the token and its `session_id` (decode the JWT). The watch is now logged in as that technician.
   `409` "Pairing is …, not approved": not approved yet, expired, or already used. Ask for a new QR.

Only the enrolled watch can get the token. The phone cannot, which is why exchange is a separate step from the phone's approval.

### Step 5. The watch's socket
Connect to `<backend>/technician`. The handshake is signed too, and the signature is **single use**, so every connection needs fresh values.
Put them in the handshake `auth` option:

| When | `auth` fields |
|---|---|
| waiting to be paired (showing the QR) | `device_id`, `timestamp`, `nonce`, `signature` |
| paired | the same four, plus `token` |

Signed text for the handshake (same layout as a request, with fixed method and path):
```
request
v1
SOCKET
/technician
<timestamp>
<nonce>
<sha256 hex of the empty string: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855>
<session id when paired, empty line when not>
```
Important:
- **Disable the client's automatic reconnect** and reconnect yourself with a **new signature** each time. An automatic reconnect would resend the same (already used) nonce and be refused.
- Reconnect with backoff (for example 1, 2, 5, 10 s). After a reconnect, rebuild the screen from `state:snapshot`.
- Unpaired watch snapshot: `{ "self": { "kind": "UNPAIRED_DEVICE", "device_id": "…" } }` and only `pairing:approved` arrives.
- Paired watch snapshot: `{ "self": { "kind": "SHARED", … }, "status": …, "pending_work_order": …, "active_work_order": … }`.
- After pairing, close the unpaired socket and open the paired one.

### Step 6. Work: same jobs, same events
A paired watch receives the same `status:changed`, `work-order:assigned` and `work-order:updated` events as the phone (see Part 1, steps 3 to 7), and uses the same calls with signed requests:
- `POST /technicians/me/check-in`, `/check-out`
- `POST /technicians/me/work-orders/{id}/accept`, `/decline`, `/cancel`
- `work-order:ack` over the socket

Differences: the watch does **not** get `watch:paired` / `watch:unpaired`, and it cannot approve pairings (`403`). Keep the UI tiny: a prompt with accept/decline and a countdown, and a "checked in" indicator.

### Step 7. End of the shift (the app decides when)
The server has no shift-end timer: shifts vary in length, so the **app** ends the session.
- `POST /technicians/me/unpair` (signed, with the token, no body) → `{ "checked_out": true | false }`. It checks the technician out **and** ends the watch session. Then go back to showing the pairing QR.
- `POST /technicians/me/check-out` only checks out and **keeps the session** (useful for a break).
- The session also ends when: the phone unpairs it, another technician pairs the same watch (`REPLACED`), the admin disables the watch (`DEVICE_DISABLED`), or 12 hours pass (`EXPIRED`).

### Step 8. When the session ends (`session:ended`)
Payload `{ "reason": "LOGOUT" | "CHECK_OUT" | "REPLACED" | "EXPIRED" | "DEVICE_DISABLED" }`. The server then closes the socket.
Throw away the technician token and session id, and go back to showing a pairing QR (step 4) with the **device** credentials (the key pair) as before.
A `401` on a technician call also means the session is over: do the same.
`DEVICE_DISABLED`: the admin turned this watch off. Show "ask your admin"; signed requests will fail until it is re-enabled and, if the admin reset it, re-enrolled.

### Watch checklist
- [ ] key pair in the Keystore, created once (alias check)
- [ ] enroll with the admin's code, `device.id` saved
- [ ] signing interceptor, fresh nonce each call, clock-offset retry on 401 with `X-Server-Time`
- [ ] pairing QR, refreshed every ~55 s; `pairing:approved` (or polling) then exchange
- [ ] signed socket, manual reconnect with a new signature, snapshot on connect
- [ ] prompt, accept / decline / cancel, ack, 409 handled quietly
- [ ] unpair at the end of the shift; `session:ended` returns to the QR screen

---

## Where every URL parameter and header comes from

Use this when an endpoint shows `{id}` in the URL or extra headers and you are not sure what to put there.

### URL parameters (`{id}`, `{session_id}`)

| In the URL | It is | Where you get it |
|---|---|---|
| `/shared-devices/pairings/{id}` and `/shared-devices/pairings/{id}/exchange` (watch) | the **pairing id** | the `pairing_id` in the answer of `POST /shared-devices/pairings` (`data.pairing_id`). The `pairing:approved` socket event carries the same id |
| `/technicians/me/work-orders/{id}` and `.../{id}/accept`, `/decline`, `/cancel` | the **work order id** | `work_order.id` in the `work-order:assigned` event, or `pending_work_order.id` / `active_work_order.id` in the snapshot, or an item of `GET /technicians/me/work-orders` |
| `/technicians/me/devices/{sessionId}/unpair` (phone) | the **watch session id** | `session_id` in `GET /technicians/me/devices` or in the `watch:paired` event |
| `/shared-devices/{id}` (admin dashboard only) | the **device id** | `device.id` of the watch, from the admin's device list |

### Query parameters

| Call | Parameter | Value |
|---|---|---|
| `GET /technicians/me/pairings/preview?code=` (phone) | `code` | the `code` inside the watch QR's JSON (`{"v":1,"t":"pair","code":"…"}`) |
| `GET /technicians/me/work-orders` | `status`, `from`, `to`, `page`, `perPage` | optional filters, see Step 11 |
| `GET /technicians/me/attendance` | `from`, `to`, `page`, `perPage` | optional filters, see Step 11 |

### Headers

| Header | Needed on | Value |
|---|---|---|
| `Authorization: Bearer <token>` | every technician call (phone and watch) | phone: `access_token` from `POST /technician-auth/login`. Watch: `access_token` from the **exchange** answer |
| `Content-Type: application/json` | calls that send a body | fixed text |
| `X-Device-Id` | **every watch call** | the `device.id` returned by `POST /shared-devices/enroll`. Save it once, it never changes |
| `X-Timestamp` | every watch call | the current Unix time in **seconds** (corrected by the server-time offset if needed) |
| `X-Nonce` | every watch call | a **new** random value each time, 16 to 64 characters of `A-Za-z0-9_-` |
| `X-Signature` | every watch call | computed by the app: sign the text in Part 2 step 3 with the watch's private key, base64 |

The four `X-` headers are only for the **watch**. The phone sends none of them, even though Swagger lists them as optional fields on the `/technicians/me/...` calls.
You never type them in production: the watch app computes all four for every request (the interceptor in Part 2 step 3).

When testing by hand:
- **Postman through the watch helper:** you put none of the four, the helper adds them.
- **Swagger:** run `node device-sim.js headers <METHOD> <path>` in `misc/device-sim` and paste its four values. They work once, within about 60 seconds.

### Example: the exchange call
`POST /shared-devices/pairings/{id}/exchange`
- `{id}` = the `pairing_id` from the **Pair** answer (step 4.1).
- `X-Device-Id`, `X-Timestamp`, `X-Nonce`, `X-Signature` = computed by the watch (it has no token yet, so the signed text has an empty session id).
- no `Authorization` header and no body.
- answer: the `access_token` for the watch.

## Part 3. Cheat sheet

| Who | Call | Auth |
|---|---|---|
| phone | `POST /technician-auth/login`, `GET /technician-auth/me`, `POST /technician-auth/logout` | none, token, token |
| phone and watch | `GET /technicians/me/state`, `POST /technicians/me/check-in`, `/check-out` | token (+ signature on the watch) |
| phone and watch | `POST /technicians/me/work-orders/{id}/accept`, `/decline`, `/cancel` | token (+ signature on the watch) |
| phone | `GET /technicians/me/pairings/preview?code=`, `POST /technicians/me/pairings/approve` | token |
| phone | `GET /technicians/me/devices`, `POST /technicians/me/devices/{sessionId}/unpair` | token |
| phone and watch | `GET /technicians/me/profile`, `GET /technicians/me/attendance`, `GET /technicians/me/work-orders`, `GET /technicians/me/work-orders/{id}` | token (+ signature on the watch) |
| watch | `POST /shared-devices/enroll` | none (code + signature in the body) |
| watch | `GET /shared-devices/me` | signature |
| watch | `POST /shared-devices/pairings`, `GET /shared-devices/pairings/{id}`, `POST /shared-devices/pairings/{id}/exchange` | signature |
| watch | `POST /technicians/me/unpair` | token + signature |
| both | socket `<backend>/technician`, event `work-order:ack` | token (phone); signature (+ token) (watch) |

Socket events received: `state:snapshot`, `status:changed`, `work-order:assigned`, `work-order:updated`, `session:ended`; phone only: `watch:paired`, `watch:unpaired`; unpaired watch only: `pairing:approved`.

## Part 4. Rules that save debugging time

1. **The snapshot is the truth.** Redraw from `state:snapshot` on every (re)connect. Events can be missed.
2. **Never reuse a signature.** New nonce and timestamp for every request and every socket connection, retries included.
3. **Sign exactly what you send.** Path and query as sent, the raw body bytes, the right session id. One changed character gives a 401.
4. **A 409 "already answered" is normal.** Another device or the timer answered first.
5. **Decline, cancel and auto-decline check the technician out.** Show the check-in screen afterwards.
6. **Check-out is not logout.** Only logout, unpair, replacement, disabling and expiry end a session.
7. **Don't reconnect with a dead token.** After `session:ended`, or a 401 on a token, log in or pair again.
8. **No push, no background magic.** Keep the socket alive in a foreground service and resync from the snapshot after every gap.

## Part 5. Try it without the real apps

- Follow `technician-mobile-test-guide.md`: Swagger plays the phone, Postman and the watch helper (`misc/device-sim`) play the watch.
- `misc/device-sim/device-sim.js` is a working reference for the watch's key pair, enrollment, request signing and signed socket.
- The signing logic on the backend is in `src/modules/techinician-dispatcher/device-auth/` (`device-signature.util.ts` builds the signed texts).
