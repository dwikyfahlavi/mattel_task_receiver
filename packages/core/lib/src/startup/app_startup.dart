import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../config/app_config.dart';
import '../di/core_module.dart';
import '../logging/app_logger.dart';
import '../push/background_handler.dart';
import '../time/app_clock.dart';

/// The minimum done before the first frame (doc 18): binding, Firebase and
/// crash reporting, `id_ID` date symbols. Everything else is lazy.
abstract final class AppStartup {
  static Future<FirebaseStatus> initialize(AppEnvironment environment) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (environment != AppEnvironment.current) {
      // main_<env>.dart and --flavor must agree, otherwise the FCM background
      // isolate would talk to another backend.
      throw StateError(
        'Entry point is ${environment.name} but the flavor is ${AppEnvironment.current.name}. '
        'Run with --flavor ${environment.name} -t lib/main_${environment.name}.dart.',
      );
    }
    await initializeDateFormatting(JakartaTime.locale);

    var configured = false;
    try {
      // Reads google-services.json / GoogleService-Info.plist of the flavor.
      await Firebase.initializeApp();
      configured = true;
    } on Object catch (e) {
      AppLogger.warn(
        'Firebase is not configured for this flavor; push, Remote Config, '
        'Firestore config and Crashlytics are disabled (see docs/SETUP.md)',
        error: e,
      );
    }

    if (configured) {
      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
      FlutterError.onError = crashlytics.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(crashlytics.recordError(error, stack, fatal: true));
        return true;
      };
      AppLogger.reporter = (error, stack, message) =>
          unawaited(crashlytics.recordError(error, stack, reason: message));
    }
    return FirebaseStatus(configured: configured);
  }
}
