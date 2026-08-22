import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money_format.dart';
import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import 'data/drift_trial_repository.dart';
import 'domain/trial.dart';
import 'domain/trial_validator.dart';
import 'trials_providers.dart';

final addTrialControllerProvider =
    NotifierProvider<AddTrialController, AddTrialFormState>(
      AddTrialController.new,
      isAutoDispose: true,
    );

class AddTrialFormState {
  const AddTrialFormState({
    this.currency = MoneyFormat.defaultCurrencyCode,
    this.trialEndDate,
    this.errors = const TrialFormErrors(),
    this.isSaving = false,
  });

  final String currency;
  final DateTime? trialEndDate;
  final TrialFormErrors errors;
  final bool isSaving;

  AddTrialFormState copyWith({
    String? currency,
    DateTime? trialEndDate,
    TrialFormErrors? errors,
    bool? isSaving,
  }) {
    return AddTrialFormState(
      currency: currency ?? this.currency,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      errors: errors ?? this.errors,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class AddTrialController extends Notifier<AddTrialFormState> {
  @override
  AddTrialFormState build() => const AddTrialFormState();

  void setCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  void setTrialEndDate(DateTime date) {
    state = state.copyWith(
      trialEndDate: DateTime.utc(date.year, date.month, date.day),
      errors: TrialFormErrors(
        subscriptionName: state.errors.subscriptionName,
        amountAfterTrial: state.errors.amountAfterTrial,
      ),
    );
  }

  Future<bool> submit({
    required String subscriptionName,
    required String amountAfterTrial,
  }) async {
    final input = TrialFormInput(
      subscriptionName: subscriptionName,
      amountAfterTrial: amountAfterTrial,
      trialEndDate: state.trialEndDate,
    );
    final draft = TrialValidator.validateAndBuild(input);
    if (draft == null) {
      state = state.copyWith(errors: TrialValidator.validate(input));
      return false;
    }

    state = state.copyWith(isSaving: true, errors: const TrialFormErrors());
    await ref
        .read(trialRepositoryProvider)
        .save(
          Trial.create(
            subscriptionName: draft.subscriptionName,
            amountAfterTrial: draft.amountAfterTrial,
            currency: state.currency,
            trialEndDate: draft.trialEndDate,
          ),
        );
    ref.invalidate(trialsProvider);
    await ref.read(analyticsProvider).track(AnalyticsEvent.trialCreated);
    state = state.copyWith(isSaving: false);
    return true;
  }
}
