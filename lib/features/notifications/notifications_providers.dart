import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/clock_provider.dart';
import '../../core/providers/shared_preferences_provider.dart';
import '../trials/domain/trial.dart';
import '../trials/trials_providers.dart';
import '../upcoming/domain/upcoming_payment.dart';
import '../upcoming/upcoming_providers.dart';
import 'domain/reminder_events.dart';
import 'domain/reminder_planner.dart';
import 'domain/reminder_scheduler.dart';
import 'domain/scheduled_reminder.dart';

final reminderSchedulerProvider = Provider<ReminderScheduler>((ref) {
  return const NoOpReminderScheduler();
});

final remindersEnabledProvider =
    NotifierProvider<RemindersEnabledController, bool>(
      RemindersEnabledController.new,
    );

class RemindersEnabledController extends Notifier<bool> {
  static const storageKey = 'reminders/enabled';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  bool build() {
    return ref.watch(sharedPreferencesProvider).getBool(storageKey) ?? true;
  }

  Future<bool> enable() async {
    final allowed = await ref
        .read(reminderSchedulerProvider)
        .requestPermission();
    state = allowed;
    await _prefs.setBool(storageKey, allowed);
    return allowed;
  }

  Future<void> disable() async {
    state = false;
    await _prefs.setBool(storageKey, false);
  }
}

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
  final enabled = ref.watch(remindersEnabledProvider);
  ref.listen(reminderSnapshotProvider, (previous, next) {
    next.whenData((snapshot) {
      final reminders = enabled
          ? ReminderPlanner.plan(
              events: ReminderEvents.from(
                payments: snapshot.payments,
                trials: snapshot.trials,
                now: snapshot.now,
              ),
              now: snapshot.now,
            )
          : const <ScheduledReminder>[];
      ref.read(reminderSchedulerProvider).sync(reminders);
    });
  }, fireImmediately: true);
});
