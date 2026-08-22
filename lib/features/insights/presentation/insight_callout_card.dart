import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_icon.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../subscriptions/domain/subscription_brand.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../domain/insight_copy.dart';
import '../domain/insight_item.dart';
import '../insights_providers.dart';

class InsightCalloutCard extends ConsumerStatefulWidget {
  const InsightCalloutCard({required this.insight, super.key});

  final InsightItem insight;

  @override
  ConsumerState<InsightCalloutCard> createState() => _InsightCalloutCardState();
}

class _KindColors {
  const _KindColors({
    required this.bg,
    required this.border,
    required this.text,
  });

  final Color bg;
  final Color border;
  final Color text;

  static _KindColors of(AppTokens tokens, InsightKind kind) {
    return switch (kind) {
      InsightKind.unused ||
      InsightKind.yearlyRenewal ||
      InsightKind.wrongCycle => _KindColors(
        bg: tokens.warningBg,
        border: tokens.borderWarning,
        text: tokens.warningText,
      ),
      InsightKind.priceHike => _KindColors(
        bg: tokens.dangerBg,
        border: tokens.borderDanger,
        text: tokens.dangerText,
      ),
      InsightKind.overlap => _KindColors(
        bg: tokens.indigoBg,
        border: tokens.borderIndigo,
        text: tokens.indigoText,
      ),
    };
  }
}

class _InsightCalloutCardState extends ConsumerState<InsightCalloutCard> {
  var _hiding = false;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final insight = widget.insight;
    final colors = _KindColors.of(tokens, insight.kind);
    final copy = _copy(insight);
    final slug = SubscriptionBrand.slugFor(insight.featured);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: _hiding ? 0 : 1,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: colors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BrandIcon(
              slug: slug,
              size: 28,
              fallbackInitial: insight.featured.name,
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
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    copy.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: colors.text.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _ActionButton(
                        key: Key('insight-review-${insight.id}'),
                        label: AppStrings.review,
                        filled: true,
                        color: colors.text,
                        onTap: () => _review(context, insight),
                      ),
                      const SizedBox(width: 6),
                      _ActionButton(
                        key: Key('insight-dismiss-${insight.id}'),
                        label: AppStrings.dismiss,
                        filled: false,
                        color: colors.text.withValues(alpha: 0.7),
                        onTap: () => _dismiss(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ({String title, String subtitle}) _copy(InsightItem insight) {
    final currency = insight.featured.currency;
    return switch (insight.kind) {
      InsightKind.unused => (
        title: InsightCopy.unusedTitle(
          insight.featured.name,
          insight.daysUnused ?? 0,
        ),
        subtitle: InsightCopy.unusedSubtitle(
          MoneyFormat.format(
            (insight.monthlySavings ?? 0) * 12,
            currencyCode: currency,
          ),
        ),
      ),
      InsightKind.priceHike => (
        title: InsightCopy.priceHikeTitle(
          insight.featured.name,
          MoneyFormat.short(insight.delta ?? 0, currencyCode: currency),
        ),
        subtitle: InsightCopy.priceHikeSubtitle,
      ),
      InsightKind.overlap => (
        title: InsightCopy.overlapTitle(
          insight.subscriptions.length,
          insight.category?.label ?? '',
        ),
        subtitle: InsightCopy.overlapSubtitle(
          MoneyFormat.format(
            insight.potentialSavings ?? 0,
            currencyCode: currency,
          ),
        ),
      ),
      InsightKind.yearlyRenewal => (
        title: InsightCopy.yearlyRenewalTitle(
          insight.featured.name,
          insight.daysUntil ?? 0,
          MoneyFormat.format(
            insight.renewalAmount ?? 0,
            currencyCode: currency,
          ),
        ),
        subtitle: InsightCopy.yearlyRenewalSubtitle,
      ),
      InsightKind.wrongCycle => (
        title: InsightCopy.wrongCycleTitle(insight.featured.name),
        subtitle: InsightCopy.wrongCycleSubtitle(
          insight.category?.label ?? '',
        ),
      ),
    };
  }

  void _review(BuildContext context, InsightItem insight) {
    HapticFeedback.selectionClick();
    if (insight.kind == InsightKind.overlap && insight.category != null) {
      ref.read(subscriptionListQueryProvider.notifier).setSearch('');
      ref
          .read(subscriptionListQueryProvider.notifier)
          .setCategory(insight.category);
      context.go(AppRoutes.subscriptions);
      return;
    }
    context.push(AppRoutes.subscriptionDetailLocation(insight.featured.id));
  }

  Future<void> _dismiss() async {
    HapticFeedback.lightImpact();
    setState(() => _hiding = true);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) {
      return;
    }
    ref.read(dismissedInsightsProvider.notifier).dismiss(widget.insight.id);
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.color,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool filled;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? color.withValues(alpha: 0.12) : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
