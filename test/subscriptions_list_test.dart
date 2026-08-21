import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

Future<void> _saveNetflix(
  AppDatabase database, {
  DateTime? nextBillingDate,
}) {
  return DriftSubscriptionRepository(database).save(
    Subscription.create(
      id: 'netflix',
      name: 'Netflix',
      merchant: 'Netflix',
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: nextBillingDate ?? DateTime.utc(2026, 9, 21),
      category: SubscriptionCategory.entertainment,
    ),
  );
}

Future<void> _saveAdobe(AppDatabase database) {
  return DriftSubscriptionRepository(database).save(
    Subscription.create(
      id: 'adobe',
      name: 'Adobe',
      merchant: 'Adobe',
      amount: 59.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 7),
      category: SubscriptionCategory.productivity,
    ),
  );
}

void main() {
  testWidgets('empty list shows an empty state', (tester) async {
    await pumpBillKillerApp(tester, location: AppRoutes.subscriptions);

    expect(find.text(AppStrings.emptySubscriptionsTitle), findsOneWidget);
    expect(find.text(AppStrings.addSubscriptionTitle), findsWidgets);
  });

  testWidgets('list card shows name, cost, category, and next payment', (
    tester,
  ) async {
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.subscriptions,
      seed: _saveNetflix,
    );

    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text(r'$22.99 / month'), findsOneWidget);
    expect(find.text(AppStrings.categoryEntertainment), findsWidgets);
    expect(find.text(AppStrings.nextPayment), findsOneWidget);
    expect(find.text('Sep 21'), findsOneWidget);
  });

  testWidgets('search and category filter hide non-matching cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpBillKillerApp(
      tester,
      location: AppRoutes.subscriptions,
      seed: (database) async {
        await _saveNetflix(
          database,
          nextBillingDate: DateTime.utc(2026, 9, 3),
        );
        await _saveAdobe(database);
      },
    );

    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('Adobe'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('subscriptions-search')), 'ado');
    await tester.pumpAndSettle();
    expect(find.text('Adobe'), findsOneWidget);
    expect(find.text('Netflix'), findsNothing);

    await tester.enterText(find.byKey(const Key('subscriptions-search')), '');
    await tester.pumpAndSettle();

    await tester.tap(
      find.widgetWithText(FilterChip, AppStrings.categoryEntertainment),
    );
    await tester.pumpAndSettle();
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('Adobe'), findsNothing);
  });
}
