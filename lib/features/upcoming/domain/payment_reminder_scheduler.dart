/// Lead times for renewal and trial reminders.
abstract final class PaymentReminderOffsets {
  static const Duration threeDays = Duration(days: 3);
  static const Duration twentyFourHours = Duration(hours: 24);
  static const Duration twoHours = Duration(hours: 2);

  static const List<Duration> beforeCharge = [
    threeDays,
    twentyFourHours,
    twoHours,
  ];
}
