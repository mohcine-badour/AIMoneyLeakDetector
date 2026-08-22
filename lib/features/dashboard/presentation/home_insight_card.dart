import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../subscriptions/presentation/subscription_labels.dart';
import '../domain/home_insight.dart';

class HomeInsightCard extends StatefulWidget {
  const HomeInsightCard({required this.insight, super.key});

  final HomeInsight insight;

  @override
  State<HomeInsightCard> createState() => _HomeInsightCardState();
}

class _HomeInsightCardState extends State<HomeInsightCard> {
  var _opening = false;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final copy = _copy(widget.insight);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Material(
        color: tokens.warningBg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _open(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: tokens.bgCard,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 14,
                    color: tokens.warningText,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        copy.title,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.1,
                          color: tokens.warningText,
                        ),
                      ),
                      Text(
                        copy.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: tokens.warningText.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: tokens.warningText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ({String title, String subtitle}) _copy(HomeInsight insight) {
    return switch (insight) {
      UnusedInsight(
        :final subscription,
        :final daysUnused,
        :final monthlySavings,
      ) =>
        (
          title: AppStrings.unusedInsightTitle(subscription.name, daysUnused),
          subtitle: AppStrings.unusedInsightSubtitle(
            MoneyFormat.format(
              monthlySavings,
              currencyCode: subscription.currency,
            ),
          ),
        ),
      PriceHikeInsight(:final subscription, :final delta) => (
        title: AppStrings.priceHikeTitle(
          subscription.name,
          MoneyFormat.format(delta, currencyCode: subscription.currency),
        ),
        subtitle: AppStrings.priceHikeSubtitle,
      ),
      OverlapInsight(
        :final category,
        :final subscriptions,
        :final potentialSavings,
      ) =>
        (
          title: AppStrings.overlapTitle(subscriptions.length, category.label),
          subtitle: AppStrings.overlapSubtitle(
            MoneyFormat.format(
              potentialSavings,
              currencyCode: subscriptions.first.currency,
            ),
          ),
        ),
    };
  }

  void _open(BuildContext context) {
    if (_opening) {
      return;
    }
    _opening = true;
    final insight = widget.insight;
    final location = switch (insight) {
      UnusedInsight(:final subscription) =>
        AppRoutes.subscriptionDetailLocation(subscription.id),
      PriceHikeInsight(:final subscription) =>
        AppRoutes.subscriptionDetailLocation(subscription.id),
      OverlapInsight(:final subscriptions) =>
        AppRoutes.subscriptionDetailLocation(subscriptions.first.id),
    };
    context.push(location);
  }
}
