import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Sink for non-fatal errors (Crashlytics when Firebase is configured).
typedef ErrorReporter = void Function(
  Object error,
  StackTrace? stack,
  String message,
);

/// Logging that never prints secrets (doc 17.1): never pass tokens, QR
/// payloads, credentials or FCM tokens. Messages are logged locally only in
/// debug builds; warnings and errors also go to [reporter].
abstract final class AppLogger {
  static ErrorReporter? reporter;

  static void debug(String message) {
    if (kDebugMode) developer.log(message, name: 'app');
  }

  static void info(String message) {
    if (kDebugMode) developer.log(message, name: 'app', level: 800);
  }

  static void warn(String message, {Object? error, StackTrace? stack}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'app',
        level: 900,
        error: error,
        stackTrace: stack,
      );
    }
    if (error != null) reporter?.call(error, stack, message);
  }

  static void error(String message, Object error, [StackTrace? stack]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'app',
        level: 1000,
        error: error,
        stackTrace: stack,
      );
    }
    reporter?.call(error, stack, message);
  }
}
