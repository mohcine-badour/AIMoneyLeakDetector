import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/notifications/domain/reminder_events.dart';
import 'package:kichta/features/notifications/domain/reminder_planner.dart';
import 'package:kichta/features/notifications/domain/scheduled_reminder.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';
import 'package:kichta/features/trials/domain/trial.dart';
import 'package:kichta/features/upcoming/domain/payment_reminder_scheduler.dart';
import 'package:kichta/features/upcoming/domain/upcoming_payments.dart';

void main() {
  final now = DateTime(2026, 8, 21, 12);

  Subscription subscription({
    required String id,
    required DateTime nextBillingDate,
    SubscriptionStatus status = SubscriptionStatus.active,
  }) {
    return Subscription.create(
      id: id,
      name: 'Netflix',
      merchant: 'Netflix',
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: nextBillingDate,
      category: SubscriptionCategory.entertainment,
      status: status,
    );
  }

  Trial trial({
    required String id,
    required DateTime end,
    TrialStatus status = TrialStatus.active,
  }) {
    return Trial.create(
      id: id,
      subscriptionName: 'ChatGPT',
      amountAfterTrial: 20,
      trialEndDate: end,
      status: status,
    );
  }

  List<ScheduledReminder> plan({
    List<Subscription> subscriptions = const [],
    List<Trial> trials = const [],
    DateTime? clock,
  }) {
    return ReminderPlanner.plan(
      events: ReminderEvents.from(
        payments: UpcomingPayments.fromSubscriptions(subscriptions),
        trials: trials,
        now: clock ?? now,
      ),
      now: clock ?? now,
    );
  }

  test(
    'schedules 3-day, 24-hour, and 2-hour renewal reminders at 09:00 local',
    () {
      final reminders = plan(
        subscriptions: [
          subscription(
            id: 'netflix',
            nextBillingDate: DateTime.utc(2026, 9, 3),
          ),
        ],
      );

      expect(reminders, hasLength(3));
      expect(reminders.map((item) => item.offset), [
        PaymentReminderOffsets.threeDays,
        PaymentReminderOffsets.twentyFourHours,
        PaymentReminderOffsets.twoHours,
      ]);
      expect(reminders[0].fireAt, DateTime(2026, 8, 31, 9));
      expect(reminders[1].fireAt, DateTime(2026, 9, 2, 9));
      expect(reminders[2].fireAt, DateTime(2026, 9, 3, 7));
      expect(reminders[0].title, 'Netflix renews in 3 days');
      expect(reminders[1].title, 'Netflix renews tomorrow');
      expect(reminders[2].title, 'Netflix renews in 2 hours');
      expect(reminders.first.body, r'$22.99 will be charged.');
      expect(reminders.first.kind, ReminderKind.renewal);
    },
  );

  test('skips fire times that are already in the past', () {
    final reminders = plan(
      subscriptions: [
        subscription(id: 'netflix', nextBillingDate: DateTime.utc(2026, 8, 22)),
      ],
    );

    expect(reminders.map((item) => item.offset), [
      PaymentReminderOffsets.twoHours,
    ]);
    expect(reminders.single.fireAt, DateTime(2026, 8, 22, 7));
  });

  test('skips cancelled subscriptions and expired or cancelled trials', () {
    final reminders = plan(
      subscriptions: [
        subscription(
          id: 'paused',
          nextBillingDate: DateTime.utc(2026, 9, 3),
          status: SubscriptionStatus.cancelled,
        ),
      ],
      trials: [
        trial(id: 'expired', end: DateTime.utc(2026, 8, 10)),
        trial(
          id: 'cancelled',
          end: DateTime.utc(2026, 9, 1),
          status: TrialStatus.cancelled,
        ),
      ],
    );

    expect(reminders, isEmpty);
  });

  test(
    'schedules trial-ending reminders and drops them after a date edit moves the event',
    () {
      final original = plan(
        trials: [trial(id: 'chatgpt', end: DateTime.utc(2026, 8, 26))],
      );
      expect(original, hasLength(3));
      expect(original.first.title, 'ChatGPT trial ends in 3 days');
      expect(
        original.first.body,
        r'Cancel before it converts to $20.00/month.',
      );

      final edited = plan(
        trials: [trial(id: 'chatgpt', end: DateTime.utc(2026, 8, 22))],
      );
      expect(edited.map((item) => item.fireAt), [DateTime(2026, 8, 22, 7)]);

      final deleted = plan(trials: const []);
      expect(deleted, isEmpty);
    },
  );

  test('hasUpcoming is false once every offset has passed', () {
    expect(
      ReminderPlanner.hasUpcoming(
        eventDate: DateTime(2026, 8, 21),
        now: DateTime(2026, 8, 21, 12),
      ),
      isFalse,
    );
    expect(
      ReminderPlanner.hasUpcoming(
        eventDate: DateTime(2026, 9, 3),
        now: DateTime(2026, 8, 21, 12),
      ),
      isTrue,
    );
  });

  test('notification ids stay stable for the same event and offset', () {
    expect(
      ReminderPlanner.notificationId(
        'netflix',
        ReminderKind.renewal,
        PaymentReminderOffsets.twoHours,
      ),
      ReminderPlanner.notificationId(
        'netflix',
        ReminderKind.renewal,
        PaymentReminderOffsets.twoHours,
      ),
    );
    expect(
      ReminderPlanner.notificationId(
        'netflix',
        ReminderKind.renewal,
        PaymentReminderOffsets.twoHours,
      ),
      isNot(
        ReminderPlanner.notificationId(
          'netflix',
          ReminderKind.trialEnding,
          PaymentReminderOffsets.twoHours,
        ),
      ),
    );
  });
}
