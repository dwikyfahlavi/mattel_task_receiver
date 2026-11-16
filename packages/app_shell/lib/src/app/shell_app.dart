import 'dart:async';

import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_availability/feature_availability.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

import '../gate/cubit/app_gate_cubit.dart';
import '../routing/shell_paths.dart';
import '../routing/shell_routes.dart';
import '../view/splash_screen.dart';
import '../view/task_overlay.dart';

/// Root widget of both apps: app-scoped blocs, router guard, lifecycle
/// hooks (resume, connectivity) and the task overlay.
class ShellApp extends StatefulWidget {
  const ShellApp({
    required this.routes,
    required this.formFactor,
    this.getIt,
    super.key,
  });

  final ShellRoutes routes;

  /// Fixed for the watch; null means adaptive phone/tablet.
  final FormFactor? formFactor;
  final GetIt? getIt;

  @override
  State<ShellApp> createState() => _ShellAppState();
}

class _ShellAppState extends State<ShellApp> {
  late final GetIt _g = widget.getIt ?? GetIt.instance;
  late final AppConfig _config = _g<AppConfig>();
  late final SessionCubit _session = _g<SessionCubit>();
  late final TaskSessionBloc _tasks = _g<TaskSessionBloc>();
  late final AvailabilityBloc _availability = AvailabilityBloc(
    repository: _g<AvailabilityRepository>(),
    readiness: _g<ReadinessService>(),
    tasks: _tasks,
    connectivity: _g<ConnectivityService>(),
    clock: _g<AppClock>(),
    realtime: _g<RealtimeService>(),
    push: _g<PushService>(),
  );
  late final RealtimeService _realtime = _g<RealtimeService>();
  late final ForegroundKeepAlive _keepAlive = _g<ForegroundKeepAlive>();
  late final ShiftEndCubit _shift = ShiftEndCubit(
    session: _session,
    tasks: _tasks,
    availability: _availability,
    clock: _g<AppClock>(),
    patches: _g<PatchUpdater>(),
    config: _config,
    // Shift end is a version-check point (doc 13.1).
    onShiftEnd: () => unawaited(_gate.check()),
  );
  late final AppGateCubit _gate = AppGateCubit(_g<VersionGate>());
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final _RouterRefresh _refresh = _RouterRefresh([
    _gate.stream,
    _session.stream,
  ]);
  late final GoRouter _router = _buildRouter();
  late final AppLifecycleListener _lifecycle;
  final _subs = <StreamSubscription<Object?>>[];

