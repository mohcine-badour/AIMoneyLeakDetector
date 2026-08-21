import '../../../core/constants/app_strings.dart';
import 'subscription.dart';

class SubscriptionFormInput {
  const SubscriptionFormInput({
    required this.name,
    required this.merchant,
    required this.amount,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.category,
  });

  final String name;
  final String merchant;
  final String amount;
  final BillingCycle? billingCycle;
  final DateTime? nextBillingDate;
  final SubscriptionCategory? category;
}

class SubscriptionFormErrors {
  const SubscriptionFormErrors({
    this.name,
    this.amount,
    this.billingCycle,
    this.nextBillingDate,
    this.category,
  });

  final String? name;
  final String? amount;
  final String? billingCycle;
  final String? nextBillingDate;
  final String? category;

  bool get hasErrors =>
      name != null ||
      amount != null ||
      billingCycle != null ||
      nextBillingDate != null ||
      category != null;
}

class ValidatedSubscriptionDraft {
  const ValidatedSubscriptionDraft({
    required this.name,
    required this.merchant,
    required this.amount,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.category,
  });

  final String name;
  final String merchant;
  final double amount;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final SubscriptionCategory category;
}

/// Deterministic form rules. Keep this out of widgets.
abstract final class SubscriptionValidator {
  static SubscriptionFormErrors validate(SubscriptionFormInput input) {
    return SubscriptionFormErrors(
      name: _nameError(input.name),
      amount: _amountError(input.amount),
      billingCycle: input.billingCycle == null
          ? AppStrings.errorBillingCycleRequired
          : null,
      nextBillingDate: input.nextBillingDate == null
          ? AppStrings.errorDateRequired
          : null,
      category: input.category == null
          ? AppStrings.errorCategoryRequired
          : null,
    );
  }

  static ValidatedSubscriptionDraft? validateAndBuild(
    SubscriptionFormInput input,
  ) {
    final errors = validate(input);
    if (errors.hasErrors) {
      return null;
    }

    final name = input.name.trim();
    final merchant = input.merchant.trim().isEmpty
        ? name
        : input.merchant.trim();

    return ValidatedSubscriptionDraft(
      name: name,
      merchant: merchant,
      amount: _parseAmount(input.amount)!,
      billingCycle: input.billingCycle!,
      nextBillingDate: input.nextBillingDate!,
      category: input.category!,
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
