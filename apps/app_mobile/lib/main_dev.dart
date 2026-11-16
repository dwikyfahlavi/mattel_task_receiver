import 'package:core/core.dart';

import 'src/mobile_app.dart';

/// `make run APP=mobile ENV=dev` (fake backend unless API_BASE_URL is set).
Future<void> main() => runMobileApp(AppEnvironment.dev);
