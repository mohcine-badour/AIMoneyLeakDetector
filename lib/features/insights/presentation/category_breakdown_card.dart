import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../domain/category_breakdown.dart';

class CategoryBreakdownCard extends StatefulWidget {
  const CategoryBreakdownCard({required this.breakdown, super.key});

  final CategoryBreakdown breakdown;

  @override
  State<CategoryBreakdownCard> createState() => _CategoryBreakdownCardState();
}

class _CategoryBreakdownCardState extends State<CategoryBreakdownCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _mount = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();

  @override
  void dispose() {
    _mount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final breakdown = widget.breakdown;
    if (breakdown.rows.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            children: [
              Text(
                AppStrings.whereItGoes,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: tokens.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                AppStrings.categoryCount(breakdown.rows.length),
                style: TextStyle(fontSize: 11, color: tokens.textMuted),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: tokens.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: Column(
            children: [
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _mount,
                  curve: Curves.easeOutCubic,
                ),
                child: _StackedBar(rows: breakdown.rows),
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < breakdown.rows.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                _LegendRow(row: breakdown.rows[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StackedBar extends StatelessWidget {
  const _StackedBar({required this.rows});

  final List<CategoryBreakdownRow> rows;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Row(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(width: 2),
              Expanded(
                flex: (rows[i].amount * 100).round().clamp(1, 1000000),
                child: ColoredBox(color: rows[i].color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends ConsumerWidget {
  const _LegendRow({required this.row});

  final CategoryBreakdownRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    return InkWell(
      key: Key('category-legend-${row.category.name}'),
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(subscriptionListQueryProvider.notifier).setSearch('');
        ref
            .read(subscriptionListQueryProvider.notifier)
            .setCategory(row.category);
        context.go(AppRoutes.subscriptions);
      },
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: row.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              row.category.label,
              style: TextStyle(fontSize: 12, color: tokens.textPrimary),
            ),
          ),
          Text(
            MoneyFormat.format(row.amount),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: tokens.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '${row.percentOfTotal.round()}%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 10.5,
                color: tokens.textMuted,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
