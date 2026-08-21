import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

final _now = DateTime.utc(2026, 8, 21, 20);

Future<void> _savePayments(AppDatabase database) async {
  final repository = DriftSubscriptionRepository(database);
  await repository.save(
    Subscription.create(
      id: 'spotify',
      name: 'Spotify',
      merchant: 'Spotify',
      amount: 11.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 7),
      category: SubscriptionCategory.entertainment,
    ),
  );
  await repository.save(
    Subscription.create(
      id: 'adobe',
      name: 'Adobe',
      merchant: 'Adobe',
      amount: 59.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 3),
      category: SubscriptionCategory.productivity,
    ),
  );
  await repository.save(
    Subscription.create(
      id: 'netflix',
      name: 'Netflix',
      merchant: 'Netflix',
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 8, 22),
      category: SubscriptionCategory.entertainment,
    ),
  );
}

void main() {
  testWidgets('empty upcoming list shows an empty state', (tester) async {
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.upcoming,
      now: _now,
    );

    expect(find.text(AppStrings.upcomingPayments), findsOneWidget);
    expect(find.text(AppStrings.emptyUpcomingTitle), findsOneWidget);
  });

  testWidgets('upcoming list is sorted by date', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpBillKillerApp(
      tester,
      location: AppRoutes.upcoming,
      now: _now,
      seed: _savePayments,
    );

    expect(find.text(AppStrings.tomorrow), findsOneWidget);
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text(r'$22.99'), findsOneWidget);
    expect(find.text('Sep 03'), findsOneWidget);
    expect(find.text('Adobe'), findsOneWidget);
    expect(find.text(r'$59.99'), findsOneWidget);
    expect(find.text('Sep 07'), findsOneWidget);
    expect(find.text('Spotify'), findsOneWidget);
    expect(find.text(r'$11.99'), findsOneWidget);

    final netflixY = tester.getTopLeft(find.text('Netflix')).dy;
    final adobeY = tester.getTopLeft(find.text('Adobe')).dy;
    final spotifyY = tester.getTopLeft(find.text('Spotify')).dy;
    expect(netflixY, lessThan(adobeY));
    expect(adobeY, lessThan(spotifyY));
  });

  testWidgets('dashboard view all opens the upcoming timeline', (tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpBillKillerApp(
      tester,
      location: AppRoutes.dashboard,
      now: _now,
    );

    await tester.ensureVisible(find.text(AppStrings.viewAll).first);
    await tester.tap(find.text(AppStrings.viewAll).first);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.upcomingPayments), findsWidgets);
    expect(find.text(AppStrings.emptyUpcomingTitle), findsOneWidget);
  });
}
