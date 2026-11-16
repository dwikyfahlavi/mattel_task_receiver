import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../data/availability_dtos.dart';
import '../../../data/availability_repository.dart';
import '../cubit/attendance_cubit.dart';

/// "Riwayat Kehadiran" (backend "Attendance"): one card per shift with the
/// Check In / Check Out times and the worked time, in Asia/Jakarta.
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({
    required this.repository,
    required this.onBack,
    super.key,
  });

  final AvailabilityRepository repository;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => AttendanceCubit(repository)..refresh(),
    child: _AttendanceView(onBack: onBack),
  );
}

class _AttendanceView extends StatelessWidget {
  const _AttendanceView({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.actionBack,
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: onBack,
        ),
        title: Text(l10n.attendanceTitle),
      ),
      body: MaxWidth(
        maxWidth: 640,
        child: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            final cubit = context.read<AttendanceCubit>();
            if (state.loading && state.items.isEmpty) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, _) => const SkeletonBox(),
              );
            }
            if (state.items.isEmpty) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.error != null
                            ? l10n.attendanceLoadFailed
                            : l10n.attendanceEmpty,
                        textAlign: TextAlign.center,
                      ),
                      if (state.error != null) ...[
                        const SizedBox(height: 12),
                        AppButton(
                          label: l10n.actionRetry,
                          variant: AppButtonVariant.secondary,
                          expand: false,
                          onPressed: cubit.refresh,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: cubit.refresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n.metrics.extentAfter < 300) cubit.loadMore();
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length + (state.loadingMore ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => i >= state.items.length
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _AttendanceCard(row: state.items[i]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({required this.row});

  final AttendanceDto row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    final clock = context.read<AppClock>();
    final date = DateTime.tryParse(row.date);
    final inAt = row.checkedInAt;
    final outAt = row.checkedOutAt;
    final minutes = row.workedMinutes;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(AppShape.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  date == null
                      ? row.date
                      // A plain date: format the calendar day as it is.
                      : clock.formatDate(
                          DateTime.utc(date.year, date.month, date.day, 5),
                        ),
                  style: theme.titleMedium,
                ),
              ),
              if (row.shift != null) Text(row.shift!, style: theme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _TimeLabel(
                label: l10n.attendanceCheckIn,
                value: inAt == null ? '-' : clock.formatTime(inAt),
              ),
              _TimeLabel(
                label: l10n.attendanceCheckOut,
                value: outAt == null
                    ? (row.isOpen ? l10n.attendanceOpen : '-')
                    : clock.formatTime(outAt),
                highlight: row.isOpen,
              ),
              if (minutes != null)
                _TimeLabel(
                  label: '',
                  value: l10n.attendanceWorked(minutes ~/ 60, minutes % 60),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeLabel extends StatelessWidget {
  const _TimeLabel({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final c = AppColors.of(context);
    return Text.rich(
      TextSpan(
        children: [
          if (label.isNotEmpty)
            TextSpan(
              text: '$label ',
              style: theme.bodySmall?.copyWith(color: c.textMuted),
            ),
          TextSpan(
            text: value,
            style: theme.bodyMedium?.copyWith(
              color: highlight ? c.success : null,
              fontWeight: highlight ? FontWeight.w600 : null,
            ),
          ),
        ],
      ),
    );
  }
}
