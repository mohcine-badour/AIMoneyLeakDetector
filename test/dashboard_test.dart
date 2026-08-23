import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/paywall/domain/entitlement.dart';
import 'package:kichta/features/paywall/domain/monetization_config.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';

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
    await pumpKichtaApp(tester, location: AppRoutes.dashboard, now: _now);

    expect(find.text(AppStrings.goodEvening), findsOneWidget);
    expect(find.text(AppStrings.noRenewalsThisWeek), findsOneWidget);
    expect(find.text(AppStrings.noActiveSubscriptionsYet), findsOneWidget);
    expect(find.text(r'$0'), findsWidgets);
    expect(find.text('.00'), findsWidgets);
    expect(find.text(AppStrings.renewingSoon), findsNothing);
    expect(find.text(AppStrings.emptyLeaksMessage), findsNothing);
    expect(find.text(AppStrings.addSubscriptionCta), findsOneWidget);
    expect(find.text(AppStrings.addFirstSubscriptionMessage), findsOneWidget);
    expect(find.byKey(const Key('dashboard-add-subscription')), findsOneWidget);
    expect(find.byKey(const Key('dashboard-unlock-pro')), findsNothing);
    expect(find.text(AppStrings.unlockPro), findsNothing);
    expect(find.text(AppStrings.adLabel), findsNothing);
  });

  testWidgets('dashboard totals and upcoming payments use local data', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpKichtaApp(
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
    expect(find.byKey(const Key('home-upcoming')), findsOneWidget);
    expect(find.text(AppStrings.spendEstimatedFromRecords), findsOneWidget);
    expect(find.text(AppStrings.allSubscriptions), findsOneWidget);
    expect(find.text(AppStrings.addSubscriptionCta), findsNothing);
    expect(find.byKey(const Key('dashboard-add-subscription')), findsNothing);
    expect(find.text(AppStrings.emptyLeaksMessage), findsNothing);
    expect(find.text(r'You could save $0.00/month'), findsNothing);

    await tester.tap(find.byKey(const Key('home-upcoming')));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.upcomingPayments), findsOneWidget);
  });

  testWidgets('free users see an Unlock Pro banner that opens the paywall', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpKichtaApp(
      tester,
      location: AppRoutes.dashboard,
      now: _now,
      monetizationConfig: const MonetizationConfig(featureGatesEnabled: true),
    );

    expect(find.byKey(const Key('dashboard-unlock-pro')), findsOneWidget);
    expect(find.text(AppStrings.unlockPro), findsOneWidget);
    expect(find.text(AppStrings.unlockProSubtitle), findsOneWidget);

    await tester.tap(find.byKey(const Key('dashboard-unlock-pro')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
  });

  testWidgets('Pro users do not see the Unlock Pro banner', (tester) async {
    await pumpKichtaApp(
      tester,
      location: AppRoutes.dashboard,
      now: _now,
      entitlement: Entitlement.pro,
    );

    expect(find.byKey(const Key('dashboard-unlock-pro')), findsNothing);
    expect(find.text(AppStrings.unlockPro), findsNothing);
  });

  testWidgets('home trials row opens the trials list', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpKichtaApp(tester, location: AppRoutes.dashboard, now: _now);

    expect(find.text(AppStrings.trialsTitle), findsOneWidget);
    expect(find.text(AppStrings.trackAFreeTrial), findsOneWidget);
    expect(find.text(AppStrings.emptyTrialsMessage), findsOneWidget);
    expect(find.byKey(const Key('track-free-trial')), findsOneWidget);

    await tester.tap(find.byKey(const Key('open-trials')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.emptyTrialsTitle), findsOneWidget);
  });
}