  @override
  void initState() {
    super.initState();
    final connectivity = _g<ConnectivityService>();
    unawaited(connectivity.start());
    unawaited(
      _g<TaskNotifications>().initialize(
        onTap: (response) {
          final id = TaskNotifications.taskIdFromPayload(response.payload);
          if (id != null) _tasks.add(TaskNotificationTapped(id));
        },
      ),
    );

    _subs
      ..add(_session.stream.listen(_onSession))
      ..add(
        connectivity.onlineChanges.listen((online) {
          if (online) _onRegainedAttention(fromConnectivity: true);
        }),
      )
      ..add(
        _g<SystemAppClock>().offsetChanges.listen((offset) {
          unawaited(
            _g<KeyValueStore>().write(
              clockOffsetKey,
              '${offset.inMilliseconds}',
            ),
          );
        }),
      );

    _lifecycle = AppLifecycleListener(
      onResume: () => _onRegainedAttention(fromConnectivity: false),
    );

    unawaited(_gate.check());
    unawaited(_restore());
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => unawaited(_afterFirstFrame()),
    );
  }

  Future<void> _restore() async {
    final kv = _g<KeyValueStore>();
    final offset = int.tryParse(await kv.read(clockOffsetKey) ?? '');
    if (offset != null) {
      _g<SystemAppClock>().seedOffset(Duration(milliseconds: offset));
    }
    await _session.restore();
  }

  /// Work that must not delay the first frame (doc 18).
  Future<void> _afterFirstFrame() async {
    final settings = _g<RemoteSettings>();
    if (settings is LayeredRemoteSettings) await settings.initialize();
    await settings.fetch();
    if (!_tasks.state.isAssigned) await settings.applyPending();
    await _g<PatchUpdater>().checkAndDownload();
  }

  TaskDelivery get _delivery => TaskDelivery.fromSettings(_g<RemoteSettings>());

  /// Socket and keep-alive service while signed in (D-21). FCM needs
  /// neither: it wakes the app by itself.
  Future<void> _startDelivery() async {
    if (!_delivery.usesSocket) return;
    _realtime.start(RealtimeMode.paired);
    final l10n = lookupAppLocalizations(const Locale('id'));
    await _keepAlive.start(
      title: l10n.keepAliveTitle,
      body: l10n.keepAliveBody,
    );
  }

  Future<void> _stopDelivery() async {
    // The watch QR screen runs its own unpaired socket; leave it alone.
    if (_realtime.mode == RealtimeMode.paired) await _realtime.stop();
    await _keepAlive.stop();
  }

  void _onSession(SessionState s) {
    switch (s) {
      case SessionAuthenticated():
        _tasks.add(const TaskSessionStarted());
        _availability.add(const AvailabilityStarted());
        _g<OutboxService>().start();
        unawaited(_g<AuthRepository>().registerPushToken());
        unawaited(_startDelivery());
        _shift.evaluate();
      case SessionUnauthenticated():
        unawaited(_stopDelivery());
        _tasks.add(const TaskSessionStopped());
        _availability.add(const AvailabilityReset());
        _shift.evaluate();
      case SessionUnknown():
        break;
    }
  }

  /// Resume and reconnect: recover missed state, re-run the shift-end and
  /// version checks (doc 4.3, 9.2, 13.1).
  void _onRegainedAttention({required bool fromConnectivity}) {
    // A dropped socket is retried now instead of after the backoff.
    _realtime.reconnectNow();
    if (_session.state is SessionAuthenticated) {
      _tasks.add(const TaskReconcileRequested());
      _availability.add(const AvailabilityRefreshed());
      unawaited(_g<OutboxService>().flush());
      // Readiness on every resume (doc 12), e.g. notifications turned off
      // in Settings while Available.
      if (!fromConnectivity) {
        _availability.add(const ReadinessRecheckRequested());
      }
    }
    _shift.evaluate();
    final safePoint = !_tasks.state.isAssigned;
    if (_gate.shouldRecheck) {
      unawaited(_gate.check(applySettings: safePoint));
    }
    if (!fromConnectivity) {
      // Safe point: never mid-popup (doc 14).
      if (safePoint) unawaited(_g<RemoteSettings>().applyPending());
      unawaited(_g<PatchUpdater>().checkAndDownload());
    }
  }

  GoRouter _buildRouter() {
    final routes = widget.routes;
    return GoRouter(
      navigatorKey: _navigatorKey,
      initialLocation: ShellPaths.splash,
      refreshListenable: _refresh,
      redirect: (context, state) {
        final loc = state.matchedLocation;
        final gate = _gate.state;
        final session = _session.state;
        if (session is SessionUnknown || gate is GateChecking) {
          return loc == ShellPaths.splash ? null : ShellPaths.splash;
        }
        if (gate is GateForceUpdate) {
          return loc == ShellPaths.update ? null : ShellPaths.update;
        }
        final signedOut = routes.signedOutPaths;
        if (session is SessionUnauthenticated) {
          return signedOut.contains(loc) ? null : routes.signedOutLocation;
        }
        if (loc == ShellPaths.splash ||
            loc == ShellPaths.update ||
            signedOut.contains(loc)) {
          return ShellPaths.home;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: ShellPaths.splash,
          builder: (_, _) => const SplashScreen(),
        ),
        GoRoute(
          path: ShellPaths.update,
          builder: (context, _) => UpdateRequiredScreen(
            config: switch (_gate.state) {
              GateForceUpdate(:final config) => config,
              _ => null,
            },
            inAppUpdateEnabled: _g<FeatureFlags>().isEnabled(
              FeatureFlag.inAppApkUpdate,
            ),
            updater: _g<ApkUpdater>(),
            onRetry: _gate.check,
          ),
        ),
        GoRoute(
          path: ShellPaths.home,
          builder: (context, _) {
            final info = _session.state.infoOrNull;
            if (info == null) return const SplashScreen();
            return HomeScreen(
              session: info,
              onOpenHistory: () => context.push(ShellPaths.history),
              onOpenProfile: () => context.push(ShellPaths.profile),
              onScanQr: routes.scanLocation == null
                  ? null
                  : () => context.push(routes.scanLocation!),
            );
          },
        ),
        GoRoute(
          path: ShellPaths.history,
          builder: (context, _) => HistoryScreen(
            repository: _g<TaskRepository>(),
            onBack: () => context.pop(),
            onOpenInProgress: () => context.pop(),
            onOpenDetail: (id) => context.push(ShellPaths.workOrder(id)),
          ),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => WorkOrderDetailScreen(
                repository: _g<TaskRepository>(),
                workOrderId: state.pathParameters['id']!,
                onBack: () => context.pop(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: ShellPaths.profile,
          builder: (context, _) {
            final info = _session.state.infoOrNull;
            if (info == null) return const SplashScreen();
            return ProfileScreen(
              repository: _g<AuthRepository>(),
              user: info.user,
              // Only the phone can list and unpair watches.
              showWatches: !_config.isWatch,
              onBack: () => context.pop(),
              onOpenAttendance: () => context.push(ShellPaths.attendance),
              onLogout: () => logoutWithConfirm(context),
            );
          },
        ),
        GoRoute(
          path: ShellPaths.attendance,
          builder: (context, _) => AttendanceScreen(
            repository: _g<AvailabilityRepository>(),
            onBack: () => context.pop(),
          ),
        ),
        // Deep link from a notification or MDM (doc 9.2). The popup itself
        // is the overlay; the task id only triggers a reload.
        GoRoute(
          path: '/task/:id',
          redirect: (_, state) {
            final id = state.pathParameters['id'];
            if (id != null) _tasks.add(TaskNotificationTapped(id));
            return ShellPaths.home;
          },
        ),
        ...routes.signedOutRoutes,
        ...routes.signedInRoutes,
      ],
    );
  }

  @override
  void dispose() {
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    _lifecycle.dispose();
    _refresh.dispose();
    _router.dispose();
    unawaited(_shift.close());
    unawaited(_availability.close());
    unawaited(_gate.close());
    unawaited(_tasks.close());
    unawaited(_session.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ff = widget.formFactor;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _config),
        RepositoryProvider.value(value: _g<AppClock>()),
        RepositoryProvider.value(value: _g<ConnectivityService>()),
        RepositoryProvider.value(value: _g<FeatureFlags>()),
        RepositoryProvider.value(value: _g<PushService>()),
        RepositoryProvider.value(value: _g<RealtimeService>()),
        RepositoryProvider.value(value: _g<ReadinessService>()),
        RepositoryProvider.value(value: _g<ReadinessActions>()),
        RepositoryProvider.value(value: _g<AuthRepository>()),
        RepositoryProvider.value(value: _g<TaskRepository>()),
        RepositoryProvider.value(value: _g<ApkUpdater>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _session),
          BlocProvider.value(value: _tasks),
          BlocProvider.value(value: _availability),
          BlocProvider.value(value: _shift),
          BlocProvider.value(value: _gate),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (c) => AppLocalizations.of(c).appName,
          theme: AppTheme.light(formFactor: ff ?? FormFactor.phone),
          locale: const Locale('id'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: _router,
          builder: (context, child) {
            final content = _Frame(
              navigatorKey: _navigatorKey,
              child: TaskOverlay(child: child ?? const SizedBox.shrink()),
            );
            return ff == null
                ? DeviceProfile.adaptive(child: content)
                : DeviceProfile(formFactor: ff, child: content);
          },
        ),
      ),
    );
  }
}

