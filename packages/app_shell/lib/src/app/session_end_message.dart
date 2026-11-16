import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

/// Copy for the signed-out screen after an automatic sign-out.
String? sessionEndMessage(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  final state = context.watch<SessionCubit>().state;
  if (state is! SessionUnauthenticated) return null;
  return switch (state.reason) {
    SessionEndReason.shiftEnd => l10n.sessionEndedBody,
    SessionEndReason.replaced => l10n.errorSessionReplaced,
    SessionEndReason.deviceDisabled => l10n.errorDeviceDisabled,
    SessionEndReason.expired ||
    SessionEndReason.revoked ||
    SessionEndReason.unpaired => l10n.errorSessionExpired,
    SessionEndReason.logout || null => null,
  };
}
