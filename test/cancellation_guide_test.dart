import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/cancellation/domain/cancellation_link_opener.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

class _RecordingOpener implements CancellationLinkOpener {
  Uri? last;

  @override
  Future<bool> open(Uri uri) async {
    last = uri;
    return true;
  }
}

Future<void> _save({
  required AppDatabase database,
  required String id,
  required String name,
  required String merchant,
}) {
  return DriftSubscriptionRepository(database).save(
    Subscription.create(
      id: id,
      name: name,
      merchant: merchant,
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 21),
      category: SubscriptionCategory.entertainment,
    ),
  );
}

void main() {
  testWidgets('Netflix guide shows official steps and opens the cancel page', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final opener = _RecordingOpener();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.subscriptionDetailLocation('netflix'),
      cancellationLinkOpener: opener,
      seed: (database) => _save(
        database: database,
        id: 'netflix',
        name: 'Netflix',
        merchant: 'Netflix',
      ),
    );

    await tester.ensureVisible(find.text(AppStrings.cancellationGuide));
    await tester.tap(find.text(AppStrings.cancellationGuide));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.cancellationDidNotHappen), findsOneWidget);
    expect(find.text(AppStrings.cancellationEstimatedTime), findsOneWidget);
    expect(find.text('About 5 minutes'), findsOneWidget);
    expect(find.text(AppStrings.openCancellationPage), findsOneWidget);
    expect(find.text(AppStrings.generateCancellationMessage), findsOneWidget);

    await tester.tap(find.byKey(const Key('open-cancellation-page')));
    await tester.pumpAndSettle();

    expect(opener.last, Uri.parse('https://www.netflix.com/cancelplan'));
  });

  testWidgets('unknown merchant can generate a message without a fake URL', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpKichtaApp(
      tester,
      location: AppRoutes.cancellationGuideLocation('gym'),
      seed: (database) => _save(
        database: database,
        id: 'gym',
        name: 'Gym membership',
        merchant: 'Local Gym',
      ),
    );

    expect(find.text(AppStrings.openCancellationPage), findsNothing);
    expect(find.text(AppStrings.generateCancellationMessage), findsOneWidget);
    expect(find.textContaining('cannot cancel this merchant'), findsOneWidget);

    await tester.tap(find.byKey(const Key('generate-cancellation-message')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Please cancel my Local Gym subscription (Gym membership). I do not want to be billed again after Sep 21, 2026.',
      ),
      findsOneWidget,
    );
    expect(find.text(AppStrings.cancellationMessageDisclaimer), findsOneWidget);
  });
}
