import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_card.dart';
import '../domain/trial.dart';
import 'trial_labels.dart';

class TrialListCard extends StatelessWidget {
  const TrialListCard({
    required this.trial,
    required this.now,
    this.onTap,
    super.key,
  });

  final Trial trial;
  final DateTime now;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final remaining = TrialLabels.remaining(trial: trial, now: now);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(trial.subscriptionName, style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.freeTrialBadge, style: textTheme.labelMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            remaining,
            key: Key('trial-remaining-${trial.id}'),
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
    );
  }
}
