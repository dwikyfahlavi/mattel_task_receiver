import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_gate_state.dart';

/// Version gate before login (doc 13.1). Checked at startup, on resume
/// when stale, and when connectivity returns after a failed check.
class AppGateCubit extends Cubit<GateState> {
  AppGateCubit(this._gate) : super(const GateChecking());

  final VersionGate _gate;
  bool _lastFromCache = false;
  bool _checking = false;

  bool get shouldRecheck => _gate.isStale || _lastFromCache;

  /// [applySettings] is false while a popup is visible (settings are applied
  /// only at a safe point, doc 14).
  Future<void> check({bool applySettings = true}) async {
    if (_checking) return;
    _checking = true;
    try {
      final r = await _gate.check(applySettings: applySettings);
      _lastFromCache = r.fromCache;
      if (isClosed) return;
      emit(switch (r.verdict) {
        VersionVerdict.forceUpdate => GateForceUpdate(r.config),
        VersionVerdict.softUpdate => GateOpen(
          softUpdate: true,
          config: r.config,
        ),
        VersionVerdict.upToDate => GateOpen(config: r.config),
      });
    } finally {
      _checking = false;
    }
  }

  Future<void> softPromptShown() async {
    await _gate.markSoftPromptShown();
    final s = state;
    if (s is GateOpen && !isClosed) emit(GateOpen(config: s.config));
  }
}
