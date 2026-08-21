import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../domain/trial.dart';
import '../domain/trial_countdown.dart';
import '../trial_detail_controller.dart';
import '../trials_providers.dart';
import 'trial_labels.dart';

class TrialDetailScreen extends ConsumerWidget {
  const TrialDetailScreen({required this.trialId, super.key});

  final String trialId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(trialByIdProvider(trialId));

    return async.when(
      loading: () => const AppScaffold(
        title: AppStrings.trialsTitle,
        body: LoadingState(),
      ),
      error: (error, stackTrace) => AppScaffold(
        title: AppStrings.trialsTitle,
        body: ErrorState(
          message: AppStrings.errorLoadTrials,
          onRetry: () => ref.invalidate(trialByIdProvider(trialId)),
        ),
      ),
      data: (trial) {
        if (trial == null) {
          return AppScaffold(
            title: AppStrings.trialsTitle,
            body: ErrorState(
              message: AppStrings.trialNotFound,
              retryLabel: AppStrings.backToList,
              onRetry: () => context.go(AppRoutes.trials),
            ),
          );
        }
        return _TrialDetailBody(trial: trial);
      },
    );
  }
}

class _TrialDetailBody extends ConsumerWidget {
  const _TrialDetailBody({required this.trial});

  final Trial trial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(appNowProvider);
    final textTheme = Theme.of(context).textTheme;
    final status = TrialCountdown.displayStatus(
      stored: trial.status,
      trialEndDate: trial.trialEndDate,
      now: now,
    );

    return AppScaffold(
      title: trial.subscriptionName,
      padding: const EdgeInsets.all(AppSpacing.page),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.freeTrialBadge, style: textTheme.labelMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    TrialLabels.remaining(trial: trial, now: now),
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(AppStrings.afterTrial, style: textTheme.labelMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    TrialLabels.afterTrialAmount(trial),
                    style: textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _DetailRow(
              label: AppStrings.fieldTrialEndDate,
              value: AppDateFormat.short(trial.trialEndDate),
            ),
            if (status != TrialStatus.cancelled) ...[
              AppButton(
                label: AppStrings.markTrialCancelled,
                variant: AppButtonVariant.secondary,
                onPressed: () => ref
                    .read(trialDetailControllerProvider)
                    .markCancelled(trial),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            AppButton(
              label: AppStrings.delete,
              variant: AppButtonVariant.danger,
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.deleteTrialTitle),
          content: const Text(AppStrings.deleteTrialMessage),
          actions: [
            AppButton(
              label: AppStrings.cancel,
              variant: AppButtonVariant.tertiary,
              expand: false,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            AppButton(
              label: AppStrings.delete,
              variant: AppButtonVariant.danger,
              expand: false,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await ref.read(trialDetailControllerProvider).delete(trial.id);
    if (context.mounted) {
      context.go(AppRoutes.trials);
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
