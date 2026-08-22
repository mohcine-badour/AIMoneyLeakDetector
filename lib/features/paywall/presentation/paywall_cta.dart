import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/paywall_offerings.dart';
import '../domain/paywall_plan.dart';

class PaywallCta extends StatelessWidget {
  const PaywallCta({
    required this.plan,
    required this.offerings,
    required this.purchasing,
    required this.onPressed,
    super.key,
  });

  final PaywallPlan plan;
  final PaywallOfferings offerings;
  final bool purchasing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final yearly = plan == PaywallPlan.yearly;
    final label = yearly && offerings.hasYearlyTrial
        ? AppStrings.startFreeTrial(offerings.yearlyIntroTrialDays!)
        : AppStrings.continueWithPrice(
            switch (plan) {
              PaywallPlan.weekly => offerings.weeklyPriceString,
              PaywallPlan.monthly => offerings.monthlyPriceString,
              PaywallPlan.yearly => offerings.yearlyPriceString,
            },
            switch (plan) {
              PaywallPlan.weekly => AppStrings.compactPerWeek,
              PaywallPlan.monthly => AppStrings.compactPerMonth,
              PaywallPlan.yearly => AppStrings.compactPerYear,
            },
          );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          key: const Key('unlock-pro'),
          onPressed: purchasing ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: tokens.accent,
            foregroundColor: tokens.accentText,
            disabledBackgroundColor: tokens.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: purchasing
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: tokens.accentText,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                    color: tokens.accentText,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
        ),
      ),
    );
  }
}
