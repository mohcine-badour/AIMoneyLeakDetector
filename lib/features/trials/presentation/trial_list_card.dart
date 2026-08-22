import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/merchant_mark.dart';
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

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MerchantMark(name: trial.subscriptionName),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trial.subscriptionName, style: textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(AppStrings.freeTrialBadge, style: textTheme.labelMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    remaining,
                    key: Key('trial-remaining-${trial.id}'),
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(AppStrings.afterTrial, style: textTheme.bodySmall),
                  Text(
                    TrialLabels.afterTrialAmount(trial),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
