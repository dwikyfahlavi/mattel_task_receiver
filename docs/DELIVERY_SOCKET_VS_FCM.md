# Work-order delivery: Socket vs FCM

The app supports three delivery modes, switched with the remote setting `task_delivery`
(Remote Config, then Firestore `app_config/<env>`; see DECISIONS D-21). No new release is needed.

| Mode | What runs on the device | Backend support today |
| --- | --- | --- |
| `socket` (default) | Socket.IO connection to `/technician` + a foreground service with an ongoing notification | Yes, this is how the backend delivers now |
| `fcm` | Nothing while idle. Google Play Services wakes the app when a push arrives | **No**: the backend sends no push yet (proposed format in `api_contract.md`) |
| `both` | Socket + foreground service, and FCM as a second path | Partly: FCM half needs the backend |

> **Status of the numbers below.** Nothing has been measured on the Newland WD1 II or the target phones
> yet. The comparison explains *why* the modes differ and gives rough expectations so the team knows what
> to look for. Fill in the "Measured" table at the end before deciding.

## 1. How each one works

**Socket.** The app keeps its own TCP/TLS connection open all shift. To keep it alive, Socket.IO
exchanges a small heartbeat (ping/pong). Its default server ping interval is 25 s; the backend's actual
value is unknown, so ask the backend team. Each heartbeat can wake the CPU and the Wi-Fi radio. To stop
Android from killing the app with the screen off, a foreground service runs (type `specialUse`, with an
ongoing "Mattel Task aktif" notification).

**FCM.** The app keeps no connection. Google Play Services already holds **one shared connection for all
apps** on the device. When the backend sends a high-priority message, FCM can wake the device, even in
Doze, and the app shows the full-screen alert
([Firebase: message priority](https://firebase.google.com/docs/cloud-messaging/android-message-priority)).
Android may stop treating messages as high priority for an app that often receives high-priority pushes
without showing a notification. The app always shows one, so this should not happen.

## 2. Comparison

| Aspect | Socket | FCM | Both |
| --- | --- | --- | --- |
| **Battery while idle** (Available, no job) | Higher. Own connection + heartbeats keep waking the CPU and radio all shift | Lowest. No extra connection; the shared Play Services connection exists anyway | About the same as socket (the socket dominates) |
| **Battery per job** | Same for all modes: screen on, vibration, sound, HTTP calls. With a few jobs per hour this is likely larger than the idle difference | Same | Same |
| **Temperature** | Slightly warmer at most. Frequent wakeups add a little CPU and radio work; a well-behaved socket should not cause noticeable heat. Rising heat suggests a reconnect loop | No extra heat when idle | Like socket |
| **CPU / memory / performance** | App process always alive (tens of MB of RAM held all shift); a little work on every heartbeat | Process can be stopped when idle; a cold start (~1-2 s) can happen when a push arrives | Like socket |
| **Delivery latency** | Lowest when connected: the server writes to an open socket | Usually seconds; can be delayed by Doze, the app standby bucket, or a slow Play Services link | Fastest of the two that arrives |
| **Reliability with the screen off** | Depends on Android and the vendor allowing the connection in Doze. **Must verify on the WD1 II.** The battery-optimisation exemption via MDM helps | Designed for this; works when the app process is dead | Best: two independent paths, deduplicated by the app |
| **Wi-Fi dead spots** | Connection drops; the app reconnects (1-30 s backoff) and redraws from the snapshot | Messages wait in FCM; with a 60 s TTL a job can expire before arrival (shown as "Penugasan masuk terlambat") | Either path recovers; the snapshot on reconnect fixes state |
| **Live state** (status:changed, watch paired, session ended) | Instant | Only what the backend chooses to push; otherwise fetched on resume / reconnect | Instant |
| **Visible to the user** | Ongoing notification "Mattel Task aktif" all shift | Nothing | Ongoing notification |
| **Dependencies** | Backend socket (exists) | Google Play Services (WD1 II has it) and backend push (missing) | Both |
| **Play Store / OS policy** | `specialUse` foreground service must be declared and justified in Play Console when targeting Android 14+ ([Play policy](https://support.google.com/googleplay/android-developer/answer/16965181)). Not an issue for MDM-only distribution | None special | Like socket |
| **Backend cost** | One open connection per signed-in device | One push per event | Both |

## 3. What this means for the WD1 II

* The watch is on **Wi-Fi only**, and one heartbeat on Wi-Fi costs less than one on cellular. The socket's
  extra battery use on the watch should be modest, but the shift is long (8-12 h) and the battery is
  small, so it has to be measured.
* Each 8-hour shift has ~1,150 heartbeat cycles at a 25 s ping interval. A longer server
  ping interval (for example 60 s) cuts that by more than half; ask the backend whether they can change it.
* Phones on **cellular** pay more per wakeup (the radio stays in a high-power state for a few seconds
  after each exchange), so the gap between socket and FCM is larger on phones than on the watch.

## 4. Recommendation (to confirm with measurements)

1. **Now:** keep `socket`. It is the only mode the backend supports, and the keep-alive service plus the
   snapshot on reconnect cover screen-off and Wi-Fi drops.
2. **If the backend adds push:** move to `both` for reliability: the socket for live state, FCM to wake a
   device whose socket died. Battery stays at socket level.
3. **If measurements show the socket costs too much battery or heat:** switch to `fcm` remotely. Live
   status then updates on resume and reconnect instead of instantly. The job popup is unaffected.

## 5. How to measure (one shift per mode, same device, same Wi-Fi)

Prepare: full charge, same brightness, battery-optimisation exemption granted, same test job schedule
(for example one job every 20 minutes from the backend or the fake backend).

```powershell
# reset stats at shift start
adb shell dumpsys batterystats --reset
# during the shift: battery level and temperature (tenths of °C)
adb shell dumpsys battery
# thermal status (0 = none, higher = throttling)
adb shell dumpsys thermalservice | Select-String "Thermal Status"
# end of shift: per-app usage (look for com.altimeda.mattel.watch)
adb shell dumpsys batterystats --charged com.altimeda.mattel.watch > stats.txt
# detailed timeline: upload a bug report to Battery Historian
adb bugreport bugreport.zip
```

Also check:

* **Latency:** the time from the backend sending the job to the popup appearing. Measure screen on, screen off for
  10 min, and screen off for more than 1 h (Doze).
* **Drops:** count `Realtime disconnected` / `connected` lines in logcat per hour.
* **Heat:** battery temperature every hour; note whether the case feels warm.

## 6. Measured (fill in)

| Device | Mode | Battery used per 8 h | Max battery temp | Thermal status | Popup latency p50 / p95 (screen off) | Missed jobs | Socket drops / h |
| --- | --- | --- | --- | --- | --- | --- | --- |
| WD1 II | socket | | | | | | |
| WD1 II | fcm | | | | | | |
| WD1 II | both | | | | | | |
| Phone | socket | | | | | | |
| Phone | fcm | | | | | | |
