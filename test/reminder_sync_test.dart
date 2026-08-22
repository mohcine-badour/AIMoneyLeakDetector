import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/notifications/domain/reminder_scheduler.dart';
import 'package:kichta/features/notifications/domain/scheduled_reminder.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';
import 'package:kichta/features/trials/data/drift_trial_repository.dart';
import 'package:kichta/features/trials/domain/trial.dart';
import 'package:kichta/features/upcoming/domain/payment_reminder_scheduler.dart';

import 'helpers/pump_app.dart';

class _RecordingScheduler implements ReminderScheduler {
  List<ScheduledReminder> last = const [];
  var syncs = 0;
  var permissionAllowed = true;
  var permissionRequests = 0;

  @override
  Future<void> sync(List<ScheduledReminder> reminders) async {
    syncs += 1;
    last = reminders;
  }

  @override
  Future<bool> requestPermission() async {
    permissionRequests += 1;
    return permissionAllowed;
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
    await pumpKichtaApp(
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
    expect(scheduler.last.map((item) => item.offset).toSet(), {
      PaymentReminderOffsets.threeDays,
      PaymentReminderOffsets.twentyFourHours,
      PaymentReminderOffsets.twoHours,
    });
  });

  testWidgets('disabled reminders do not schedule on app open', (tester) async {
    final scheduler = _RecordingScheduler();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.dashboard,
      now: _now,
      seed: _seed,
      reminderScheduler: scheduler,
      prefs: const {'reminders/enabled': false},
    );

    expect(scheduler.last, isEmpty);
  });

  testWidgets('cancelling a trial removes its reminders on the next sync', (
    tester,
  ) async {
    final scheduler = _RecordingScheduler();
    await pumpKichtaApp(
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

  testWidgets('turning reminders off clears scheduled notifications', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final scheduler = _RecordingScheduler();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.settings,
      now: _now,
      seed: _seed,
      reminderScheduler: scheduler,
    );

    expect(scheduler.last, hasLength(6));

    await tester.tap(find.byKey(const Key('reminders-toggle')));
    await tester.pumpAndSettle();

    expect(scheduler.last, isEmpty);
  });

  testWidgets('remind me asks for permission and confirms the schedule', (
    tester,
  ) async {
    final scheduler = _RecordingScheduler();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.trialDetailLocation('chatgpt'),
      now: _now,
      seed: _seed,
      reminderScheduler: scheduler,
    );

    await tester.tap(find.byKey(const Key('remind-me')));
    await tester.pumpAndSettle();

    expect(scheduler.permissionRequests, greaterThan(0));
    expect(find.text(AppStrings.reminderArmed), findsOneWidget);
  });

  testWidgets('denied notification permission shows an honest message', (
    tester,
  ) async {
    final scheduler = _RecordingScheduler()..permissionAllowed = false;
    await pumpKichtaApp(
      tester,
      location: AppRoutes.trialDetailLocation('chatgpt'),
      now: _now,
      seed: _seed,
      reminderScheduler: scheduler,
    );

    await tester.tap(find.byKey(const Key('remind-me')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.reminderPermissionDenied), findsOneWidget);
  });
}
