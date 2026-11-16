import 'package:core/core.dart';

import '../l10n/generated/app_localizations.dart';

/// User-facing text for a [Failure]. Never shows raw server messages (they
/// are English and technical).
String failureText(AppLocalizations l10n, Failure failure) => switch (failure) {
  NoConnectionFailure() => l10n.offlineActionDisabled,
  DeviceClockFailure() => l10n.errorDeviceClock,
  SessionExpiredFailure() => l10n.errorSessionExpired,
  ApiFailure(:final code, :final retryAfter) => switch (code) {
    ApiErrorCode.invalidCredentials => l10n.loginInvalid,
    ApiErrorCode.rateLimited =>
      retryAfter == null
          ? l10n.errorRateLimited
          : l10n.errorRateLimitedFor((retryAfter.inSeconds / 60).ceil()),
    ApiErrorCode.unauthorized => l10n.errorSessionExpired,
    ApiErrorCode.invalidSignature => l10n.errorDeviceSignature,
    ApiErrorCode.wrongDevice => l10n.errorWrongDevice,
    ApiErrorCode.workOrderAlreadyAnswered => l10n.taskAlreadyResolved,
    ApiErrorCode.notCheckedIn => l10n.errorNotCheckedIn,
    ApiErrorCode.technicianUnavailable => l10n.checkOutBlocked,
    ApiErrorCode.workOrderNotAccepted => l10n.taskConflict,
    ApiErrorCode.workOrderNotFound => l10n.workOrderNotFound,
    ApiErrorCode.pairCodeInvalid => l10n.pairCodeInvalid,
    ApiErrorCode.pairingNotApproved => l10n.watchQrExpired,
    ApiErrorCode.enrollmentCodeInvalid => l10n.enrollInvalid,
    _ => l10n.errorGeneric,
  },
  UnexpectedFailure() => l10n.errorGeneric,
};
