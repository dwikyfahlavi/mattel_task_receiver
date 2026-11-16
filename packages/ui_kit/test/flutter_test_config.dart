import 'dart:async';

import 'package:alchemist/alchemist.dart';

/// Only CI goldens (text drawn as blocks): identical on Windows dev machines
/// and the Linux CI runner. Update with `make goldens`.
Future<void> testExecutable(FutureOr<void> Function() testMain) =>
    AlchemistConfig.runWithConfig(
      config: const AlchemistConfig(
        platformGoldensConfig: PlatformGoldensConfig(enabled: false),
      ),
      run: () async => testMain(),
    );
