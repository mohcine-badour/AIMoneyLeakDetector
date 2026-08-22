import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_scaffold.dart';
import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import '../paywall/paywall_navigation.dart';
import 'domain/onboarding_answers.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(analyticsScreenViewProvider(AnalyticsEvent.onboardingStarted));
    final draft = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return PopScope(
      canPop: draft.step == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          controller.goBack();
        }
      },
      child: AppScaffold(
        showAppBar: true,
        leading: BackButton(
          onPressed: () {
            if (draft.step == 0) {
              context.pop();
            } else {
              controller.goBack();
            }
          },
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.page,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StepIndicator(step: draft.step),
            const SizedBox(height: AppSpacing.xl),
            Expanded(child: _stepBody(context, ref, draft, controller)),
          ],
        ),
      ),
    );
  }

  Widget _stepBody(
    BuildContext context,
    WidgetRef ref,
    OnboardingDraft draft,
    OnboardingController controller,
  ) {
    return switch (draft.step) {
      0 => _IntroStep(onContinue: controller.goToSpendingStep),
      1 => _ChoiceStep(
        title: AppStrings.onboardingSpendingTitle,
        options: [
          for (final range in SpendingRange.values)
            _Option(
              label: range.label,
              selected: draft.spendingRange == range,
              onTap: () => controller.selectSpendingRange(range),
            ),
        ],
        onContinue: draft.canContinueSpending
            ? controller.goToSavingsStep
            : null,
      ),
      2 => _ChoiceStep(
        title: AppStrings.onboardingSavingsTitle,
        options: [
          for (final goal in SavingsGoal.values)
            _Option(
              label: goal.label,
              selected: draft.savingsGoal == goal,
              onTap: () => controller.selectSavingsGoal(goal),
            ),
        ],
        onContinue: draft.canContinueSavings
            ? controller.goToEntryPathStep
            : null,
      ),
      _ => _EntryPathStep(
        onSelected: (path) => _complete(context, ref, controller, path),
      ),
    };
  }

  Future<void> _complete(
    BuildContext context,
    WidgetRef ref,
    OnboardingController controller,
    OnboardingEntryPath path,
  ) async {
    await controller.complete(path);
    if (!context.mounted) {
      return;
    }

    switch (path) {
      case OnboardingEntryPath.addManually:
        PaywallNavigation.addSubscription(context, ref, replace: true);
      case OnboardingEntryPath.scanReceipt:
        PaywallNavigation.scanReceipt(context, ref, replace: true);
      case OnboardingEntryPath.importLater:
        context.go(AppRoutes.dashboard);
    }
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        Text(
          AppStrings.onboardingHeadline,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Spacer(flex: 3),
        AppButton(label: AppStrings.onboardingFindOut, onPressed: onContinue),
      ],
    );
  }
}

class _ChoiceStep extends StatelessWidget {
  const _ChoiceStep({
    required this.title,
    required this.options,
    required this.onContinue,
  });

  final String title;
  final List<_Option> options;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xl),
        Expanded(
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final option = options[index];
              return AppCard(
                selected: option.selected,
                onTap: option.onTap,
                child: Text(
                  option.label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              );
            },
          ),
        ),
        AppButton(label: AppStrings.continueLabel, onPressed: onContinue),
      ],
    );
  }
}

class _EntryPathStep extends StatelessWidget {
  const _EntryPathStep({required this.onSelected});

  final ValueChanged<OnboardingEntryPath> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.onboardingEntryTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.xl),
        Expanded(
          child: ListView(
            children: [
              AppCard(
                onTap: () => onSelected(OnboardingEntryPath.addManually),
                child: Text(
                  AppStrings.entryAddManually,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                onTap: () => onSelected(OnboardingEntryPath.scanReceipt),
                child: Text(
                  AppStrings.entryScanReceipt,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                onTap: () => onSelected(OnboardingEntryPath.importLater),
                child: Text(
                  AppStrings.entryImportLater,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        for (var index = 0; index < 4; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: index <= step
                    ? colorScheme.primary
                    : colorScheme.outline,
                borderRadius: AppRadius.button,
              ),
              child: const SizedBox(height: AppSpacing.xs),
            ),
          ),
        ],
      ],
    );
  }
}

class _Option {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
}

extension on SpendingRange {
  String get label => switch (this) {
    SpendingRange.under25 => AppStrings.spendingUnder25,
    SpendingRange.from25to50 => AppStrings.spending25to50,
    SpendingRange.from50to100 => AppStrings.spending50to100,
    SpendingRange.from100to200 => AppStrings.spending100to200,
    SpendingRange.over200 => AppStrings.spendingOver200,
  };
}

extension on SavingsGoal {
  String get label => switch (this) {
    SavingsGoal.amount25 => AppStrings.savings25,
    SavingsGoal.amount50 => AppStrings.savings50,
    SavingsGoal.amount100 => AppStrings.savings100,
    SavingsGoal.amount200 => AppStrings.savings200,
  };
}
