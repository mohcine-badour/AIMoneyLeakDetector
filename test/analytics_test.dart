import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/features/analytics/data/recording_analytics.dart';
import 'package:billkiller_ai/features/analytics/domain/analytics_event.dart';
import 'package:billkiller_ai/features/paywall/data/fake_billing_client.dart';
import 'package:billkiller_ai/features/paywall/domain/entitlement.dart';
import 'package:billkiller_ai/features/paywall/domain/paywall_plan.dart';
import 'package:billkiller_ai/features/scanner/domain/extracted_receipt.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_extractor.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_image.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

final _png = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class _FakePicker implements ReceiptImagePicker {
  _FakePicker(this.image);

  final ReceiptImage image;

  @override
  Future<ReceiptImage?> pickFromCamera() async => image;

  @override
  Future<ReceiptImage?> pickFromGallery() async => image;
}

class _FailingExtractor implements ReceiptExtractor {
  @override
  Future<ExtractedReceipt> extract(ReceiptImage image) async {
    throw StateError('ocr failed');
  }
}

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
    await pumpBillKillerApp(tester, analytics: analytics);

    expect(analytics.has(AnalyticsEvent.appOpened), isTrue);
    _expectNoFinancialData(analytics);
  });

  testWidgets('onboarding started and completed omit spending amounts', (
    tester,
  ) async {
    final analytics = RecordingAnalytics();
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.onboarding,
      analytics: analytics,
    );

    expect(analytics.has(AnalyticsEvent.onboardingStarted), isTrue);

    await tester.tap(find.text(AppStrings.onboardingFindOut));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.spendingOver200));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.continueLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.savings200));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.continueLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.entryImportLater));
    await tester.pumpAndSettle();

    expect(analytics.has(AnalyticsEvent.onboardingCompleted), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.onboardingCompleted), {
      'source': 'later',
    });
    _expectNoFinancialData(analytics);
  });

  testWidgets('creating a subscription records source only', (tester) async {
    final analytics = RecordingAnalytics();
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.addSubscription,
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
    await pumpBillKillerApp(
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
        of: find.byType(AlertDialog),
        matching: find.text(AppStrings.delete),
      ),
    );
    await tester.pumpAndSettle();

    expect(analytics.has(AnalyticsEvent.subscriptionDeleted), isTrue);
    _expectNoFinancialData(analytics);
  });

  testWidgets('receipt scan started and completed omit extracted amounts', (
    tester,
  ) async {
    final analytics = RecordingAnalytics();
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.scanReceipt,
      imagePicker: _FakePicker(ReceiptImage(bytes: _png)),
      analytics: analytics,
    );

    expect(analytics.has(AnalyticsEvent.receiptScanStarted), isTrue);

    await tester.tap(find.byKey(const Key('scan-camera')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.scanUseThisPhoto));
    await tester.pumpAndSettle();

    expect(analytics.has(AnalyticsEvent.receiptScanCompleted), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.receiptScanCompleted), {
      'success': true,
    });
    _expectNoFinancialData(analytics);
  });

  testWidgets('failed scans do not send receipt text', (tester) async {
    final analytics = RecordingAnalytics();
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.scanReceipt,
      imagePicker: _FakePicker(ReceiptImage(bytes: _png)),
      extractor: _FailingExtractor(),
      analytics: analytics,
    );

    await tester.tap(find.byKey(const Key('scan-camera')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.scanUseThisPhoto));
    await tester.pumpAndSettle();

    expect(analytics.propertiesFor(AnalyticsEvent.receiptScanCompleted), {
      'success': false,
    });
    _expectNoFinancialData(analytics);
  });

  testWidgets('AI analysis started and completed omit spend figures', (
    tester,
  ) async {
    final analytics = RecordingAnalytics();
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.savings,
      seed: _saveNetflix,
      analytics: analytics,
    );

    expect(analytics.has(AnalyticsEvent.aiAnalysisStarted), isTrue);
    expect(analytics.has(AnalyticsEvent.aiAnalysisCompleted), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.aiAnalysisCompleted), {
      'success': true,
    });
    _expectNoFinancialData(analytics);
  });

  testWidgets('creating a trial does not send the trial amount', (
    tester,
  ) async {
    final analytics = RecordingAnalytics();
    await pumpBillKillerApp(
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
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.paywall,
      billingClient: billing,
      analytics: analytics,
    );

    expect(analytics.has(AnalyticsEvent.paywallViewed), isTrue);

    await tester.tap(find.byKey(const Key('paywall-plan-monthly')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.unlockPro));
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
    await pumpBillKillerApp(
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
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.cancellationGuideLocation('netflix'),
      seed: _saveNetflix,
      analytics: analytics,
    );

    expect(analytics.has(AnalyticsEvent.cancellationGuideOpened), isTrue);
    _expectNoFinancialData(analytics);
  });
}
