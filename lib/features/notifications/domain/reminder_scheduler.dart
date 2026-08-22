import 'scheduled_reminder.dart';

/// Port for local reminder scheduling. Do not send remote push here.
abstract class ReminderScheduler {
  Future<void> sync(List<ScheduledReminder> reminders);

  Future<bool> requestPermission();
}

class NoOpReminderScheduler implements ReminderScheduler {
  const NoOpReminderScheduler();

  @override
  Future<void> sync(List<ScheduledReminder> reminders) async {}

  @override
  Future<bool> requestPermission() async => true;
}
