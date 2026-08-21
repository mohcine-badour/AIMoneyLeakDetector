import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../upcoming/domain/payment_reminder_scheduler.dart';
import 'scheduled_reminder.dart';

/// Notification copy. Keep this deterministic and out of widgets.
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
    required String name,
    required Duration offset,
  }) {
    final leadText = lead(offset);
    return switch (kind) {
      ReminderKind.renewal => AppStrings.renewalReminderTitle(name, leadText),
      ReminderKind.trialEnding => AppStrings.trialReminderTitle(name, leadText),
    };
  }

  static String body({
    required ReminderKind kind,
    required double amount,
    required String currencyCode,
  }) {
    final formatted = MoneyFormat.format(amount, currencyCode: currencyCode);
    return switch (kind) {
      ReminderKind.renewal => AppStrings.renewalReminderBody(formatted),
      ReminderKind.trialEnding => AppStrings.trialReminderBody(
          '$formatted${AppStrings.compactPerMonth}',
        ),
    };
  }
}
