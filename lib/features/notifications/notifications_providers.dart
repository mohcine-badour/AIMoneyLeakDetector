import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/clock_provider.dart';
import '../trials/domain/trial.dart';
import '../trials/trials_providers.dart';
import '../upcoming/domain/upcoming_payment.dart';
import '../upcoming/upcoming_providers.dart';
import 'domain/reminder_events.dart';
import 'domain/reminder_planner.dart';
import 'domain/reminder_scheduler.dart';

final reminderSchedulerProvider = Provider<ReminderScheduler>((ref) {
  return const NoOpReminderScheduler();
});

class ReminderSnapshot {
  const ReminderSnapshot({
    required this.payments,
    required this.trials,
    required this.now,
  });

  final List<UpcomingPayment> payments;
  final List<Trial> trials;
  final DateTime now;
}

final reminderSnapshotProvider = Provider<AsyncValue<ReminderSnapshot>>((ref) {
  final payments = ref.watch(upcomingPaymentsProvider);
  final trials = ref.watch(trialsProvider);
  final now = ref.watch(appNowProvider);

  if (payments.hasError) {
    return AsyncError(payments.error!, payments.stackTrace ?? StackTrace.empty);
  }
  if (trials.hasError) {
    return AsyncError(trials.error!, trials.stackTrace ?? StackTrace.empty);
  }
  if (!payments.hasValue || !trials.hasValue) {
    return const AsyncLoading();
  }
  return AsyncData(
    ReminderSnapshot(
      payments: payments.requireValue,
      trials: trials.requireValue,
      now: now,
    ),
  );
});

/// Keeps local trial and renewal reminders in sync with stored records.
final reminderSyncProvider = Provider<void>((ref) {
  ref.listen(reminderSnapshotProvider, (previous, next) {
    next.whenData((snapshot) {
      final reminders = ReminderPlanner.plan(
        events: ReminderEvents.from(
          payments: snapshot.payments,
          trials: snapshot.trials,
          now: snapshot.now,
        ),
        now: snapshot.now,
      );
      ref.read(reminderSchedulerProvider).sync(reminders);
    });
  }, fireImmediately: true);
});
