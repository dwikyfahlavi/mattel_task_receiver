import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../connectivity/connectivity_service.dart';

/// Rebuilds with the current online state. Requires a
/// `RepositoryProvider<ConnectivityService>` above it (provided by the apps).
class OnlineBuilder extends StatelessWidget {
  const OnlineBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, bool online) builder;

  @override
  Widget build(BuildContext context) {
    final connectivity = context.read<ConnectivityService>();
    return StreamBuilder<bool>(
      stream: connectivity.onlineChanges,
      initialData: connectivity.isOnline,
      builder: (context, snapshot) =>
          builder(context, snapshot.data ?? connectivity.isOnline),
    );
  }
}
