import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_icon.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../subscriptions/domain/subscription_brand.dart';
import '../domain/category_colors.dart';
import '../domain/top_by_cost.dart';

class TopByCostCard extends StatelessWidget {
  const TopByCostCard({required this.result, super.key});

  final TopByCost result;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    if (result.rows.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            children: [
              Text(
                AppStrings.topByCost,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: tokens.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                AppStrings.percentOfTotal(result.totalCoveredPercent.round()),
                style: TextStyle(fontSize: 11, color: tokens.textMuted),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: tokens.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: Column(
            children: [
              for (var i = 0; i < result.rows.length; i++)
                _TopRow(
                  row: result.rows[i],
                  isLast: i == result.rows.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({required this.row, required this.isLast});

  final TopByCostRow row;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final sub = row.subscription;
    final category = SubscriptionBrand.categoryFor(sub);
    final slug = SubscriptionBrand.slugFor(sub);

    return InkWell(
      key: Key('top-cost-${sub.id}'),
      onTap: () {
        HapticFeedback.selectionClick();
        context.push(AppRoutes.subscriptionDetailLocation(sub.id));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: tokens.border, width: 0.5)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                BrandIcon(
                  slug: slug,
                  size: 32,
                  fallbackInitial: sub.name,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sub.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        category.label,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: tokens.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      MoneyFormat.format(
                        row.monthlyAmount,
                        currencyCode: sub.currency,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: tokens.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${row.percentOfTotal.round()}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: tokens.textMuted,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SizedBox(
                height: 3,
                child: Stack(
                  children: [
                    ColoredBox(
                      color: tokens.bgHover,
                      child: const SizedBox.expand(),
                    ),
                    FractionallySizedBox(
                      widthFactor: (row.percentOfTotal / 100).clamp(0.0, 1.0),
                      child: ColoredBox(
                        color: CategoryColors.of(category),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
