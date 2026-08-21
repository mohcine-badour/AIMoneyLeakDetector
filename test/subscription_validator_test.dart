import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription_validator.dart';

void main() {
  final valid = SubscriptionFormInput(
    name: 'Netflix',
    merchant: '',
    amount: '22.99',
    billingCycle: BillingCycle.monthly,
    nextBillingDate: DateTime.utc(2026, 9, 21),
    category: SubscriptionCategory.entertainment,
  );

  test('rejects an empty name', () {
    final errors = SubscriptionValidator.validate(
      SubscriptionFormInput(
        name: '  ',
        merchant: 'Netflix',
        amount: '22.99',
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.utc(2026, 9, 21),
        category: SubscriptionCategory.entertainment,
      ),
    );

    expect(errors.name, AppStrings.errorNameRequired);
    expect(SubscriptionValidator.validateAndBuild(
      SubscriptionFormInput(
        name: '  ',
        merchant: 'Netflix',
        amount: '22.99',
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.utc(2026, 9, 21),
        category: SubscriptionCategory.entertainment,
      ),
    ), isNull);
  });

  test('rejects zero or negative amounts', () {
    expect(
      SubscriptionValidator.validate(
        SubscriptionFormInput(
          name: 'Netflix',
          merchant: 'Netflix',
          amount: '0',
          billingCycle: BillingCycle.monthly,
          nextBillingDate: DateTime.utc(2026, 9, 21),
          category: SubscriptionCategory.entertainment,
        ),
      ).amount,
      AppStrings.errorAmountInvalid,
    );
    expect(
      SubscriptionValidator.validate(
        SubscriptionFormInput(
          name: 'Netflix',
          merchant: 'Netflix',
          amount: '-5',
          billingCycle: BillingCycle.monthly,
          nextBillingDate: DateTime.utc(2026, 9, 21),
          category: SubscriptionCategory.entertainment,
        ),
      ).amount,
      AppStrings.errorAmountInvalid,
    );
  });

  test('requires billing cycle, date, and category', () {
    final errors = SubscriptionValidator.validate(
      const SubscriptionFormInput(
        name: 'Netflix',
        merchant: 'Netflix',
        amount: '22.99',
        billingCycle: null,
        nextBillingDate: null,
        category: null,
      ),
    );

    expect(errors.billingCycle, AppStrings.errorBillingCycleRequired);
    expect(errors.nextBillingDate, AppStrings.errorDateRequired);
    expect(errors.category, AppStrings.errorCategoryRequired);
  });

  test('defaults merchant to name when merchant is empty', () {
    final draft = SubscriptionValidator.validateAndBuild(valid);

    expect(draft, isNotNull);
    expect(draft!.name, 'Netflix');
    expect(draft.merchant, 'Netflix');
    expect(draft.amount, closeTo(22.99, 0.001));
  });
}
