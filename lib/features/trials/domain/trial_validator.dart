import '../../../core/constants/app_strings.dart';

class TrialFormInput {
  const TrialFormInput({
    required this.subscriptionName,
    required this.amountAfterTrial,
    required this.trialEndDate,
  });

  final String subscriptionName;
  final String amountAfterTrial;
  final DateTime? trialEndDate;
}

class TrialFormErrors {
  const TrialFormErrors({
    this.subscriptionName,
    this.amountAfterTrial,
    this.trialEndDate,
  });

  final String? subscriptionName;
  final String? amountAfterTrial;
  final String? trialEndDate;

  bool get hasErrors =>
      subscriptionName != null ||
      amountAfterTrial != null ||
      trialEndDate != null;
}

class ValidatedTrialDraft {
  const ValidatedTrialDraft({
    required this.subscriptionName,
    required this.amountAfterTrial,
    required this.trialEndDate,
  });

  final String subscriptionName;
  final double amountAfterTrial;
  final DateTime trialEndDate;
}

/// Deterministic trial form rules. Keep this out of widgets.
abstract final class TrialValidator {
  static TrialFormErrors validate(TrialFormInput input) {
    return TrialFormErrors(
      subscriptionName: _nameError(input.subscriptionName),
      amountAfterTrial: _amountError(input.amountAfterTrial),
      trialEndDate: input.trialEndDate == null
          ? AppStrings.errorTrialEndRequired
          : null,
    );
  }

  static ValidatedTrialDraft? validateAndBuild(TrialFormInput input) {
    final errors = validate(input);
    if (errors.hasErrors) {
      return null;
    }
    return ValidatedTrialDraft(
      subscriptionName: input.subscriptionName.trim(),
      amountAfterTrial: _parseAmount(input.amountAfterTrial)!,
      trialEndDate: input.trialEndDate!,
    );
  }

  static String? _nameError(String name) {
    if (name.trim().isEmpty) {
      return AppStrings.errorNameRequired;
    }
    return null;
  }

  static String? _amountError(String amount) {
    final parsed = _parseAmount(amount);
    if (parsed == null || parsed <= 0) {
      return AppStrings.errorAmountInvalid;
    }
    return null;
  }

  static double? _parseAmount(String amount) {
    return double.tryParse(amount.trim().replaceAll(',', '.'));
  }
}
