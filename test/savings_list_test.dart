import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/insights/domain/insight_copy.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';
import 'package:kichta/features/trials/data/drift_trial_repository.dart';
import 'package:kichta/features/trials/domain/trial.dart';

import 'helpers/pump_app.dart';

final _now = DateTime.utc(2026, 8, 21, 20);
final _created = DateTime.utc(2026, 1, 15);

Future<void> _seedEntertainment(AppDatabase database) async {
  final subscriptions = DriftSubscriptionRepository(database);
  await subscriptions.save(
    Subscription.create(
      id: 'netflix',
      name: 'Netflix',
      merchant: 'Netflix',
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 8, 24),
      category: SubscriptionCategory.entertainment,
      createdAt: _created,
    ),
  );
  await subscriptions.save(
    Subscription.create(
      id: 'hulu',
      name: 'Hulu',
      merchant: 'Hulu',
      amount: 17.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 10),
      category: SubscriptionCategory.entertainment,
      createdAt: _created,
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

Future<void> _seedNetflixOnly(AppDatabase database) {
  return DriftSubscriptionRepository(database).save(
    Subscription.create(
      id: 'netflix',
      name: 'Netflix',
      merchant: 'Netflix',
      amount: 15.49,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 3),
      category: SubscriptionCategory.entertainment,
      createdAt: _created,
    ),
  );
}

void _largeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('empty insights shows coming state without zero cards', (
    tester,
  ) async {
    await pumpKichtaApp(tester, location: AppRoutes.savings, now: _now);

    expect(find.text(AppStrings.insightsTitle), findsWidgets);
    expect(find.text(AppStrings.insightsComing), findsOneWidget);
    expect(find.text(AppStrings.insightsEmptyMessage), findsOneWidget);
    expect(find.text(AppStrings.addSubscriptionCta), findsOneWidget);
    expect(find.text(AppStrings.moneyLeakReportTitle), findsNothing);
    expect(find.text(AppStrings.analysisReadOnlyNotice), findsNothing);
    expect(find.text(r'$0.00/month'), findsNothing);
    expect(find.text(AppStrings.youSpend), findsNothing);
    expect(find.text(AppStrings.emptyLeaksTitle), findsNothing);
  });

  testWidgets(
    'insights shows spend, categories, top cost, and overlap callout',
    (tester) async {
      _largeScreen(tester);
      await pumpKichtaApp(
        tester,
        location: AppRoutes.savings,
        now: _now,
        seed: _seedEntertainment,
      );

      expect(find.text(AppStrings.insightsTitle), findsWidgets);
      expect(find.text(AppStrings.thisMonth), findsOneWidget);
      expect(find.text(r'$40.98'), findsWidgets);
      expect(find.text('/month'), findsOneWidget);
      expect(find.text(r'$491.76'), findsOneWidget);
      expect(find.text(AppStrings.whereItGoes), findsOneWidget);
      expect(find.text(AppStrings.categoryCount(1)), findsOneWidget);
      expect(find.text('Entertainment'), findsWidgets);
      expect(find.text(AppStrings.topByCost), findsOneWidget);
      expect(find.text(AppStrings.percentOfTotal(100)), findsOneWidget);
      expect(find.text('Netflix'), findsWidgets);
      expect(find.text('Hulu'), findsWidgets);
      expect(find.text(AppStrings.forYou), findsOneWidget);
      expect(
        find.text(InsightCopy.overlapTitle(2, 'Entertainment')),
        findsOneWidget,
      );
      expect(
        find.text(InsightCopy.overlapSubtitle(r'$17.99')),
        findsOneWidget,
      );
      expect(find.text(AppStrings.moneyLeakReportTitle), findsNothing);
      expect(find.text(AppStrings.analysisReadOnlyNotice), findsNothing);
      expect(find.text(AppStrings.possibleOverlaps(0)), findsNothing);
      expect(find.text(AppStrings.possibleOverlaps(1)), findsNothing);
      expect(find.text('ChatGPT trial ends in 5 days.'), findsNothing);
    },
  );

  testWidgets('timeframe change updates the hero total, not the insight', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(
      tester,
      location: AppRoutes.savings,
      now: _now,
      seed: _seedEntertainment,
    );

    await tester.tap(find.byKey(const Key('timeframe-chip')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Last 6 months'));
    await tester.pumpAndSettle();

    expect(find.text(r'$245.88'), findsWidgets);
    expect(find.text('/6 mo'), findsOneWidget);
    expect(
      find.text(InsightCopy.overlapTitle(2, 'Entertainment')),
      findsOneWidget,
    );
  });

  testWidgets('one subscription renders charts without a for-you section', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(
      tester,
      location: AppRoutes.savings,
      now: _now,
      seed: _seedNetflixOnly,
    );

    expect(find.text(r'$15.49'), findsWidgets);
    expect(find.text(AppStrings.whereItGoes), findsOneWidget);
    expect(find.text(AppStrings.topByCost), findsOneWidget);
    expect(find.text(AppStrings.forYou), findsNothing);
    expect(find.text(AppStrings.insightsComing), findsNothing);
  });

  testWidgets('dismissing the only insight unmounts the for-you section', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(
      tester,
      location: AppRoutes.savings,
      now: _now,
      seed: _seedEntertainment,
    );

    expect(find.text(AppStrings.forYou), findsOneWidget);
    await tester.tap(find.text(AppStrings.dismiss));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.forYou), findsNothing);
    expect(
      find.text(InsightCopy.overlapTitle(2, 'Entertainment')),
      findsNothing,
    );
  });

  testWidgets('legend row opens subscriptions with that category', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(
      tester,
      location: AppRoutes.savings,
      now: _now,
      seed: _seedEntertainment,
    );

    await tester.tap(find.byKey(const Key('category-legend-entertainment')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('filter-entertainment')), findsOneWidget);
    expect(find.text('Netflix'), findsWidgets);
    expect(find.text('Hulu'), findsWidgets);
  });
}
