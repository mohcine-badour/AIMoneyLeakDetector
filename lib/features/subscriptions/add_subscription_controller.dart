import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money_format.dart';
import 'data/drift_subscription_repository.dart';
import 'domain/subscription.dart';
import 'domain/subscription_validator.dart';

final addSubscriptionControllerProvider =
    NotifierProvider<AddSubscriptionController, AddSubscriptionFormState>(
      AddSubscriptionController.new,
      isAutoDispose: true,
    );

class AddSubscriptionFormState {
  const AddSubscriptionFormState({
    this.currency = MoneyFormat.defaultCurrencyCode,
    this.billingCycle,
    this.nextBillingDate,
    this.category,
    this.errors = const SubscriptionFormErrors(),
    this.isSaving = false,
  });

  final String currency;
  final BillingCycle? billingCycle;
  final DateTime? nextBillingDate;
  final SubscriptionCategory? category;
  final SubscriptionFormErrors errors;
  final bool isSaving;

  AddSubscriptionFormState copyWith({
    String? currency,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    SubscriptionCategory? category,
    SubscriptionFormErrors? errors,
    bool? isSaving,
  }) {
    return AddSubscriptionFormState(
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      category: category ?? this.category,
      errors: errors ?? this.errors,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class AddSubscriptionController extends Notifier<AddSubscriptionFormState> {
  @override
  AddSubscriptionFormState build() => const AddSubscriptionFormState();

  void setCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  void setBillingCycle(BillingCycle cycle) {
    state = state.copyWith(
      billingCycle: cycle,
      errors: SubscriptionFormErrors(
        name: state.errors.name,
        amount: state.errors.amount,
        nextBillingDate: state.errors.nextBillingDate,
        category: state.errors.category,
      ),
    );
  }

  void setNextBillingDate(DateTime date) {
    state = state.copyWith(
      nextBillingDate: DateTime.utc(date.year, date.month, date.day),
      errors: SubscriptionFormErrors(
        name: state.errors.name,
        amount: state.errors.amount,
        billingCycle: state.errors.billingCycle,
        category: state.errors.category,
      ),
    );
  }

  void setCategory(SubscriptionCategory category) {
    state = state.copyWith(
      category: category,
      errors: SubscriptionFormErrors(
        name: state.errors.name,
        amount: state.errors.amount,
        billingCycle: state.errors.billingCycle,
        nextBillingDate: state.errors.nextBillingDate,
      ),
    );
  }

  Future<bool> submit({
    required String name,
    required String merchant,
    required String amount,
  }) async {
    final input = SubscriptionFormInput(
      name: name,
      merchant: merchant,
      amount: amount,
      billingCycle: state.billingCycle,
      nextBillingDate: state.nextBillingDate,
      category: state.category,
    );
    final draft = SubscriptionValidator.validateAndBuild(input);
    if (draft == null) {
      state = state.copyWith(errors: SubscriptionValidator.validate(input));
      return false;
    }

    state = state.copyWith(isSaving: true, errors: const SubscriptionFormErrors());
    await ref.read(subscriptionRepositoryProvider).save(
          Subscription.create(
            name: draft.name,
            merchant: draft.merchant,
            amount: draft.amount,
            currency: state.currency,
            billingCycle: draft.billingCycle,
            nextBillingDate: draft.nextBillingDate,
            category: draft.category,
            source: SubscriptionSource.manual,
          ),
        );
    state = state.copyWith(isSaving: false);
    return true;
  }
}
