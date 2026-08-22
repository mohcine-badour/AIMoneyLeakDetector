import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../domain/paywall_offerings.dart';
import '../domain/paywall_plan.dart';

class PaywallPricingCard extends StatelessWidget {
  const PaywallPricingCard({
    required this.plan,
    required this.offerings,
    required this.selected,
    required this.onPress,
    super.key,
  });

  final PaywallPlan plan;
  final PaywallOfferings offerings;
  final bool selected;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final yearly = plan == PaywallPlan.yearly;
    final savings = offerings.savings;
    final showBadge = yearly && savings.showBadge;
    final indigo = tokens.filterDot;

    return Padding(
      padding: EdgeInsets.only(top: showBadge ? 8 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: selected ? tokens.indigoBg : tokens.bgSubtle,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: selected ? indigo : tokens.borderStrong,
                width: selected ? 1.5 : 0.5,
              ),
            ),
            child: InkWell(
              key: Key(switch (plan) {
                PaywallPlan.yearly => 'paywall-plan-yearly',
                PaywallPlan.monthly => 'paywall-plan-monthly',
                PaywallPlan.weekly => 'paywall-plan-weekly',
              }),
              onTap: () {
                HapticFeedback.selectionClick();
                onPress();
              },
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: switch (plan) {
                        PaywallPlan.yearly => _YearlyCopy(
                          offerings: offerings,
                        ),
                        PaywallPlan.monthly => _MonthlyCopy(
                          offerings: offerings,
                        ),
                        PaywallPlan.weekly => _WeeklyCopy(
                          offerings: offerings,
                        ),
                      },
                    ),
                    const SizedBox(width: 12),
                    _Radio(selected: selected),
                  ],
                ),
              ),
            ),
          ),
          if (showBadge)
            Positioned(
              top: -8,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  AppStrings.savePercent(savings.savedPercent).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                    color: Color(0xFF0B3D0B),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _YearlyCopy extends StatelessWidget {
  const _YearlyCopy({required this.offerings});

  final PaywallOfferings offerings;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final equivalent = MoneyFormat.format(
      offerings.savings.monthlyEquivalent,
      currencyCode: offerings.currencyCode,
    );
    final micro = offerings.hasYearlyTrial
        ? AppStrings.trialThenYearly(
            offerings.yearlyIntroTrialDays!,
            offerings.yearlyPriceString,
          )
        : AppStrings.justPerMonth(equivalent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.yearlyPlan,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
            color: tokens.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              offerings.yearlyPriceString,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
                color: tokens.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 5),
            Text(
              AppStrings.compactPerYear,
              style: TextStyle(fontSize: 11.5, color: tokens.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          micro,
          style: TextStyle(
            fontSize: 11,
            color: tokens.textMuted,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _WeeklyCopy extends StatelessWidget {
  const _WeeklyCopy({required this.offerings});

  final PaywallOfferings offerings;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.weeklyPlan,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: tokens.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              offerings.weeklyPriceString,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
                color: tokens.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 5),
            Text(
              AppStrings.compactPerWeek,
              style: TextStyle(fontSize: 11.5, color: tokens.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _MonthlyCopy extends StatelessWidget {
  const _MonthlyCopy({required this.offerings});

  final PaywallOfferings offerings;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.monthlyPlan,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: tokens.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              offerings.monthlyPriceString,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
                color: tokens.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 5),
            Text(
              AppStrings.compactPerMonth,
              style: TextStyle(fontSize: 11.5, color: tokens.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    if (selected) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: tokens.textPrimary,
          shape: BoxShape.circle,
        ),
        child: Icon(AppIcons.check, size: 13, color: tokens.bgApp),
      );
    }
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: tokens.textMuted, width: 1.3),
      ),
    );
  }
}
