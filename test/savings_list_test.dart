import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';
import 'package:billkiller_ai/features/trials/data/drift_trial_repository.dart';
import 'package:billkiller_ai/features/trials/domain/trial.dart';

import 'helpers/pump_app.dart';

final _now = DateTime.utc(2026, 8, 21, 20);

Future<void> _seed(AppDatabase database) async {
  final subscriptions = DriftSubscriptionRepository(database);
  await subscriptions.save(
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
  await subscriptions.save(
    Subscription.create(
      id: 'hulu',
      name: 'Hulu',
      merchant: 'Hulu',
      amount: 17.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 10),
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
  testWidgets(
    'empty savings screen shows a zero report and empty suggestions',
    (tester) async {
      await pumpBillKillerApp(tester, location: AppRoutes.savings, now: _now);

      expect(find.text(AppStrings.insightsTitle), findsWidgets);
      expect(find.text(AppStrings.moneyLeakReportTitle), findsOneWidget);
      expect(find.text(AppStrings.youSpend), findsOneWidget);
      expect(find.text(r'$0.00/month'), findsWidgets);
      expect(find.text(AppStrings.analysisReadOnlyNotice), findsOneWidget);
      expect(find.text(AppStrings.subscriptionsToReview(0)), findsOneWidget);
      expect(find.text(AppStrings.emptyLeaksTitle), findsOneWidget);
      expect(find.text(AppStrings.emptyLeaksMessage), findsOneWidget);
    },
  );

  testWidgets(
    'savings report shows spend, overlap extras, and AI explanations',
    (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpBillKillerApp(
        tester,
        location: AppRoutes.savings,
        now: _now,
        seed: _seed,
      );

      expect(find.text(AppStrings.moneyLeakReportTitle), findsOneWidget);
      expect(find.text(r'$40.98/month'), findsOneWidget);
      expect(find.text(r'$17.99/month'), findsOneWidget);
      expect(find.text(AppStrings.subscriptionsToReview(2)), findsOneWidget);
      expect(find.text(AppStrings.possibleOverlaps(1)), findsOneWidget);
      expect(
        find.text(AppStrings.upcomingExpensiveRenewals(0)),
        findsOneWidget,
      );
      expect(find.text(AppStrings.analysisReadOnlyNotice), findsOneWidget);
      expect(find.text('ChatGPT trial ends in 5 days.'), findsOneWidget);
      expect(
        find.text(r'After the trial it converts to $20.00/month.'),
        findsOneWidget,
      );
      expect(find.text(AppStrings.analysisTrialExplanation), findsOneWidget);
      expect(
        find.text('You spend \$40.98/month on Entertainment subscriptions.'),
        findsOneWidget,
      );
      expect(find.text(AppStrings.leakOverlappingReason), findsOneWidget);
      expect(find.text(AppStrings.analysisOverlapExplanation), findsOneWidget);
    },
  );
}
