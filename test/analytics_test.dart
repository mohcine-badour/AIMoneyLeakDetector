import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/core/widgets/confirm_dialog.dart';
import 'package:kichta/features/analytics/data/recording_analytics.dart';
import 'package:kichta/features/analytics/domain/analytics_event.dart';
import 'package:kichta/features/paywall/data/fake_billing_client.dart';
import 'package:kichta/features/paywall/domain/entitlement.dart';
import 'package:kichta/features/paywall/domain/paywall_plan.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

Future<void> _saveNetflix(AppDatabase database) {
  return DriftSubscriptionRepository(database).save(
    Subscription.create(
      id: 'netflix',
      name: 'Netflix',
      merchant: 'Netflix',
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 21),
      category: SubscriptionCategory.entertainment,
    ),
  );
}

void _largeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void _expectNoFinancialData(RecordingAnalytics analytics) {
  for (final record in analytics.records) {
    final properties = record.properties ?? const {};
    expect(properties.containsKey('amount'), isFalse);
    expect(properties.containsKey('merchant'), isFalse);
    expect(properties.containsKey('name'), isFalse);
    expect(properties.containsKey('receipt'), isFalse);
    expect(properties.values.whereType<num>(), isEmpty);
  }
}

void main() {
  testWidgets('app open is tracked without financial properties', (
    tester,
  ) async {
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(tester, analytics: analytics);

    expect(analytics.has(AnalyticsEvent.appOpened), isTrue);
    _expectNoFinancialData(analytics);
  });

  testWidgets('welcome events omit financial properties', (tester) async {
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(tester, analytics: analytics);

    expect(analytics.has(AnalyticsEvent.welcomeView), isTrue);
    await tester.tap(find.byKey(const Key('get-started')));
    await tester.pumpAndSettle();
    expect(analytics.has(AnalyticsEvent.getStartedPress), isTrue);
    expect(analytics.has(AnalyticsEvent.anonymousSignInSuccess), isTrue);
    _expectNoFinancialData(analytics);
  });

  testWidgets('onboarding started and completed omit spending amounts', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.onboarding,
      analytics: analytics,
    );

    expect(analytics.has(AnalyticsEvent.onboardingStarted), isTrue);

    await tester.tap(find.byKey(const Key('onboarding-cta')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding-cta')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding-cta')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding-cta')));
    await tester.pumpAndSettle();

    expect(analytics.has(AnalyticsEvent.onboardingCompleted), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.onboardingCompleted), {
      'source': 'cta_final',
      'kind': 'safety',
    });
    _expectNoFinancialData(analytics);
  });

  testWidgets('creating a subscription records source only', (tester) async {
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.addCustomSubscription,
      analytics: analytics,
    );

    await tester.enterText(
      find.byKey(const Key('subscription-name')),
      'Netflix',
    );
    await tester.enterText(
      find.byKey(const Key('subscription-amount')),
      '22.99',
    );
    await tester.ensureVisible(find.byKey(const Key('subscription-cycle')));
    await tester.tap(find.byKey(const Key('subscription-cycle')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.billingMonthly));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('subscription-date')));
    await tester.tap(find.byKey(const Key('subscription-date')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('subscription-category')));
    await tester.tap(find.byKey(const Key('subscription-category')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.categoryEntertainment));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(AppStrings.reviewBeforeAdding));
    await tester.tap(find.text(AppStrings.reviewBeforeAdding));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(AppStrings.addThisSubscription));
    await tester.tap(find.text(AppStrings.addThisSubscription));
    await tester.pumpAndSettle();

    expect(analytics.has(AnalyticsEvent.subscriptionCreated), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.subscriptionCreated), {
      'source': 'manual',
    });
    _expectNoFinancialData(analytics);
  });

  testWidgets('edit and delete record update and delete events', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
      seed: _saveNetflix,
      analytics: analytics,
    );

    await tester.ensureVisible(find.text(AppStrings.edit));
    await tester.tap(find.text(AppStrings.edit));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(analytics.has(AnalyticsEvent.subscriptionUpdated), isTrue);

    await tester.ensureVisible(find.text(AppStrings.delete));
    await tester.tap(find.text(AppStrings.delete));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(ConfirmDialog),
        matching: find.text(AppStrings.delete),
      ),
    );
    await tester.pumpAndSettle();

    expect(analytics.has(AnalyticsEvent.subscriptionDeleted), isTrue);
    _expectNoFinancialData(analytics);
  });

  testWidgets(
    'insights tab does not send financial data or start AI analysis',
    (tester) async {
      final analytics = RecordingAnalytics();
      await pumpKichtaApp(
        tester,
        location: AppRoutes.savings,
        seed: _saveNetflix,
        analytics: analytics,
      );

      expect(analytics.has(AnalyticsEvent.aiAnalysisStarted), isFalse);
      expect(analytics.has(AnalyticsEvent.aiAnalysisCompleted), isFalse);
      _expectNoFinancialData(analytics);
    },
  );

  testWidgets('creating a trial does not send the trial amount', (
    tester,
  ) async {
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.addTrial,
      analytics: analytics,
    );

    await tester.enterText(find.byKey(const Key('trial-name')), 'ChatGPT');
    await tester.enterText(find.byKey(const Key('trial-amount')), '20');
    await tester.ensureVisible(find.byKey(const Key('trial-date')));
    await tester.tap(find.byKey(const Key('trial-date')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(analytics.has(AnalyticsEvent.trialCreated), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.trialCreated), isNull);
    _expectNoFinancialData(analytics);
  });

  testWidgets('paywall purchase omits prices', (tester) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    final billing = FakeBillingClient();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: billing,
      analytics: analytics,
    );

    expect(analytics.has(AnalyticsEvent.paywallViewed), isTrue);

    await tester.tap(find.byKey(const Key('paywall-plan-monthly')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('unlock-pro')));
    await tester.pumpAndSettle();

    expect(analytics.propertiesFor(AnalyticsEvent.purchaseStarted), {
      'plan': 'monthly',
    });
    expect(analytics.propertiesFor(AnalyticsEvent.purchaseCompleted), {
      'plan': 'monthly',
      'success': true,
    });
    expect(billing.lastPurchased, PaywallPlan.monthly);
    _expectNoFinancialData(analytics);
  });

  testWidgets('restore omits prices', (tester) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    final billing = FakeBillingClient()..seed(Entitlement.pro);
    billing.seed(Entitlement.free);
    await pumpKichtaApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: billing,
      analytics: analytics,
    );

    await tester.ensureVisible(find.text(AppStrings.restorePurchases));
    await tester.tap(find.text(AppStrings.restorePurchases));
    await tester.pumpAndSettle();

    expect(analytics.propertiesFor(AnalyticsEvent.purchaseRestored), {
      'success': true,
    });
    _expectNoFinancialData(analytics);
  });

  testWidgets('cancellation guide opened does not send merchant names', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.cancellationGuideLocation('netflix'),
      seed: _saveNetflix,
      analytics: analytics,
    );

    expect(analytics.has(AnalyticsEvent.cancellationGuideOpened), isTrue);
    _expectNoFinancialData(analytics);
  });
}
