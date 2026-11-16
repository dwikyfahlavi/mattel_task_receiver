// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkOrderRecordsTable extends WorkOrderRecords
    with TableInfo<$WorkOrderRecordsTable, WorkOrderRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkOrderRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedMeta = const VerificationMeta(
    'resolved',
  );
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
    'resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _resolutionReasonMeta = const VerificationMeta(
    'resolutionReason',
  );
  @override
  late final GeneratedColumn<String> resolutionReason = GeneratedColumn<String>(
    'resolution_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presentedMeta = const VerificationMeta(
    'presented',
  );
  @override
  late final GeneratedColumn<bool> presented = GeneratedColumn<bool>(
    'presented',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("presented" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    taskId,
    resolved,
    resolutionReason,
    presented,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_order_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkOrderRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('resolved')) {
      context.handle(
        _resolvedMeta,
        resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta),
      );
    }
    if (data.containsKey('resolution_reason')) {
      context.handle(
        _resolutionReasonMeta,
        resolutionReason.isAcceptableOrUnknown(
          data['resolution_reason']!,
          _resolutionReasonMeta,
        ),
      );
    }
    if (data.containsKey('presented')) {
      context.handle(
        _presentedMeta,
        presented.isAcceptableOrUnknown(data['presented']!, _presentedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  WorkOrderRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkOrderRecord(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      resolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}resolved'],
      )!,
      resolutionReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolution_reason'],
      ),
      presented: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}presented'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkOrderRecordsTable createAlias(String alias) {
    return $WorkOrderRecordsTable(attachedDatabase, alias);
  }
}

class WorkOrderRecord extends DataClass implements Insertable<WorkOrderRecord> {
  final String taskId;
  final bool resolved;
  final String? resolutionReason;

