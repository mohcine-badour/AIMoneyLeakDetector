import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/trials/data/drift_trial_repository.dart';
import 'package:kichta/features/trials/domain/trial.dart';

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
  testWidgets('empty trials list shows an empty state', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.trials, now: _now);

    expect(find.text(AppStrings.trialsTitle), findsOneWidget);
    expect(find.text(AppStrings.emptyTrialsTitle), findsOneWidget);
    expect(find.text(AppStrings.emptyTrialsMessage), findsOneWidget);
    expect(find.text(AppStrings.addTrialTitle), findsOneWidget);
  });

  testWidgets('trial card shows remaining days and after-trial amount', (
    tester,
  ) async {
    await pumpKichtaApp(
      tester,
      location: AppRoutes.trials,
      now: _now,
      seed: _saveChatGPT,
    );

    expect(find.text('ChatGPT'), findsOneWidget);
    expect(find.text(AppStrings.freeTrialBadge), findsOneWidget);
    expect(find.text('5 days remaining'), findsOneWidget);
    expect(find.text(AppStrings.afterTrial), findsOneWidget);
    expect(find.text(r'$20.00/month'), findsOneWidget);
  });

  testWidgets('tapping a trial opens details', (tester) async {
    await pumpKichtaApp(
      tester,
      location: AppRoutes.trials,
      now: _now,
      seed: _saveChatGPT,
    );

    await tester.tap(find.text('ChatGPT'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.fieldTrialEndDate), findsOneWidget);
    expect(find.text('Aug 26, 2026'), findsOneWidget);
    expect(find.text(AppStrings.markTrialCancelled), findsOneWidget);
  });
}
