import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/brand/brand_registry.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/widgets/app_text_field.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/popular_apps.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

void main() {
  test('popular app slugs stay unique and in the registry', () {
    expect(PopularApps.slugs.toSet().length, PopularApps.slugs.length);
    expect(PopularApps.slugs.length, greaterThan(20));
    for (final slug in PopularApps.slugs) {
      expect(BrandRegistry.getBrand(slug), isNotNull, reason: slug);
    }
  });

  testWidgets('empty save shows validation errors', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.addSubscription);

    await tester.ensureVisible(find.text(AppStrings.reviewBeforeAdding));
    await tester.tap(find.text(AppStrings.reviewBeforeAdding));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.errorNameRequired), findsOneWidget);
    expect(find.text(AppStrings.errorAmountInvalid), findsOneWidget);
    expect(find.text(AppStrings.errorBillingCycleRequired), findsOneWidget);
    expect(find.text(AppStrings.errorDateRequired), findsOneWidget);
    expect(find.text(AppStrings.errorCategoryRequired), findsOneWidget);
    expect(find.text(AppStrings.addSubscriptionTitle), findsOneWidget);
  });

  testWidgets('valid form saves and returns to the subscriptions list', (
    tester,
  ) async {
    final harness = await pumpKichtaApp(
      tester,
      location: AppRoutes.addSubscription,
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

    expect(find.text(AppStrings.beforeYouSubscribeTitle), findsOneWidget);
    expect(find.text(AppStrings.beforeSubscribeNotice), findsOneWidget);
    expect(find.text(r'+$275.88'), findsOneWidget);

    await tester.ensureVisible(find.text(AppStrings.addThisSubscription));
    await tester.tap(find.text(AppStrings.addThisSubscription));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.subscriptionsTitle), findsWidgets);
    expect(find.text(AppStrings.addSubscriptionTitle), findsNothing);
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text(r'$22.99'), findsWidgets);

    final stored = await DriftSubscriptionRepository(harness.$3).getAll();
    expect(stored, hasLength(1));
    expect(stored.first.name, 'Netflix');
    expect(stored.first.merchant, 'Netflix');
    expect(stored.first.amount, closeTo(22.99, 0.001));
    expect(stored.first.billingCycle, BillingCycle.monthly);
    expect(stored.first.category, SubscriptionCategory.entertainment);
    expect(stored.first.source, SubscriptionSource.manual);
  });

  testWidgets('popular app tiles prefill name, merchant, and category', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpKichtaApp(tester, location: AppRoutes.addSubscription);

    expect(find.text(AppStrings.mostPopular), findsOneWidget);
    expect(find.byKey(const Key('popular-app-netflix')), findsOneWidget);

    await tester.tap(find.byKey(const Key('popular-app-netflix')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<AppTextField>(find.byKey(const Key('subscription-name')))
          .controller
          ?.text,
      BrandRegistry.bySlug['netflix']!.displayName,
    );
    expect(
      tester
          .widget<AppTextField>(find.byKey(const Key('subscription-merchant')))
          .controller
          ?.text,
      BrandRegistry.bySlug['netflix']!.displayName,
    );
    expect(find.text(AppStrings.categoryEntertainment), findsOneWidget);
  });
}
