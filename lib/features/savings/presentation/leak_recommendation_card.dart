import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/merchant_mark.dart';
import '../domain/leak_recommendation.dart';

class LeakRecommendationCard extends StatelessWidget {
  const LeakRecommendationCard({
    required this.recommendation,
    this.explanation,
    this.onTap,
    super.key,
  });

  final LeakRecommendation recommendation;
  final String? explanation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MerchantMark(name: recommendation.title),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recommendation.title, style: textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(recommendation.reason, style: textTheme.bodySmall),
                  if (explanation != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(explanation!, style: textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
