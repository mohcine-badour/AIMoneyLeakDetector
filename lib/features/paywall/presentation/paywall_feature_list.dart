import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../domain/paywall_features.dart';

class PaywallFeatureList extends StatelessWidget {
  const PaywallFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final features = PaywallFeatures.all;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.bgSubtle,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: tokens.border, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Column(
            children: [
              for (var i = 0; i < features.length; i++)
                PaywallFeatureRow(
                  feature: features[i],
                  isLast: i == features.length - 1,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaywallFeatureRow extends StatelessWidget {
  const PaywallFeatureRow({
    required this.feature,
    required this.isLast,
    super.key,
  });

  final PaywallFeature feature;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final tone = feature.color == PaywallFeatureColor.gray
        ? PaywallFeatureTone(bg: tokens.bgHover, fg: tokens.textSecondary)
        : PaywallFeatureColors.of(feature.color);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: tokens.border, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: tone.bg,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(feature.icon, size: 13, color: tone.fg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.15,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  feature.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 15 / 11.5,
                    letterSpacing: -0.05,
                    color: tokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
