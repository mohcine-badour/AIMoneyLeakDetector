import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money_format.dart';
import '../before_subscribe/domain/subscription_candidate.dart';
import 'data/drift_subscription_repository.dart';
import 'domain/subscription.dart';
import 'domain/subscription_validator.dart';
import 'subscriptions_providers.dart';

final addSubscriptionControllerProvider =
    NotifierProvider<AddSubscriptionController, AddSubscriptionFormState>(
      AddSubscriptionController.new,
      isAutoDispose: true,
    );

class AddSubscriptionFormState {
  const AddSubscriptionFormState({
    this.editingId,
    this.currency = MoneyFormat.defaultCurrencyCode,
    this.billingCycle,
    this.nextBillingDate,
    this.category,
    this.errors = const SubscriptionFormErrors(),
    this.isSaving = false,
  });

  final String? editingId;
  final String currency;
  final BillingCycle? billingCycle;
  final DateTime? nextBillingDate;
  final SubscriptionCategory? category;
  final SubscriptionFormErrors errors;
  final bool isSaving;

  bool get isEditing => editingId != null;

  AddSubscriptionFormState copyWith({
    String? editingId,
    String? currency,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    SubscriptionCategory? category,
    SubscriptionFormErrors? errors,
    bool? isSaving,
  }) {
    return AddSubscriptionFormState(
      editingId: editingId ?? this.editingId,
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

  void hydrate(Subscription subscription) {
    state = AddSubscriptionFormState(
      editingId: subscription.id,
      currency: subscription.currency,
      billingCycle: subscription.billingCycle,
      nextBillingDate: subscription.nextBillingDate,
      category: subscription.category,
    );
  }

  SubscriptionCandidate? review({
    required String name,
    required String merchant,
    required String amount,
  }) {
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
      return null;
    }
    state = state.copyWith(errors: const SubscriptionFormErrors());
    return SubscriptionCandidate(
      name: draft.name,
      merchant: draft.merchant,
      amount: draft.amount,
      currency: state.currency,
      billingCycle: draft.billingCycle,
      nextBillingDate: draft.nextBillingDate,
      category: draft.category,
      source: SubscriptionSource.manual,
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
    final repository = ref.read(subscriptionRepositoryProvider);
    final editingId = state.editingId;
    if (editingId != null) {
      final existing = await repository.getById(editingId);
      if (existing == null) {
        state = state.copyWith(isSaving: false);
        return false;
      }
      await repository.save(
        existing.copyWith(
          name: draft.name,
          merchant: draft.merchant,
          amount: draft.amount,
          currency: state.currency,
          billingCycle: draft.billingCycle,
          nextBillingDate: draft.nextBillingDate,
          category: draft.category,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      ref.invalidate(subscriptionByIdProvider(editingId));
    } else {
      await repository.save(
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
    }
    ref.invalidate(subscriptionsProvider);
    state = state.copyWith(isSaving: false);
    return true;
  }
}
