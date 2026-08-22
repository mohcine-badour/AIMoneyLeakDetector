import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

final _now = DateTime.utc(2026, 8, 21, 20);

Future<void> _saveNetflixAndAdobe(AppDatabase database) async {
  final repository = DriftSubscriptionRepository(database);
  await repository.save(
    Subscription.create(
      id: 'netflix',
      name: 'Netflix',
      merchant: 'Netflix',
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 8, 22),
      category: SubscriptionCategory.entertainment,
      createdAt: DateTime.utc(2026, 8, 1),
    ),
  );
  await repository.save(
    Subscription.create(
      id: 'adobe',
      name: 'Adobe',
      merchant: 'Adobe',
      amount: 59.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 7),
      category: SubscriptionCategory.productivity,
      createdAt: DateTime.utc(2026, 8, 1),
    ),
  );
}

void main() {
  testWidgets('empty dashboard shows zero totals and no leak suggestions', (
    tester,
  ) async {
    await pumpBillKillerApp(tester, location: AppRoutes.dashboard, now: _now);

    expect(find.text(AppStrings.goodEvening), findsOneWidget);
    expect(find.text(AppStrings.noRenewalsThisWeek), findsOneWidget);
    expect(find.text(AppStrings.noActiveSubscriptionsYet), findsOneWidget);
    expect(find.text(r'$0'), findsWidgets);
    expect(find.text('.00'), findsWidgets);
    expect(find.text(AppStrings.renewingSoon), findsNothing);
    expect(find.text(AppStrings.emptyLeaksMessage), findsNothing);
    expect(find.text(AppStrings.addSubscriptionTitle), findsOneWidget);
  });

  testWidgets('dashboard totals and upcoming payments use local data', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpBillKillerApp(
      tester,
      location: AppRoutes.dashboard,
      now: _now,
      seed: _saveNetflixAndAdobe,
    );

    expect(find.text(r'$82'), findsWidgets);
    expect(find.text('.98'), findsWidgets);
    expect(find.text(r'$995.76'), findsWidgets);
    expect(find.text('tomorrow · Aug 22'), findsOneWidget);
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('Adobe'), findsOneWidget);
    expect(find.text(AppStrings.categoryProductivity), findsOneWidget);
    expect(find.text(AppStrings.renewingSoon), findsOneWidget);
    expect(find.text(AppStrings.allSubscriptions), findsOneWidget);
    expect(find.text(AppStrings.addSubscriptionTitle), findsNothing);
    expect(find.text(AppStrings.emptyLeaksMessage), findsNothing);
    expect(find.text(r'You could save $0.00/month'), findsNothing);
  });
}
