import '../../../core/constants/app_strings.dart';
import '../../upcoming/domain/payment_reminder_scheduler.dart';
import 'scheduled_reminder.dart';

/// Notification copy. Keep lock-screen text generic — no merchant or amount.
abstract final class ReminderCopy {
  static String lead(Duration offset) {
    if (offset == PaymentReminderOffsets.threeDays) {
      return AppStrings.reminderLeadIn3Days;
    }
    if (offset == PaymentReminderOffsets.twentyFourHours) {
      return AppStrings.reminderLeadTomorrow;
    }
    if (offset == PaymentReminderOffsets.twoHours) {
      return AppStrings.reminderLeadIn2Hours;
    }
    return AppStrings.reminderLeadSoon;
  }

  static String title({
    required ReminderKind kind,
    required Duration offset,
  }) {
    final leadText = lead(offset);
    return switch (kind) {
      ReminderKind.renewal => AppStrings.renewalReminderTitle(leadText),
      ReminderKind.trialEnding => AppStrings.trialReminderTitle(leadText),
    };
  }

  static String body({required ReminderKind kind}) {
    return switch (kind) {
      ReminderKind.renewal => AppStrings.renewalReminderBody,
      ReminderKind.trialEnding => AppStrings.trialReminderBody,
    };
  }
}
