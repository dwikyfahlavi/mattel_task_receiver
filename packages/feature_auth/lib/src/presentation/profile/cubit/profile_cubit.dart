import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/auth_dtos.dart';
import '../../../data/auth_repository.dart';

part 'profile_cubit.freezed.dart';
part 'profile_state.dart';

/// Profile and, on the phone, "Watch Saya" kept live with `watch:paired` /
/// `watch:unpaired` (backend guide, part 1 step 9). Screen-scoped.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required AuthRepository repository,
    required this.showWatches,
    RealtimeService? realtime,
  }) : _repo = repository,
       super(ProfileState(loadingWatches: showWatches)) {
    if (showWatches && realtime != null) {
      _sub = realtime.events.listen(_onEvent);
    }
  }

  final AuthRepository _repo;
  final bool showWatches;
  StreamSubscription<RealtimeEvent>? _sub;

  Future<void> load() async {
    emit(
      state.copyWith(
        loadingProfile: true,
        profileError: null,
        loadingWatches: showWatches,
        watchesError: null,
      ),
    );
    await Future.wait([_loadProfile(), if (showWatches) _loadWatches()]);
  }

  Future<void> _loadProfile() async {
    final r = await _repo.profile();
    if (isClosed) return;
    emit(
      r.fold(
        (p) => state.copyWith(profile: p, loadingProfile: false),
        (f) => state.copyWith(loadingProfile: false, profileError: f),
      ),
    );
  }

  Future<void> _loadWatches() async {
    final r = await _repo.pairedWatches();
    if (isClosed) return;
    emit(
      r.fold(
        (w) => state.copyWith(watches: w, loadingWatches: false),
        (f) => state.copyWith(loadingWatches: false, watchesError: f),
      ),
    );
  }

  void _onEvent(RealtimeEvent e) {
    if (isClosed) return;
    switch (e) {
      case WatchPairedEvent(:final watch):
        emit(
          state.copyWith(
            watches: [
              PairedWatchDto.fromEvent(watch),
              ...state.watches.where((w) => w.sessionId != watch.sessionId),
            ],
          ),
        );
      case WatchUnpairedEvent(:final sessionId):
        emit(
          state.copyWith(
            watches: state.watches
                .where((w) => w.sessionId != sessionId)
                .toList(),
          ),
        );
      case _:
        break;
    }
  }

  /// Checks the technician out and logs the watch out.
  Future<void> unpair(String sessionId) async {
    if (state.unpairing != null) return;
    emit(state.copyWith(unpairing: sessionId, actionError: null));
    final r = await _repo.unpairWatch(sessionId);
    if (isClosed) return;
    emit(
      r.fold(
        (_) => state.copyWith(
          unpairing: null,
          unpairedCount: state.unpairedCount + 1,
          watches: state.watches
              .where((w) => w.sessionId != sessionId)
              .toList(),
        ),
        (f) => state.copyWith(unpairing: null, actionError: f),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
