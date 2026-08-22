import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/before_subscribe/domain/subscription_candidate.dart';
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
      nextBillingDate: DateTime.utc(2026, 9, 3),
      category: SubscriptionCategory.entertainment,
    ),
  );
}

void main() {
  testWidgets('shows current vs after spend and waits for confirm', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final candidate = SubscriptionCandidate(
      name: 'YouTube Premium',
      merchant: 'YouTube Premium',
      amount: 13.99,
      currency: 'USD',
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 1),
      category: SubscriptionCategory.entertainment,
    );

    final harness = await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptions,
      seed: _saveNetflix,
    );
    harness.$1.push(AppRoutes.beforeYouSubscribe, extra: candidate);
    await tester.pumpAndSettle();

    expect(find.text('YouTube Premium'), findsOneWidget);
    expect(find.text(r'$13.99/month'), findsOneWidget);
    expect(
      find.text(AppStrings.currentCategorySpending('Entertainment')),
      findsOneWidget,
    );
    expect(find.text(r'$22.99/month'), findsOneWidget);
    expect(find.text(AppStrings.afterAdding), findsOneWidget);
    expect(find.text(r'$36.98/month'), findsOneWidget);
    expect(find.text(AppStrings.annualImpact), findsOneWidget);
    expect(find.text(r'+$167.88'), findsOneWidget);
    expect(find.text(AppStrings.beforeSubscribeNotice), findsOneWidget);
    expect(
      find.textContaining('You already spend \$22.99/month on Entertainment'),
      findsOneWidget,
    );

    expect(
      await DriftSubscriptionRepository(harness.$3).getAll(),
      hasLength(1),
    );

    await tester.ensureVisible(find.text(AppStrings.addThisSubscription));
    await tester.tap(find.text(AppStrings.addThisSubscription));
    await tester.pumpAndSettle();

    final stored = await DriftSubscriptionRepository(harness.$3).getAll();
    expect(stored, hasLength(2));
    expect(stored.map((item) => item.name), contains('YouTube Premium'));
  });
}
