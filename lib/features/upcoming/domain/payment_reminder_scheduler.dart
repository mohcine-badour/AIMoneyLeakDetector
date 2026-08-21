import 'upcoming_payment.dart';

/// Lead times for renewal reminders. Step 13 will schedule these.
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

/// Port for local reminder scheduling. Do not send push notifications here.
abstract class PaymentReminderScheduler {
  Future<void> syncUpcoming(List<UpcomingPayment> payments);
}

class NoOpPaymentReminderScheduler implements PaymentReminderScheduler {
  const NoOpPaymentReminderScheduler();

  @override
  Future<void> syncUpcoming(List<UpcomingPayment> payments) async {}
}
