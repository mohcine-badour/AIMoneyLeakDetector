import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/onboarding/data/onboarding_repository.dart';
import 'package:kichta/features/settings/domain/privacy_policy.dart';
import 'package:kichta/features/settings/domain/terms_of_use.dart';
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
    expect(find.text(AppStrings.termsOfUseTitle), findsOneWidget);
    expect(find.text(AppStrings.manageSubscription), findsNothing);
    expect(find.text(AppStrings.support), findsOneWidget);
    expect(find.text(AppStrings.remindersToggle), findsOneWidget);
    expect(find.text(AppStrings.remindersExplanation), findsOneWidget);
    expect(find.text(AppStrings.deleteMyData), findsOneWidget);
    expect(find.text('Reset dismissed insights'), findsNothing);
    expect(find.text(AppStrings.deleteAccount), findsNothing);
    expect(find.text(AppStrings.appStoreBillingNotice), findsOneWidget);
    expect(find.text(AppStrings.adLabel), findsNothing);
  });

  test('privacy policy covers App Store 5.1.1 topics', () {
    final body = PrivacyPolicy.sections
        .map((section) => '${section.title} ${section.body}')
        .join(' ');

    expect(body, contains('encrypted local database'));
    expect(body, contains('iOS Keychain'));
    expect(body, contains('does not require an account'));
    expect(body, contains('same or equal protection'));
    expect(body, contains('do not send financial amounts'));
    expect(body, contains('not directed at children'));
    expect(body, contains('Delete my data'));
    expect(body, contains('kept until you delete it'));
    expect(body, contains('Mohcine Badour'));
    expect(body, contains('mohcinebadour@gmail.com'));
    expect(body, isNot(contains('sign-in screen')));
    expect(body, isNot(contains('Kichta Pro')));
    expect(body, isNot(contains('Google AdMob')));
    expect(body, isNot(contains('RevenueCat')));
    expect(body, isNot(contains('In App Store Connect we declare')));
    expect(body, isNot(contains('paywall viewed')));
    expect(body, isNot(contains('Paid features')));
  });

  testWidgets(
    'privacy policy explains local storage and no financial analytics',
    (tester) async {
      _largeScreen(tester);
      await pumpKichtaApp(tester, location: AppRoutes.privacyPolicy);

      expect(find.text(AppStrings.privacyPolicy), findsWidgets);
      expect(find.text(PrivacyPolicy.sections.first.title), findsOneWidget);
      expect(
        find.text(PrivacyPolicy.groupDevice.toUpperCase()),
        findsOneWidget,
      );
      expect(
        find.textContaining('do not send financial amounts', findRichText: true),
        findsOneWidget,
      );
      expect(find.text(AppStrings.adLabel), findsNothing);
    },
  );

  test('terms of use describe this free version', () {
    final body = TermsOfUse.sections
        .map((section) => '${section.title} ${section.body}')
        .join(' ');

    expect(body, contains('This version of Kichta is free'));
    expect(body, contains('does not cancel'));
    expect(body, contains('not a bank'));
    expect(body, contains('at least 13'));
    expect(body, contains('Mohcine Badour'));
    expect(body, contains('mohcinebadour@gmail.com'));
    expect(body, isNot(contains('Kichta Pro')));
    expect(body, isNot(contains('If you already subscribed')));
    expect(body, isNot(contains('Restore purchases')));
    expect(body, isNot(contains('auto-renewable')));
    expect(body, isNot(contains(r'$19.99')));
  });

  testWidgets('terms of use is a real document, not the privacy policy', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.termsOfUse);

    expect(find.text(AppStrings.termsOfUseTitle), findsWidgets);
    expect(find.textContaining('This version of Kichta is free'), findsWidgets);
    expect(find.textContaining('does not cancel'), findsWidgets);
    expect(find.text(PrivacyPolicy.sections.first.title), findsNothing);
  });

  testWidgets('dashboard opens settings', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.dashboard);

    await tester.tap(find.byKey(const Key('open-settings')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.remindersToggle), findsOneWidget);
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

}
