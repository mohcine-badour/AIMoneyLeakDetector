import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import 'data/onboarding_repository.dart';
import 'domain/onboarding_answers.dart';

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingDraft>(
      OnboardingController.new,
    );

class OnboardingController extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  void goToSpendingStep() {
    state = state.copyWith(step: 1);
  }

  void selectSpendingRange(SpendingRange range) {
    state = state.copyWith(spendingRange: range);
  }

  void goToSavingsStep() {
    if (!state.canContinueSpending) {
      return;
    }
    state = state.copyWith(step: 2);
  }

  void selectSavingsGoal(SavingsGoal goal) {
    state = state.copyWith(savingsGoal: goal);
  }

  void goToEntryPathStep() {
    if (!state.canContinueSavings) {
      return;
    }
    state = state.copyWith(step: 3);
  }

  void goBack() {
    if (state.step == 0) {
      return;
    }
    state = state.copyWith(step: state.step - 1);
  }

  Future<void> complete(OnboardingEntryPath entryPath) async {
    final spending = state.spendingRange;
    final savings = state.savingsGoal;
    if (spending == null || savings == null) {
      return;
    }

    await ref
        .read(onboardingRepositoryProvider)
        .save(
          OnboardingAnswers(
            spendingRange: spending,
            savingsGoal: savings,
            entryPath: entryPath,
            completedAt: DateTime.now().toUtc(),
          ),
        );
    await ref
        .read(analyticsProvider)
        .track(
          AnalyticsEvent.onboardingCompleted,
          properties: {'source': _entrySource(entryPath)},
        );
  }
}

String _entrySource(OnboardingEntryPath entryPath) {
  return switch (entryPath) {
    OnboardingEntryPath.addManually => 'manual',
    OnboardingEntryPath.scanReceipt => 'scan',
    OnboardingEntryPath.importLater => 'later',
  };
}
