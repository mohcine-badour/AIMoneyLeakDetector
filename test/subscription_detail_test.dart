import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/core/widgets/confirm_dialog.dart';
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
      createdAt: DateTime.utc(2026, 8, 1),
    ),
  );
}

void main() {
  testWidgets('detail screen shows billed amount, annual cost, and metadata', (
    tester,
  ) async {
    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
      seed: _saveNetflix,
    );

    expect(find.text('Netflix'), findsWidgets);
    expect(find.text(r'$22.99/month'), findsOneWidget);
    expect(find.text(AppStrings.annualLabel), findsOneWidget);
    expect(find.text(r'$275.88'), findsWidgets);
    expect(find.text(AppStrings.billingMonthly), findsOneWidget);
    expect(find.text(AppStrings.categoryEntertainment), findsOneWidget);
    expect(find.text('Sep 21, 2026'), findsOneWidget);
    expect(find.text('Aug 1, 2026'), findsOneWidget);
    expect(find.text(AppStrings.sourceManual), findsOneWidget);
    expect(find.text(AppStrings.edit), findsOneWidget);
    expect(find.text(AppStrings.remindMe), findsOneWidget);
    expect(find.text(AppStrings.pause), findsOneWidget);
    expect(find.text(AppStrings.delete), findsOneWidget);
    expect(find.text(AppStrings.cancellationGuide), findsOneWidget);
  });

  testWidgets('edit updates the subscription and returns to details', (
    tester,
  ) async {
    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
      seed: _saveNetflix,
    );

    await tester.ensureVisible(find.text(AppStrings.edit));
    await tester.tap(find.text(AppStrings.edit));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.editSubscriptionTitle), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Netflix'), findsWidgets);

    await tester.enterText(
      find.byKey(const Key('subscription-name')),
      'Netflix Premium',
    );
    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(find.text('Netflix Premium'), findsWidgets);
    expect(find.text(r'$22.99/month'), findsOneWidget);
    expect(find.text(AppStrings.editSubscriptionTitle), findsNothing);
  });

  testWidgets('delete removes the subscription and returns to the list', (
    tester,
  ) async {
    final harness = await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
      seed: _saveNetflix,
    );

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

    expect(find.text(AppStrings.emptySubscriptionsTitle), findsOneWidget);
    expect(await DriftSubscriptionRepository(harness.$3).getAll(), isEmpty);
  });

  testWidgets('cancellation guide opens the assistant', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
      seed: _saveNetflix,
    );

    await tester.ensureVisible(find.text(AppStrings.cancellationGuide));
    await tester.tap(find.text(AppStrings.cancellationGuide));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.cancellationDidNotHappen), findsOneWidget);
    expect(find.text(AppStrings.openCancellationPage), findsOneWidget);
    expect(find.text(AppStrings.generateCancellationMessage), findsOneWidget);
  });

  testWidgets('usage count shows deterministic cost per use', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
      seed: _saveNetflix,
    );

    expect(find.text(AppStrings.monthlyLabel), findsOneWidget);
    expect(find.text(AppStrings.usesLabel), findsOneWidget);
    expect(find.text(AppStrings.costPerUseLabel), findsOneWidget);
    expect(find.text(AppStrings.costPerUseUnavailable), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('subscription-uses')));
    await tester.enterText(find.byKey(const Key('subscription-uses')), '8');
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.costPerUseUnavailable), findsNothing);
    expect(find.text(r'$2.87'), findsOneWidget);
  });

  testWidgets('log a use increments the recorded count', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
      seed: _saveNetflix,
    );

    await tester.ensureVisible(find.text(AppStrings.logAUse));
    await tester.tap(find.text(AppStrings.logAUse));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsWidgets);
    expect(find.text(AppStrings.costPerUseUnavailable), findsNothing);
  });

  testWidgets('pause from detail marks the subscription paused', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
      seed: _saveNetflix,
    );

    await tester.ensureVisible(find.byKey(const Key('pause-subscription')));
    await tester.tap(find.byKey(const Key('pause-subscription')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.pausedLabel), findsOneWidget);
    expect(find.text(AppStrings.resume), findsOneWidget);
  });
}
