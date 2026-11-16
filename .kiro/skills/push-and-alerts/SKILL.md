---
name: push-and-alerts
description: Change FCM message handling, task event ordering, the alert notification channel, vibration or the background handler. Use for anything touching push delivery or task alerts.
---

# Push events and alerts

## New push type or field
1. Parse it in `PushEvent.parse` (`packages/core/lib/src/push/push_event.dart`). FCM values are strings;
   parsing must never throw (malformed -> `UnknownPushEvent`).
2. Decide it in `TaskEventProcessor` (dedupe by version, out-of-order rules) and add a decision type if needed.
3. Handle the decision in both places: `TaskSessionBloc._onPush` (foreground) and
   `handleBackgroundPush` (background isolate; no GetIt, no feature imports).
4. Update `docs/api_contract.md` and the fake backend's `_send` calls.
5. Tests in `packages/core/test/push/` for ordering/duplicates and in `feature_task` for the bloc.

## Notification channel changes
* Channel settings are immutable on Android. Bump `TaskNotifications.channelId` (`task_alert_v2`), add the
  old id to `_obsoleteChannelIds`, update the manifest `default_notification_channel_id`, and ship a **new
  APK** (not a Shorebird patch).

## Alert behavior rules
* Vibration is primary; `AlertService` loops it in the foreground; the notification carries it in the background.
* Alerts must stop on every exit from `TaskAssigned` (`TaskSessionBloc.onChange`) and on `close()`.
* The popup stays non-dismissible (`PopScope(canPop: false)`) and keeps the screen on only while visible.

## Verify on hardware
Run the checklist in doc 9.5 on the WD1 II after any change here.
