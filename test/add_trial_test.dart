import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/features/trials/data/drift_trial_repository.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('empty save shows validation errors', (tester) async {
    await pumpBillKillerApp(tester, location: AppRoutes.addTrial);

    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.errorNameRequired), findsOneWidget);
    expect(find.text(AppStrings.errorAmountInvalid), findsOneWidget);
    expect(find.text(AppStrings.errorTrialEndRequired), findsOneWidget);
    expect(find.text(AppStrings.addTrialTitle), findsOneWidget);
  });

  testWidgets('valid form saves and returns to the trials list', (tester) async {
    final harness = await pumpBillKillerApp(
      tester,
      location: AppRoutes.addTrial,
    );

    await tester.enterText(find.byKey(const Key('trial-name')), 'ChatGPT');
    await tester.enterText(find.byKey(const Key('trial-amount')), '20');

    await tester.ensureVisible(find.byKey(const Key('trial-date')));
    await tester.tap(find.byKey(const Key('trial-date')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text(AppStrings.save));
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.trialsTitle), findsOneWidget);
    expect(find.text(AppStrings.addTrialTitle), findsNothing);
    expect(find.text('ChatGPT'), findsOneWidget);
    expect(find.text(AppStrings.freeTrialBadge), findsOneWidget);
    expect(find.text(AppStrings.afterTrial), findsOneWidget);
    expect(find.text(r'$20.00/month'), findsOneWidget);

    final stored = await DriftTrialRepository(harness.$3).getAll();
    expect(stored, hasLength(1));
    expect(stored.first.subscriptionName, 'ChatGPT');
    expect(stored.first.amountAfterTrial, closeTo(20, 0.001));
  });
}
