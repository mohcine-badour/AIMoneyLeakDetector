import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/brand/brand_registry.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/popular_apps.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';
import 'package:kichta/features/subscriptions/domain/subscription_catalog.dart';

import 'helpers/pump_app.dart';

void main() {
  test('popular app slugs stay unique and in the catalog', () {
    expect(PopularApps.slugs.toSet().length, PopularApps.slugs.length);
    expect(PopularApps.slugs, SubscriptionCatalog.popularSlugs);
    for (final slug in PopularApps.slugs) {
      expect(SubscriptionCatalog.bySlug[slug], isNotNull, reason: slug);
    }
    expect(
      PopularApps.catalog.map((brand) => brand.slug).toSet(),
      SubscriptionCatalog.all.map((service) => service.slug).toSet(),
    );
  });

  testWidgets('add screen shows popular services and opens custom form', (
    tester,
  ) async {
    await pumpKichtaApp(tester, location: AppRoutes.addSubscription);

    expect(find.text(AppStrings.catalogPopular), findsOneWidget);
    expect(find.text(AppStrings.searchAllSubscriptions), findsOneWidget);
    expect(find.byKey(const Key('catalog-app-netflix')), findsOneWidget);
    expect(find.byKey(const Key('catalog-app-canvapro')), findsNothing);
    expect(find.text(AppStrings.addCustomSubscription), findsOneWidget);
    expect(find.byKey(const Key('subscription-amount')), findsNothing);

    await tester.ensureVisible(find.text(AppStrings.addCustomSubscription));
    await tester.tap(find.text(AppStrings.addCustomSubscription));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('subscription-name')), findsOneWidget);
    expect(find.text(AppStrings.fieldNameHint), findsOneWidget);
    expect(find.text(AppStrings.reviewBeforeAdding), findsOneWidget);
  });

  testWidgets('searching the catalog finds Canva Pro', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.addSubscription);

    await tester.enterText(find.byKey(const Key('catalog-search')), 'Can');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('catalog-app-canvapro')), findsOneWidget);
    expect(find.text('Canva Pro'), findsOneWidget);

    await tester.tap(find.byKey(const Key('catalog-app-canvapro')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextField>(find.byKey(const Key('subscription-name')))
          .controller
          ?.text,
      'Canva Pro',
    );
    expect(find.text(AppStrings.categoryProductivity), findsOneWidget);
  });

  testWidgets('tapping outside a field dismisses the keyboard', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.addCustomSubscription);

    await tester.tap(find.byKey(const Key('subscription-amount')));
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tap(find.text(AppStrings.addSubscriptionTitle));
    await tester.pump();

    expect(tester.testTextInput.isVisible, isFalse);
  });

  testWidgets('empty save shows validation errors', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.addCustomSubscription);

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
      location: AppRoutes.addCustomSubscription,
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

    expect(find.text(AppStrings.catalogPopular), findsOneWidget);
    expect(find.byKey(const Key('catalog-app-netflix')), findsOneWidget);

    await tester.tap(find.byKey(const Key('catalog-app-netflix')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextField>(find.byKey(const Key('subscription-name')))
          .controller
          ?.text,
      BrandRegistry.bySlug['netflix']!.displayName,
    );
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('subscription-merchant')))
          .controller
          ?.text,
      BrandRegistry.bySlug['netflix']!.displayName,
    );
    expect(find.text(AppStrings.categoryEntertainment), findsOneWidget);
  });

  testWidgets('currency sheet shows names and keeps the selected code', (
    tester,
  ) async {
    await pumpKichtaApp(tester, location: AppRoutes.addCustomSubscription);

    await tester.ensureVisible(find.byKey(const Key('subscription-currency')));
    await tester.tap(find.byKey(const Key('subscription-currency')));
    await tester.pumpAndSettle();

    expect(find.text('US dollar'), findsOneWidget);
    expect(find.text('Euro'), findsOneWidget);
    expect(find.text('Swiss franc'), findsOneWidget);
    expect(find.byKey(const Key('currency-USD')), findsOneWidget);

    await tester.tap(find.byKey(const Key('currency-EUR')));
    await tester.pumpAndSettle();

    expect(find.text('€  EUR'), findsOneWidget);
    expect(find.text('US dollar'), findsNothing);
  });

  testWidgets('billing cycle sheet shows cadence and selects weekly', (
    tester,
  ) async {
    await pumpKichtaApp(tester, location: AppRoutes.addCustomSubscription);

    await tester.ensureVisible(find.byKey(const Key('subscription-cycle')));
    await tester.tap(find.byKey(const Key('subscription-cycle')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.billingHintWeekly), findsOneWidget);
    expect(find.text(AppStrings.billingHintMonthly), findsOneWidget);
    expect(find.text(AppStrings.billingHintCustom), findsOneWidget);
    expect(find.byKey(const Key('billing-cycle-monthly')), findsOneWidget);

    await tester.tap(find.byKey(const Key('billing-cycle-weekly')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.billingWeekly), findsOneWidget);
    expect(find.text(AppStrings.weeklyTypicalWarning), findsOneWidget);
    expect(find.text(AppStrings.billingHintMonthly), findsNothing);
  });

  testWidgets('category sheet shows options and hides software', (
    tester,
  ) async {
    await pumpKichtaApp(tester, location: AppRoutes.addCustomSubscription);

    await tester.ensureVisible(find.byKey(const Key('subscription-category')));
    await tester.tap(find.byKey(const Key('subscription-category')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.categoryEntertainment), findsOneWidget);
    expect(find.text(AppStrings.categoryGaming), findsOneWidget);
    expect(find.text(AppStrings.categoryOther), findsOneWidget);
    expect(find.text(AppStrings.categorySoftware), findsNothing);
    expect(find.byKey(const Key('category-entertainment')), findsOneWidget);

    await tester.tap(find.byKey(const Key('category-gaming')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.categoryGaming), findsOneWidget);
    expect(find.text(AppStrings.categoryEntertainment), findsNothing);
  });
}
