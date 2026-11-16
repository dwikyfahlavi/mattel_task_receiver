import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:feature_task/feature_task.dart';
import 'package:retrofit/retrofit.dart';

import 'availability_dtos.dart';

part 'availability_repository.g.dart';

@RestApi()
abstract class AvailabilityApi {
  factory AvailabilityApi(Dio dio, {String? baseUrl}) = _AvailabilityApi;

  @POST('technicians/me/check-in')
  Future<CheckInDto> checkIn();

  @POST('technicians/me/check-out')
  Future<CheckOutDto> checkOut();

  /// One row per shift, newest first. [from] / [to] are `YYYY-MM-DD` and
  /// filter on the shift date.
  @GET('technicians/me/attendance')
  Future<AttendancePageDto> attendance({
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('page') int? page,
    @Query('perPage') int? perPage,
  });
}

/// Check In always requires network; Check Out is optimistic and queueable
/// (doc 16). Check-out is attendance only: it never ends a session.
class AvailabilityRepository {
  AvailabilityRepository({
    required AvailabilityApi api,
    required TaskRepository tasks,
    required ErrorMapper errors,
    required OutboxService outbox,
    required AppClock clock,
  }) : _api = api,
       _tasks = tasks,
       _errors = errors,
       _outbox = outbox,
       _clock = clock {
    _outbox.register(OutboxAction.checkOut, _sendQueuedCheckOut);
  }

  final AvailabilityApi _api;
  final TaskRepository _tasks;
  final ErrorMapper _errors;
  final OutboxService _outbox;
  final AppClock _clock;

  /// Returns the new status. `ALREADY_CHECKED_IN` and `RESUMED` are both
  /// checked in.
  Future<Result<TechnicianStatus>> checkIn() => _errors.guard(() async {
    final r = await _api.checkIn();
    return TechnicianStatus(
      checkedIn: true,
      checkedInAt: r.checkedInAt ?? _clock.serverNowUtc(),
      isAvailable: true,
      shift: r.shift,
    );
  });

  /// Queued Check Outs the server refused (doc 16: reconcile from the server).
  Stream<OutboxConflict> get checkOutConflicts =>
      _outbox.conflicts.where((c) => c.action == OutboxAction.checkOut);

  /// Current status from `GET /technicians/me/state`.
  Future<Result<TechnicianStatus>> current() async =>
      (await _tasks.fetchState()).fold(
        (s) => Result.ok(s.status ?? const TechnicianStatus()),
        Result.err,
      );

  /// Queues Check Out; the caller switches to Unavailable immediately.
  Future<void> checkOut({DateTime? sessionExpiresAt}) => _outbox.enqueue(
    OutboxAction.checkOut,
    idempotencyKey: newIdempotencyKey(),
    expiresAt: sessionExpiresAt,
  );

  /// Shift end and logout: a direct best-effort call, no queue (the queue
  /// is wiped with the session).
  Future<void> checkOutNow() async {
    await _errors.guard(_api.checkOut);
  }

  Future<Result<AttendancePageDto>> attendance({int page = 1}) => _errors.guard(
    () => _api.attendance(page: page, perPage: TaskRepository.pageSize),
  );

  Future<OutboxOutcome> _sendQueuedCheckOut(OutboxItem item) async {
    // `NOT_CHECKED_IN` is a success too: the goal state is reached.
    final r = await _errors.guard(_api.checkOut);
    return outcomeFor(r);
  }

  /// Maps a queued call result to the outbox decision.
  static OutboxOutcome outcomeFor(Result<void> result) => result.fold(
    (_) => OutboxOutcome.done,
    (failure) => switch (failure) {
      NoConnectionFailure() || DeviceClockFailure() => OutboxOutcome.retry,
      ApiFailure(:final statusCode)
          when statusCode >= 500 || statusCode == 429 =>
        OutboxOutcome.retry,
      SessionExpiredFailure() || ApiFailure() => OutboxOutcome.conflict,
      UnexpectedFailure() => OutboxOutcome.retry,
    },
  );
}
