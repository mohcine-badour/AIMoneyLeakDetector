import '../../trials/domain/trial.dart';
import '../../trials/domain/trial_countdown.dart';
import '../../upcoming/domain/upcoming_payment.dart';
import 'scheduled_reminder.dart';

/// Builds reminder events from local subscription and trial records.
abstract final class ReminderEvents {
  static List<ReminderEvent> from({
    required List<UpcomingPayment> payments,
    required List<Trial> trials,
    required DateTime now,
  }) {
    return [
      for (final payment in payments)
        ReminderEvent(
          id: payment.subscriptionId,
          kind: ReminderKind.renewal,
          name: payment.name,
          amount: payment.amount,
          currencyCode: payment.currencyCode,
          eventDate: payment.billingDate,
        ),
      for (final trial in trials)
        if (_includeTrial(trial, now))
          ReminderEvent(
            id: trial.id,
            kind: ReminderKind.trialEnding,
            name: trial.subscriptionName,
            amount: trial.amountAfterTrial,
            currencyCode: trial.currency,
            eventDate: trial.trialEndDate,
          ),
    ];
  }

  static bool _includeTrial(Trial trial, DateTime now) {
    final status = TrialCountdown.displayStatus(
      stored: trial.status,
      trialEndDate: trial.trialEndDate,
      now: now,
    );
    return status != TrialStatus.cancelled && status != TrialStatus.expired;
  }
}
