import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/features/onboarding/data/onboarding_repository.dart';
import 'package:billkiller_ai/features/onboarding/domain/onboarding_answers.dart';

import 'helpers/pump_app.dart';

void main() {
  test('OnboardingRepository persists answers locally', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repository = OnboardingRepository(prefs);

    expect(repository.isCompleted, isFalse);
    expect(repository.read(), isNull);

    await repository.save(
      OnboardingAnswers(
        spendingRange: SpendingRange.from50to100,
        savingsGoal: SavingsGoal.amount50,
        entryPath: OnboardingEntryPath.addManually,
        completedAt: DateTime.utc(2026, 8, 21),
      ),
    );

    expect(repository.isCompleted, isTrue);
    final stored = repository.read();
    expect(stored, isNotNull);
    expect(stored!.spendingRange, SpendingRange.from50to100);
    expect(stored.savingsGoal, SavingsGoal.amount50);
    expect(stored.entryPath, OnboardingEntryPath.addManually);
  });

  testWidgets('manual onboarding flow reaches add subscription', (tester) async {
    final harness = await pumpBillKillerApp(tester);
    final prefs = harness.$2;

    await tester.tap(find.text(AppStrings.getStarted));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.onboardingFindOut));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.spendingUnder25));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.continueLabel));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.savings50));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.continueLabel));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.entryAddManually));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.addSubscriptionTitle), findsOneWidget);
    expect(OnboardingRepository(prefs).isCompleted, isTrue);
    expect(
      OnboardingRepository(prefs).read()?.entryPath,
      OnboardingEntryPath.addManually,
    );
  });

  testWidgets('import later completes onboarding and opens dashboard', (
    tester,
  ) async {
    await pumpBillKillerApp(tester, location: AppRoutes.onboarding);

    await tester.tap(find.text(AppStrings.onboardingFindOut));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.spendingOver200));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.continueLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.savings200));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.continueLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.entryImportLater));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.yourSubscriptions), findsOneWidget);
  });

  testWidgets('scan a receipt completes onboarding and opens the scanner', (
    tester,
  ) async {
    await pumpBillKillerApp(tester, location: AppRoutes.onboarding);

    await tester.tap(find.text(AppStrings.onboardingFindOut));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.spendingOver200));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.continueLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.savings200));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.continueLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.entryScanReceipt));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.scanReceiptTitle), findsOneWidget);
    expect(find.text(AppStrings.scanUseCamera), findsOneWidget);
  });
}
