import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('empty save shows validation errors', (tester) async {
    await pumpBillKillerApp(tester, location: AppRoutes.addSubscription);

    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.tap(find.text(AppStrings.save));
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
    final harness = await pumpBillKillerApp(
      tester,
      location: AppRoutes.addSubscription,
    );

    await tester.enterText(find.byKey(const Key('subscription-name')), 'Netflix');
    await tester.enterText(find.byKey(const Key('subscription-amount')), '22.99');

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

    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.subscriptionsTitle), findsOneWidget);
    expect(find.text(AppStrings.addSubscriptionTitle), findsNothing);
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text(r'$22.99 / month'), findsOneWidget);

    final stored = await DriftSubscriptionRepository(harness.$3).getAll();
    expect(stored, hasLength(1));
    expect(stored.first.name, 'Netflix');
    expect(stored.first.merchant, 'Netflix');
    expect(stored.first.amount, closeTo(22.99, 0.001));
    expect(stored.first.billingCycle, BillingCycle.monthly);
    expect(stored.first.category, SubscriptionCategory.entertainment);
    expect(stored.first.source, SubscriptionSource.manual);
  });
}
