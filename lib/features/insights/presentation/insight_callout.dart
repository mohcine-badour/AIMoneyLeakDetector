import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/insight_item.dart';
import 'insight_callout_card.dart';

class InsightCallout extends StatelessWidget {
  const InsightCallout({required this.insights, super.key});

  final List<InsightItem> insights;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            children: [
              Text(
                AppStrings.forYou,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: tokens.textPrimary,
                ),
              ),
              const Spacer(),
              Icon(AppIcons.sparkles, size: 11, color: tokens.warningText),
              const SizedBox(width: 4),
              Text(
                AppStrings.suggestionCount(insights.length),
                style: TextStyle(fontSize: 10.5, color: tokens.warningText),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            children: [
              for (var i = 0; i < insights.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                InsightCalloutCard(insight: insights[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
