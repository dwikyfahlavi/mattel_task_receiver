part of 'app_gate_cubit.dart';

sealed class GateState {
  const GateState();
}

final class GateChecking extends GateState {
  const GateChecking();
}

final class GateOpen extends GateState {
  const GateOpen({this.softUpdate = false, this.config});
  final bool softUpdate;
  final RemoteAppConfig? config;
}

final class GateForceUpdate extends GateState {
  const GateForceUpdate(this.config);
  final RemoteAppConfig? config;
}
