import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

Future<void> _saveNetflix(AppDatabase database, {DateTime? nextBillingDate}) {
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

void _largeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('empty list shows an empty state', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.subscriptions);

    expect(find.text(AppStrings.emptySubscriptionsTitle), findsOneWidget);
    expect(find.text(AppStrings.addFirstSubscriptionTitle), findsOneWidget);
    expect(find.text(AppStrings.addSubscriptionTitle), findsWidgets);
  });

  testWidgets('list card shows name, cost, category, and next payment', (
    tester,
  ) async {
    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptions,
      now: DateTime.utc(2026, 8, 21),
      seed: _saveNetflix,
    );

    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text(r'$22.99'), findsWidgets);
    expect(find.text('monthly'), findsOneWidget);
    expect(find.text('Entertainment · Sep 21'), findsOneWidget);
    expect(find.text(AppStrings.categorySoftware), findsNothing);
    expect(find.text(AppStrings.nextPayment), findsNothing);
    expect(find.text(r'$22.99 / month'), findsNothing);
    expect(find.text(AppStrings.adLabel), findsNothing);
  });

  testWidgets('search overlay and category chips hide non-matching rows', (
    tester,
  ) async {
    _largeScreen(tester);

    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptions,
      now: DateTime.utc(2026, 8, 21),
      seed: (database) async {
        await _saveNetflix(database, nextBillingDate: DateTime.utc(2026, 9, 3));
        await _saveAdobe(database);
      },
    );

    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('Adobe'), findsOneWidget);
    expect(find.textContaining('2 active'), findsOneWidget);

    await tester.tap(find.byKey(const Key('open-search')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('subscriptions-search')), 'ado');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('Adobe'), findsOneWidget);
    expect(find.text('Netflix'), findsNothing);

    await tester.tap(find.text(AppStrings.cancel));
    await tester.pumpAndSettle();

    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('Adobe'), findsOneWidget);

    await tester.tap(find.text(AppStrings.categoryEntertainment));
    await tester.pumpAndSettle();
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('Adobe'), findsNothing);
    expect(find.textContaining('1 active'), findsOneWidget);
  });
}
