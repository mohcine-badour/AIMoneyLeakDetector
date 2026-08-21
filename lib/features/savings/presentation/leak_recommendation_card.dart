import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
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

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(recommendation.title, style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(recommendation.reason, style: textTheme.bodyLarge),
          if (explanation != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(explanation!, style: textTheme.bodyLarge),
          ],
        ],
      ),
    );
  }
}