  /// False when the work order was only seen through `work-order:updated`
  /// (out of order).
  final bool presented;
  final DateTime updatedAt;
  const WorkOrderRecord({
    required this.taskId,
    required this.resolved,
    this.resolutionReason,
    required this.presented,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['resolved'] = Variable<bool>(resolved);
    if (!nullToAbsent || resolutionReason != null) {
      map['resolution_reason'] = Variable<String>(resolutionReason);
    }
    map['presented'] = Variable<bool>(presented);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkOrderRecordsCompanion toCompanion(bool nullToAbsent) {
    return WorkOrderRecordsCompanion(
      taskId: Value(taskId),
      resolved: Value(resolved),
      resolutionReason: resolutionReason == null && nullToAbsent
          ? const Value.absent()
          : Value(resolutionReason),
      presented: Value(presented),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkOrderRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkOrderRecord(
      taskId: serializer.fromJson<String>(json['taskId']),
      resolved: serializer.fromJson<bool>(json['resolved']),
      resolutionReason: serializer.fromJson<String?>(json['resolutionReason']),
      presented: serializer.fromJson<bool>(json['presented']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'resolved': serializer.toJson<bool>(resolved),
      'resolutionReason': serializer.toJson<String?>(resolutionReason),
      'presented': serializer.toJson<bool>(presented),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkOrderRecord copyWith({
    String? taskId,
    bool? resolved,
    Value<String?> resolutionReason = const Value.absent(),
    bool? presented,
    DateTime? updatedAt,
  }) => WorkOrderRecord(
    taskId: taskId ?? this.taskId,
    resolved: resolved ?? this.resolved,
    resolutionReason: resolutionReason.present
        ? resolutionReason.value
        : this.resolutionReason,
    presented: presented ?? this.presented,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkOrderRecord copyWithCompanion(WorkOrderRecordsCompanion data) {
    return WorkOrderRecord(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
      resolutionReason: data.resolutionReason.present
          ? data.resolutionReason.value
          : this.resolutionReason,
      presented: data.presented.present ? data.presented.value : this.presented,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrderRecord(')
          ..write('taskId: $taskId, ')
          ..write('resolved: $resolved, ')
          ..write('resolutionReason: $resolutionReason, ')
          ..write('presented: $presented, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(taskId, resolved, resolutionReason, presented, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkOrderRecord &&
          other.taskId == this.taskId &&
          other.resolved == this.resolved &&
          other.resolutionReason == this.resolutionReason &&
          other.presented == this.presented &&
          other.updatedAt == this.updatedAt);
}

class WorkOrderRecordsCompanion extends UpdateCompanion<WorkOrderRecord> {
  final Value<String> taskId;
  final Value<bool> resolved;
  final Value<String?> resolutionReason;
  final Value<bool> presented;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkOrderRecordsCompanion({
    this.taskId = const Value.absent(),
    this.resolved = const Value.absent(),
    this.resolutionReason = const Value.absent(),
    this.presented = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkOrderRecordsCompanion.insert({
    required String taskId,
    this.resolved = const Value.absent(),
    this.resolutionReason = const Value.absent(),
    this.presented = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       updatedAt = Value(updatedAt);
  static Insertable<WorkOrderRecord> custom({
    Expression<String>? taskId,
    Expression<bool>? resolved,
    Expression<String>? resolutionReason,
    Expression<bool>? presented,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (resolved != null) 'resolved': resolved,
      if (resolutionReason != null) 'resolution_reason': resolutionReason,
      if (presented != null) 'presented': presented,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkOrderRecordsCompanion copyWith({
    Value<String>? taskId,
    Value<bool>? resolved,
    Value<String?>? resolutionReason,
    Value<bool>? presented,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkOrderRecordsCompanion(
      taskId: taskId ?? this.taskId,
      resolved: resolved ?? this.resolved,
      resolutionReason: resolutionReason ?? this.resolutionReason,
      presented: presented ?? this.presented,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    if (resolutionReason.present) {
      map['resolution_reason'] = Variable<String>(resolutionReason.value);
    }
    if (presented.present) {
      map['presented'] = Variable<bool>(presented.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkOrderRecordsCompanion(')
          ..write('taskId: $taskId, ')
          ..write('resolved: $resolved, ')
          ..write('resolutionReason: $resolutionReason, ')
          ..write('presented: $presented, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActiveTasksTable extends ActiveTasks
    with TableInfo<$ActiveTasksTable, ActiveTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taskJsonMeta = const VerificationMeta(
    'taskJson',
  );
  @override
  late final GeneratedColumn<String> taskJson = GeneratedColumn<String>(
    'task_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acceptedAtMeta = const VerificationMeta(
    'acceptedAt',
  );
  @override
  late final GeneratedColumn<DateTime> acceptedAt = GeneratedColumn<DateTime>(
    'accepted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [slot, taskJson, phase, acceptedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    }
    if (data.containsKey('task_json')) {
      context.handle(
        _taskJsonMeta,
        taskJson.isAcceptableOrUnknown(data['task_json']!, _taskJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_taskJsonMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('accepted_at')) {
      context.handle(
        _acceptedAtMeta,
        acceptedAt.isAcceptableOrUnknown(data['accepted_at']!, _acceptedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slot};
  @override
  ActiveTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveTask(
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
      taskJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_json'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      acceptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}accepted_at'],
      ),
    );
  }

  @override
  $ActiveTasksTable createAlias(String alias) {
    return $ActiveTasksTable(attachedDatabase, alias);
  }
}

class ActiveTask extends DataClass implements Insertable<ActiveTask> {
  final int slot;
  final String taskJson;

  /// `assigned` or `in_progress`.
  final String phase;
  final DateTime? acceptedAt;
  const ActiveTask({
    required this.slot,
    required this.taskJson,
    required this.phase,
    this.acceptedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slot'] = Variable<int>(slot);
    map['task_json'] = Variable<String>(taskJson);
    map['phase'] = Variable<String>(phase);
    if (!nullToAbsent || acceptedAt != null) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt);
    }
    return map;
  }

  ActiveTasksCompanion toCompanion(bool nullToAbsent) {
    return ActiveTasksCompanion(
      slot: Value(slot),
      taskJson: Value(taskJson),
      phase: Value(phase),
      acceptedAt: acceptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acceptedAt),
    );
  }

  factory ActiveTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveTask(
      slot: serializer.fromJson<int>(json['slot']),
      taskJson: serializer.fromJson<String>(json['taskJson']),
      phase: serializer.fromJson<String>(json['phase']),
      acceptedAt: serializer.fromJson<DateTime?>(json['acceptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slot': serializer.toJson<int>(slot),
      'taskJson': serializer.toJson<String>(taskJson),
      'phase': serializer.toJson<String>(phase),
      'acceptedAt': serializer.toJson<DateTime?>(acceptedAt),
    };
  }

  ActiveTask copyWith({
    int? slot,
    String? taskJson,
    String? phase,
    Value<DateTime?> acceptedAt = const Value.absent(),
  }) => ActiveTask(
    slot: slot ?? this.slot,
    taskJson: taskJson ?? this.taskJson,
    phase: phase ?? this.phase,
    acceptedAt: acceptedAt.present ? acceptedAt.value : this.acceptedAt,
  );
  ActiveTask copyWithCompanion(ActiveTasksCompanion data) {
    return ActiveTask(
      slot: data.slot.present ? data.slot.value : this.slot,
      taskJson: data.taskJson.present ? data.taskJson.value : this.taskJson,
      phase: data.phase.present ? data.phase.value : this.phase,
      acceptedAt: data.acceptedAt.present
          ? data.acceptedAt.value
          : this.acceptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTask(')
          ..write('slot: $slot, ')
          ..write('taskJson: $taskJson, ')
          ..write('phase: $phase, ')
          ..write('acceptedAt: $acceptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slot, taskJson, phase, acceptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveTask &&
          other.slot == this.slot &&
          other.taskJson == this.taskJson &&
          other.phase == this.phase &&
          other.acceptedAt == this.acceptedAt);
}

class ActiveTasksCompanion extends UpdateCompanion<ActiveTask> {
  final Value<int> slot;
  final Value<String> taskJson;
  final Value<String> phase;
  final Value<DateTime?> acceptedAt;
  const ActiveTasksCompanion({
    this.slot = const Value.absent(),
    this.taskJson = const Value.absent(),
    this.phase = const Value.absent(),
    this.acceptedAt = const Value.absent(),
  });
  ActiveTasksCompanion.insert({
    this.slot = const Value.absent(),
    required String taskJson,
    required String phase,
    this.acceptedAt = const Value.absent(),
  }) : taskJson = Value(taskJson),
       phase = Value(phase);
  static Insertable<ActiveTask> custom({
    Expression<int>? slot,
    Expression<String>? taskJson,
    Expression<String>? phase,
    Expression<DateTime>? acceptedAt,
  }) {
    return RawValuesInsertable({
      if (slot != null) 'slot': slot,
      if (taskJson != null) 'task_json': taskJson,
      if (phase != null) 'phase': phase,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
    });
  }

  ActiveTasksCompanion copyWith({
    Value<int>? slot,
    Value<String>? taskJson,
    Value<String>? phase,
    Value<DateTime?>? acceptedAt,
  }) {
    return ActiveTasksCompanion(
      slot: slot ?? this.slot,
      taskJson: taskJson ?? this.taskJson,
      phase: phase ?? this.phase,
      acceptedAt: acceptedAt ?? this.acceptedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (taskJson.present) {
      map['task_json'] = Variable<String>(taskJson.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (acceptedAt.present) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTasksCompanion(')
          ..write('slot: $slot, ')
          ..write('taskJson: $taskJson, ')
          ..write('phase: $phase, ')
          ..write('acceptedAt: $acceptedAt')
          ..write(')'))
        .toString();
  }
}

class $PendingResultsTable extends PendingResults
    with TableInfo<$PendingResultsTable, PendingResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeJsonMeta = const VerificationMeta(
    'outcomeJson',
  );
  @override
  late final GeneratedColumn<String> outcomeJson = GeneratedColumn<String>(
    'outcome_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, outcomeJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('outcome_json')) {
      context.handle(
        _outcomeJsonMeta,
        outcomeJson.isAcceptableOrUnknown(
          data['outcome_json']!,
          _outcomeJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outcomeJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  PendingResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingResult(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      outcomeJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingResultsTable createAlias(String alias) {
    return $PendingResultsTable(attachedDatabase, alias);
  }
}

class PendingResult extends DataClass implements Insertable<PendingResult> {
  final String taskId;
  final String outcomeJson;
  final DateTime createdAt;
  const PendingResult({
    required this.taskId,
    required this.outcomeJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['outcome_json'] = Variable<String>(outcomeJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingResultsCompanion toCompanion(bool nullToAbsent) {
    return PendingResultsCompanion(
      taskId: Value(taskId),
      outcomeJson: Value(outcomeJson),
      createdAt: Value(createdAt),
    );
  }

  factory PendingResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingResult(
      taskId: serializer.fromJson<String>(json['taskId']),
      outcomeJson: serializer.fromJson<String>(json['outcomeJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'outcomeJson': serializer.toJson<String>(outcomeJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingResult copyWith({
    String? taskId,
    String? outcomeJson,
    DateTime? createdAt,
  }) => PendingResult(
    taskId: taskId ?? this.taskId,
    outcomeJson: outcomeJson ?? this.outcomeJson,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingResult copyWithCompanion(PendingResultsCompanion data) {
    return PendingResult(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      outcomeJson: data.outcomeJson.present
          ? data.outcomeJson.value
          : this.outcomeJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingResult(')
          ..write('taskId: $taskId, ')
          ..write('outcomeJson: $outcomeJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, outcomeJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingResult &&
          other.taskId == this.taskId &&
          other.outcomeJson == this.outcomeJson &&
          other.createdAt == this.createdAt);
}

class PendingResultsCompanion extends UpdateCompanion<PendingResult> {
  final Value<String> taskId;
  final Value<String> outcomeJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PendingResultsCompanion({
    this.taskId = const Value.absent(),
    this.outcomeJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingResultsCompanion.insert({
    required String taskId,
    required String outcomeJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       outcomeJson = Value(outcomeJson),
       createdAt = Value(createdAt);
  static Insertable<PendingResult> custom({
    Expression<String>? taskId,
    Expression<String>? outcomeJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (outcomeJson != null) 'outcome_json': outcomeJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingResultsCompanion copyWith({
    Value<String>? taskId,
    Value<String>? outcomeJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PendingResultsCompanion(
      taskId: taskId ?? this.taskId,
      outcomeJson: outcomeJson ?? this.outcomeJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (outcomeJson.present) {
      map['outcome_json'] = Variable<String>(outcomeJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingResultsCompanion(')
          ..write('taskId: $taskId, ')
          ..write('outcomeJson: $outcomeJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientTimestampMeta = const VerificationMeta(
    'clientTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> clientTimestamp =
      GeneratedColumn<DateTime>(
        'client_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notBeforeMeta = const VerificationMeta(
    'notBefore',
  );
  @override
  late final GeneratedColumn<DateTime> notBefore = GeneratedColumn<DateTime>(
    'not_before',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    action,
    taskId,
    idempotencyKey,
    clientTimestamp,
    attempts,
    notBefore,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('client_timestamp')) {
      context.handle(
        _clientTimestampMeta,
        clientTimestamp.isAcceptableOrUnknown(
          data['client_timestamp']!,
          _clientTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientTimestampMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('not_before')) {
      context.handle(
        _notBeforeMeta,
        notBefore.isAcceptableOrUnknown(data['not_before']!, _notBeforeMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      clientTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_timestamp'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      notBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}not_before'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final int id;

  /// `check_out`.
  final String action;
  final String? taskId;

  /// Local row id (the backend has no idempotency keys).
  final String idempotencyKey;
  final DateTime clientTimestamp;
  final int attempts;
  final DateTime? notBefore;

  /// Entries older than the shift end are dropped.
  final DateTime? expiresAt;
  const OutboxEntry({
    required this.id,
    required this.action,
    this.taskId,
    required this.idempotencyKey,
    required this.clientTimestamp,
    required this.attempts,
    this.notBefore,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['client_timestamp'] = Variable<DateTime>(clientTimestamp);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || notBefore != null) {
      map['not_before'] = Variable<DateTime>(notBefore);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      action: Value(action),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      idempotencyKey: Value(idempotencyKey),
      clientTimestamp: Value(clientTimestamp),
      attempts: Value(attempts),
      notBefore: notBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(notBefore),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      clientTimestamp: serializer.fromJson<DateTime>(json['clientTimestamp']),
      attempts: serializer.fromJson<int>(json['attempts']),
      notBefore: serializer.fromJson<DateTime?>(json['notBefore']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'action': serializer.toJson<String>(action),
      'taskId': serializer.toJson<String?>(taskId),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'clientTimestamp': serializer.toJson<DateTime>(clientTimestamp),
      'attempts': serializer.toJson<int>(attempts),
      'notBefore': serializer.toJson<DateTime?>(notBefore),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  OutboxEntry copyWith({
    int? id,
    String? action,
    Value<String?> taskId = const Value.absent(),
    String? idempotencyKey,
    DateTime? clientTimestamp,
    int? attempts,
    Value<DateTime?> notBefore = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    action: action ?? this.action,
    taskId: taskId.present ? taskId.value : this.taskId,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    clientTimestamp: clientTimestamp ?? this.clientTimestamp,
    attempts: attempts ?? this.attempts,
    notBefore: notBefore.present ? notBefore.value : this.notBefore,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      clientTimestamp: data.clientTimestamp.present
          ? data.clientTimestamp.value
          : this.clientTimestamp,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      notBefore: data.notBefore.present ? data.notBefore.value : this.notBefore,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('taskId: $taskId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('clientTimestamp: $clientTimestamp, ')
          ..write('attempts: $attempts, ')
          ..write('notBefore: $notBefore, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    action,
    taskId,
    idempotencyKey,
    clientTimestamp,
    attempts,
    notBefore,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.action == this.action &&
          other.taskId == this.taskId &&
          other.idempotencyKey == this.idempotencyKey &&
          other.clientTimestamp == this.clientTimestamp &&
          other.attempts == this.attempts &&
          other.notBefore == this.notBefore &&
          other.expiresAt == this.expiresAt);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> id;
  final Value<String> action;
  final Value<String?> taskId;
  final Value<String> idempotencyKey;
  final Value<DateTime> clientTimestamp;
  final Value<int> attempts;
  final Value<DateTime?> notBefore;
  final Value<DateTime?> expiresAt;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.taskId = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.clientTimestamp = const Value.absent(),
    this.attempts = const Value.absent(),
    this.notBefore = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String action,
    this.taskId = const Value.absent(),
    required String idempotencyKey,
    required DateTime clientTimestamp,
    this.attempts = const Value.absent(),
    this.notBefore = const Value.absent(),
    this.expiresAt = const Value.absent(),
  }) : action = Value(action),
       idempotencyKey = Value(idempotencyKey),
       clientTimestamp = Value(clientTimestamp);
  static Insertable<OutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? action,
    Expression<String>? taskId,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? clientTimestamp,
    Expression<int>? attempts,
    Expression<DateTime>? notBefore,
    Expression<DateTime>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (taskId != null) 'task_id': taskId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (clientTimestamp != null) 'client_timestamp': clientTimestamp,
      if (attempts != null) 'attempts': attempts,
      if (notBefore != null) 'not_before': notBefore,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? action,
    Value<String?>? taskId,
    Value<String>? idempotencyKey,
    Value<DateTime>? clientTimestamp,
    Value<int>? attempts,
    Value<DateTime?>? notBefore,
    Value<DateTime?>? expiresAt,
  }) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      taskId: taskId ?? this.taskId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      clientTimestamp: clientTimestamp ?? this.clientTimestamp,
      attempts: attempts ?? this.attempts,
      notBefore: notBefore ?? this.notBefore,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (clientTimestamp.present) {
      map['client_timestamp'] = Variable<DateTime>(clientTimestamp.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (notBefore.present) {
      map['not_before'] = Variable<DateTime>(notBefore.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('taskId: $taskId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('clientTimestamp: $clientTimestamp, ')
          ..write('attempts: $attempts, ')
          ..write('notBefore: $notBefore, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }
}

class $KeyValuesTable extends KeyValues
    with TableInfo<$KeyValuesTable, KeyValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'key_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<KeyValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KeyValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeyValue(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $KeyValuesTable createAlias(String alias) {
    return $KeyValuesTable(attachedDatabase, alias);
  }
}

class KeyValue extends DataClass implements Insertable<KeyValue> {
  final String key;
  final String value;
  const KeyValue({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  KeyValuesCompanion toCompanion(bool nullToAbsent) {
    return KeyValuesCompanion(key: Value(key), value: Value(value));
  }

  factory KeyValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeyValue(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  KeyValue copyWith({String? key, String? value}) =>
      KeyValue(key: key ?? this.key, value: value ?? this.value);
  KeyValue copyWithCompanion(KeyValuesCompanion data) {
    return KeyValue(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeyValue(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeyValue && other.key == this.key && other.value == this.value);
}

class KeyValuesCompanion extends UpdateCompanion<KeyValue> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const KeyValuesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeyValuesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<KeyValue> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeyValuesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return KeyValuesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyValuesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkOrderRecordsTable workOrderRecords = $WorkOrderRecordsTable(
    this,
  );
  late final $ActiveTasksTable activeTasks = $ActiveTasksTable(this);
  late final $PendingResultsTable pendingResults = $PendingResultsTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final $KeyValuesTable keyValues = $KeyValuesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workOrderRecords,
    activeTasks,
    pendingResults,
    outboxEntries,
    keyValues,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$WorkOrderRecordsTableCreateCompanionBuilder =
    WorkOrderRecordsCompanion Function({
      required String taskId,
      Value<bool> resolved,
      Value<String?> resolutionReason,
      Value<bool> presented,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorkOrderRecordsTableUpdateCompanionBuilder =
    WorkOrderRecordsCompanion Function({
      Value<String> taskId,
      Value<bool> resolved,
      Value<String?> resolutionReason,
      Value<bool> presented,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$WorkOrderRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkOrderRecordsTable> {
  $$WorkOrderRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolutionReason => $composableBuilder(
    column: $table.resolutionReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get presented => $composableBuilder(
    column: $table.presented,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkOrderRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkOrderRecordsTable> {
  $$WorkOrderRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolutionReason => $composableBuilder(
    column: $table.resolutionReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get presented => $composableBuilder(
    column: $table.presented,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkOrderRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkOrderRecordsTable> {
  $$WorkOrderRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);

  GeneratedColumn<String> get resolutionReason => $composableBuilder(
    column: $table.resolutionReason,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get presented =>
      $composableBuilder(column: $table.presented, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WorkOrderRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkOrderRecordsTable,
          WorkOrderRecord,
          $$WorkOrderRecordsTableFilterComposer,
          $$WorkOrderRecordsTableOrderingComposer,
          $$WorkOrderRecordsTableAnnotationComposer,
          $$WorkOrderRecordsTableCreateCompanionBuilder,
          $$WorkOrderRecordsTableUpdateCompanionBuilder,
          (
            WorkOrderRecord,
            BaseReferences<
              _$AppDatabase,
              $WorkOrderRecordsTable,
              WorkOrderRecord
            >,
          ),
          WorkOrderRecord,
          PrefetchHooks Function()
        > {
  $$WorkOrderRecordsTableTableManager(
    _$AppDatabase db,
    $WorkOrderRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkOrderRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkOrderRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkOrderRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
                Value<String?> resolutionReason = const Value.absent(),
                Value<bool> presented = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkOrderRecordsCompanion(
                taskId: taskId,
                resolved: resolved,
                resolutionReason: resolutionReason,
                presented: presented,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                Value<bool> resolved = const Value.absent(),
                Value<String?> resolutionReason = const Value.absent(),
                Value<bool> presented = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkOrderRecordsCompanion.insert(
                taskId: taskId,
                resolved: resolved,
                resolutionReason: resolutionReason,
                presented: presented,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkOrderRecordsTable, WorkOrderRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WorkOrderRecordsTable,
                    WorkOrderRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkOrderRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkOrderRecordsTable,
      WorkOrderRecord,
      $$WorkOrderRecordsTableFilterComposer,
      $$WorkOrderRecordsTableOrderingComposer,
      $$WorkOrderRecordsTableAnnotationComposer,
      $$WorkOrderRecordsTableCreateCompanionBuilder,
      $$WorkOrderRecordsTableUpdateCompanionBuilder,
      (
        WorkOrderRecord,
        BaseReferences<_$AppDatabase, $WorkOrderRecordsTable, WorkOrderRecord>,
      ),
      WorkOrderRecord,
      PrefetchHooks Function()
    >;
typedef $$ActiveTasksTableCreateCompanionBuilder =
    ActiveTasksCompanion Function({
      Value<int> slot,
      required String taskJson,
      required String phase,
      Value<DateTime?> acceptedAt,
    });
typedef $$ActiveTasksTableUpdateCompanionBuilder =
    ActiveTasksCompanion Function({
      Value<int> slot,
      Value<String> taskJson,
      Value<String> phase,
      Value<DateTime?> acceptedAt,
    });

class $$ActiveTasksTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveTasksTable> {
  $$ActiveTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskJson => $composableBuilder(
    column: $table.taskJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveTasksTable> {
  $$ActiveTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskJson => $composableBuilder(
    column: $table.taskJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveTasksTable> {
  $$ActiveTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get taskJson =>
      $composableBuilder(column: $table.taskJson, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => column,
  );
}

class $$ActiveTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveTasksTable,
          ActiveTask,
          $$ActiveTasksTableFilterComposer,
          $$ActiveTasksTableOrderingComposer,
          $$ActiveTasksTableAnnotationComposer,
          $$ActiveTasksTableCreateCompanionBuilder,
          $$ActiveTasksTableUpdateCompanionBuilder,
          (
            ActiveTask,
            BaseReferences<_$AppDatabase, $ActiveTasksTable, ActiveTask>,
          ),
          ActiveTask,
          PrefetchHooks Function()
        > {
  $$ActiveTasksTableTableManager(_$AppDatabase db, $ActiveTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                Value<String> taskJson = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<DateTime?> acceptedAt = const Value.absent(),
              }) => ActiveTasksCompanion(
                slot: slot,
                taskJson: taskJson,
                phase: phase,
                acceptedAt: acceptedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                required String taskJson,
                required String phase,
                Value<DateTime?> acceptedAt = const Value.absent(),
              }) => ActiveTasksCompanion.insert(
                slot: slot,
                taskJson: taskJson,
                phase: phase,
                acceptedAt: acceptedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActiveTasksTable, ActiveTask>(table),
                  BaseReferences<_$AppDatabase, $ActiveTasksTable, ActiveTask>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveTasksTable,
      ActiveTask,
      $$ActiveTasksTableFilterComposer,
      $$ActiveTasksTableOrderingComposer,
      $$ActiveTasksTableAnnotationComposer,
      $$ActiveTasksTableCreateCompanionBuilder,
      $$ActiveTasksTableUpdateCompanionBuilder,
      (
        ActiveTask,
        BaseReferences<_$AppDatabase, $ActiveTasksTable, ActiveTask>,
      ),
      ActiveTask,
      PrefetchHooks Function()
    >;
typedef $$PendingResultsTableCreateCompanionBuilder =
    PendingResultsCompanion Function({
      required String taskId,
      required String outcomeJson,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PendingResultsTableUpdateCompanionBuilder =
    PendingResultsCompanion Function({
      Value<String> taskId,
      Value<String> outcomeJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PendingResultsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingResultsTable> {
  $$PendingResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcomeJson => $composableBuilder(
    column: $table.outcomeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingResultsTable> {
  $$PendingResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcomeJson => $composableBuilder(
    column: $table.outcomeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingResultsTable> {
  $$PendingResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get outcomeJson => $composableBuilder(
    column: $table.outcomeJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingResultsTable,
          PendingResult,
          $$PendingResultsTableFilterComposer,
          $$PendingResultsTableOrderingComposer,
          $$PendingResultsTableAnnotationComposer,
          $$PendingResultsTableCreateCompanionBuilder,
          $$PendingResultsTableUpdateCompanionBuilder,
          (
            PendingResult,
            BaseReferences<_$AppDatabase, $PendingResultsTable, PendingResult>,
          ),
          PendingResult,
          PrefetchHooks Function()
        > {
  $$PendingResultsTableTableManager(
    _$AppDatabase db,
    $PendingResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<String> outcomeJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingResultsCompanion(
                taskId: taskId,
                outcomeJson: outcomeJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required String outcomeJson,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PendingResultsCompanion.insert(
                taskId: taskId,
                outcomeJson: outcomeJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PendingResultsTable, PendingResult>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PendingResultsTable,
                    PendingResult
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingResultsTable,
      PendingResult,
      $$PendingResultsTableFilterComposer,
      $$PendingResultsTableOrderingComposer,
      $$PendingResultsTableAnnotationComposer,
      $$PendingResultsTableCreateCompanionBuilder,
      $$PendingResultsTableUpdateCompanionBuilder,
      (
        PendingResult,
        BaseReferences<_$AppDatabase, $PendingResultsTable, PendingResult>,
      ),
      PendingResult,
      PrefetchHooks Function()
    >;
typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      required String action,
      Value<String?> taskId,
      required String idempotencyKey,
      required DateTime clientTimestamp,
      Value<int> attempts,
      Value<DateTime?> notBefore,
      Value<DateTime?> expiresAt,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      Value<String> action,
      Value<String?> taskId,
      Value<String> idempotencyKey,
      Value<DateTime> clientTimestamp,
      Value<int> attempts,
      Value<DateTime?> notBefore,
      Value<DateTime?> expiresAt,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientTimestamp => $composableBuilder(
    column: $table.clientTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get notBefore => $composableBuilder(
    column: $table.notBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientTimestamp => $composableBuilder(
    column: $table.clientTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get notBefore => $composableBuilder(
    column: $table.notBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get clientTimestamp => $composableBuilder(
    column: $table.clientTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get notBefore =>
      $composableBuilder(column: $table.notBefore, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$AppDatabase db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> clientTimestamp = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> notBefore = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
              }) => OutboxEntriesCompanion(
                id: id,
                action: action,
                taskId: taskId,
                idempotencyKey: idempotencyKey,
                clientTimestamp: clientTimestamp,
                attempts: attempts,
                notBefore: notBefore,
                expiresAt: expiresAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String action,
                Value<String?> taskId = const Value.absent(),
                required String idempotencyKey,
                required DateTime clientTimestamp,
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> notBefore = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
              }) => OutboxEntriesCompanion.insert(
                id: id,
                action: action,
                taskId: taskId,
                idempotencyKey: idempotencyKey,
                clientTimestamp: clientTimestamp,
                attempts: attempts,
                notBefore: notBefore,
                expiresAt: expiresAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxEntriesTable, OutboxEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OutboxEntriesTable,
                    OutboxEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$KeyValuesTableCreateCompanionBuilder = KeyValuesCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$KeyValuesTableUpdateCompanionBuilder = KeyValuesCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$KeyValuesTableFilterComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KeyValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KeyValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$KeyValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeyValuesTable,
          KeyValue,
          $$KeyValuesTableFilterComposer,
          $$KeyValuesTableOrderingComposer,
          $$KeyValuesTableAnnotationComposer,
          $$KeyValuesTableCreateCompanionBuilder,
          $$KeyValuesTableUpdateCompanionBuilder,
          (KeyValue, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>),
          KeyValue,
          PrefetchHooks Function()
        > {
  $$KeyValuesTableTableManager(_$AppDatabase db, $KeyValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeyValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeyValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeyValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KeyValuesTable, KeyValue>(table),
                  BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeyValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeyValuesTable,
      KeyValue,
      $$KeyValuesTableFilterComposer,
      $$KeyValuesTableOrderingComposer,
      $$KeyValuesTableAnnotationComposer,
      $$KeyValuesTableCreateCompanionBuilder,
      $$KeyValuesTableUpdateCompanionBuilder,
      (KeyValue, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValue>),
      KeyValue,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkOrderRecordsTableTableManager get workOrderRecords =>
      $$WorkOrderRecordsTableTableManager(_db, _db.workOrderRecords);
  $$ActiveTasksTableTableManager get activeTasks =>
      $$ActiveTasksTableTableManager(_db, _db.activeTasks);
  $$PendingResultsTableTableManager get pendingResults =>
      $$PendingResultsTableTableManager(_db, _db.pendingResults);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
  $$KeyValuesTableTableManager get keyValues =>
      $$KeyValuesTableTableManager(_db, _db.keyValues);
}
