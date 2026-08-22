import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';

class PaywallHero extends StatelessWidget {
  const PaywallHero({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(6, 3, 9, 3),
            decoration: BoxDecoration(
              color: tokens.indigoBg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: tokens.borderIndigo, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppIcons.sparkles, size: 11, color: tokens.indigoText),
                const SizedBox(width: 5),
                Text(
                  AppStrings.paywallProBadge.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                    color: tokens.indigoText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            AppStrings.paywallHeadline,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.8,
              height: 30 / 26,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.paywallSubheadline,
            style: TextStyle(
              fontSize: 13,
              height: 20 / 13,
              letterSpacing: -0.05,
              color: tokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
