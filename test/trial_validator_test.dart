import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/features/trials/domain/trial_validator.dart';

void main() {
  test('rejects an empty name and invalid amount', () {
    final errors = TrialValidator.validate(
      const TrialFormInput(
        subscriptionName: '  ',
        amountAfterTrial: '0',
        trialEndDate: null,
      ),
    );

    expect(errors.subscriptionName, AppStrings.errorNameRequired);
    expect(errors.amountAfterTrial, AppStrings.errorAmountInvalid);
    expect(errors.trialEndDate, AppStrings.errorTrialEndRequired);
    expect(errors.hasErrors, isTrue);
  });

  test('builds a valid draft', () {
    final draft = TrialValidator.validateAndBuild(
      TrialFormInput(
        subscriptionName: ' ChatGPT ',
        amountAfterTrial: '20',
        trialEndDate: DateTime.utc(2026, 8, 26),
      ),
    );

    expect(draft, isNotNull);
    expect(draft!.subscriptionName, 'ChatGPT');
    expect(draft.amountAfterTrial, closeTo(20, 0.001));
    expect(draft.trialEndDate, DateTime.utc(2026, 8, 26));
  });
}
