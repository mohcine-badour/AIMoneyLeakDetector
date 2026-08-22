import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/onboarding/data/onboarding_repository.dart';
import 'package:kichta/features/settings/domain/privacy_policy.dart';
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

void main() {
  testWidgets('settings shows privacy policy and deletion actions', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.settings);

    expect(find.text(AppStrings.settingsTitle), findsWidgets);
    expect(find.text(AppStrings.privacyPolicy), findsOneWidget);
    expect(find.text(AppStrings.deleteMyData), findsOneWidget);
    expect(find.text(AppStrings.deleteAccount), findsOneWidget);
    expect(find.text(AppStrings.appStoreBillingNotice), findsOneWidget);
    expect(find.text(AppStrings.adLabel), findsNothing);
  });

  testWidgets(
    'privacy policy explains local storage and no financial analytics',
    (tester) async {
      _largeScreen(tester);
      await pumpKichtaApp(tester, location: AppRoutes.privacyPolicy);

      expect(find.text(AppStrings.privacyPolicy), findsWidgets);
      expect(find.text(PrivacyPolicy.sections.first.title), findsOneWidget);
      expect(
        find.textContaining('do not put financial amounts', findRichText: true),
        findsOneWidget,
      );
      expect(find.textContaining('AI API secrets'), findsOneWidget);
      expect(find.text(AppStrings.adLabel), findsNothing);
    },
  );

  testWidgets('dashboard opens settings', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.dashboard);

    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.deleteMyData), findsOneWidget);
  });

  testWidgets('deleting data wipes subscriptions and returns to launch', (
    tester,
  ) async {
    _largeScreen(tester);
    final harness = await pumpKichtaApp(
      tester,
      location: AppRoutes.settings,
      seed: _saveNetflix,
    );

    expect(
      await DriftSubscriptionRepository(harness.$3).getAll(),
      hasLength(1),
    );

    await tester.tap(find.byKey(const Key('delete-local-data')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-erasure')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.getStarted), findsOneWidget);
    expect(await DriftSubscriptionRepository(harness.$3).getAll(), isEmpty);
    expect(OnboardingRepository(harness.$2).isCompleted, isFalse);
  });

  testWidgets(
    'deleting account wipes local data without claiming Apple cancel',
    (tester) async {
      _largeScreen(tester);
      final harness = await pumpKichtaApp(
        tester,
        location: AppRoutes.settings,
        seed: _saveNetflix,
      );

      await tester.tap(find.byKey(const Key('delete-account')));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.deleteAccountMessage), findsOneWidget);

      await tester.tap(find.byKey(const Key('confirm-erasure')));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.getStarted), findsOneWidget);
      expect(await DriftSubscriptionRepository(harness.$3).getAll(), isEmpty);
    },
  );
}
