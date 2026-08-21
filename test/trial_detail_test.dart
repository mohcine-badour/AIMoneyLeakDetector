import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/features/trials/data/drift_trial_repository.dart';
import 'package:billkiller_ai/features/trials/domain/trial.dart';

import 'helpers/pump_app.dart';

final _now = DateTime.utc(2026, 8, 21);

Future<void> _saveChatGPT(AppDatabase database) async {
  await DriftTrialRepository(database).save(
    Trial.create(
      id: 'chatgpt',
      subscriptionName: 'ChatGPT',
      amountAfterTrial: 20,
      trialEndDate: DateTime.utc(2026, 8, 26),
    ),
  );
}

void main() {
  testWidgets('marking cancelled persists locally and updates the card', (
    tester,
  ) async {
    final harness = await pumpBillKillerApp(
      tester,
      location: AppRoutes.trialDetailLocation('chatgpt'),
      now: _now,
      seed: _saveChatGPT,
    );

    await tester.tap(find.text(AppStrings.markTrialCancelled));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.trialCancelled), findsOneWidget);
    expect(find.text(AppStrings.markTrialCancelled), findsNothing);

    final stored = await DriftTrialRepository(harness.$3).getById('chatgpt');
    expect(stored!.status, TrialStatus.cancelled);
  });

  testWidgets('delete removes the local trial after confirmation', (
    tester,
  ) async {
    final harness = await pumpBillKillerApp(
      tester,
      location: AppRoutes.trialDetailLocation('chatgpt'),
      now: _now,
      seed: _saveChatGPT,
    );

    await tester.tap(find.text(AppStrings.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.delete).last);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.emptyTrialsTitle), findsOneWidget);
    expect(await DriftTrialRepository(harness.$3).getAll(), isEmpty);
  });
}
