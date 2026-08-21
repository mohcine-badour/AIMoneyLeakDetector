import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/features/notifications/domain/reminder_scheduler.dart';
import 'package:billkiller_ai/features/notifications/domain/scheduled_reminder.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';
import 'package:billkiller_ai/features/trials/data/drift_trial_repository.dart';
import 'package:billkiller_ai/features/trials/domain/trial.dart';
import 'package:billkiller_ai/features/upcoming/domain/payment_reminder_scheduler.dart';

import 'helpers/pump_app.dart';

class _RecordingScheduler implements ReminderScheduler {
  List<ScheduledReminder> last = const [];
  var syncs = 0;

  @override
  Future<void> sync(List<ScheduledReminder> reminders) async {
    syncs += 1;
    last = reminders;
  }
}

final _now = DateTime(2026, 8, 21, 12);

Future<void> _seed(AppDatabase database) async {
  await DriftSubscriptionRepository(database).save(
    Subscription.create(
      id: 'netflix',
      name: 'Netflix',
      merchant: 'Netflix',
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 3),
      category: SubscriptionCategory.entertainment,
    ),
  );
  await DriftTrialRepository(database).save(
    Trial.create(
      id: 'chatgpt',
      subscriptionName: 'ChatGPT',
      amountAfterTrial: 20,
      trialEndDate: DateTime.utc(2026, 8, 26),
    ),
  );
}

void main() {
  testWidgets('opening the app schedules renewal and trial reminders', (
    tester,
  ) async {
    final scheduler = _RecordingScheduler();
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.dashboard,
      now: _now,
      seed: _seed,
      reminderScheduler: scheduler,
    );

    expect(scheduler.syncs, greaterThan(0));
    expect(scheduler.last, hasLength(6));
    expect(
      scheduler.last.where((item) => item.kind == ReminderKind.renewal),
      hasLength(3),
    );
    expect(
      scheduler.last.where((item) => item.kind == ReminderKind.trialEnding),
      hasLength(3),
    );
    expect(
      scheduler.last.map((item) => item.offset).toSet(),
      {
        PaymentReminderOffsets.threeDays,
        PaymentReminderOffsets.twentyFourHours,
        PaymentReminderOffsets.twoHours,
      },
    );
  });

  testWidgets('cancelling a trial removes its reminders on the next sync', (
    tester,
  ) async {
    final scheduler = _RecordingScheduler();
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.trialDetailLocation('chatgpt'),
      now: _now,
      seed: _seed,
      reminderScheduler: scheduler,
    );

    await tester.tap(find.text('Mark as cancelled'));
    await tester.pumpAndSettle();

    expect(
      scheduler.last.where((item) => item.kind == ReminderKind.trialEnding),
      isEmpty,
    );
    expect(
      scheduler.last.where((item) => item.kind == ReminderKind.renewal),
      hasLength(3),
    );
  });
}