/// Offline banner above every screen and the soft-update prompt.
class _Frame extends StatelessWidget {
  const _Frame({required this.navigatorKey, required this.child});

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  Widget build(BuildContext context) => BlocListener<AppGateCubit, GateState>(
    listenWhen: (_, b) => b is GateOpen && b.softUpdate,
    listener: (context, state) {
      final gate = context.read<AppGateCubit>();
      final navContext = navigatorKey.currentContext;
      if (navContext == null) return;
      final config = (state as GateOpen).config;
      final inApp =
          context.read<FeatureFlags>().isEnabled(FeatureFlag.inAppApkUpdate) &&
          config?.apk != null;
      unawaited(gate.softPromptShown());
      unawaited(
        showSoftUpdateDialog(
          navContext,
          onUpdate: !inApp
              ? null
              : () => navigatorKey.currentState?.push(
                  MaterialPageRoute<void>(
                    builder: (_) => UpdateRequiredScreen(
                      config: config,
                      inAppUpdateEnabled: true,
                      updater: context.read<ApkUpdater>(),
                      onRetry: () {},
                      dismissible: true,
                    ),
                  ),
                ),
        ),
      );
    },
    child: OnlineBuilder(
      builder: (context, online) {
        if (online) return child;
        return Column(
          children: [
            const SafeArea(bottom: false, child: OfflineBanner()),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: child,
              ),
            ),
          ],
        );
      },
    ),
  );
}

/// Re-runs the router redirect when the gate or session changes.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(List<Stream<Object?>> streams) {
    for (final s in streams) {
      _subs.add(s.listen((_) => notifyListeners()));
    }
  }

  final _subs = <StreamSubscription<Object?>>[];

  @override
  void dispose() {
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    super.dispose();
  }
}
