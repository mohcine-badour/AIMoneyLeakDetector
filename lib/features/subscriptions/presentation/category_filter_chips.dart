import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/subscription_brand.dart';
import '../subscriptions_providers.dart';

class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({
    required this.categoryCounts,
    this.wrap = false,
    this.onSelected,
    this.selectedOverride,
    super.key,
  });

  final Map<String, int> categoryCounts;
  final bool wrap;
  final ValueChanged<BrandCategory?>? onSelected;
  final BrandCategory? selectedOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = onSelected != null
        ? selectedOverride
        : ref.watch(subscriptionListQueryProvider).category;
    final chips = <Widget>[
      _Chip(
        key: const Key('filter-all'),
        label: AppStrings.filterAll,
        count: categoryCounts['all'] ?? 0,
        selected: selected == null,
        onTap: () => _select(ref, null),
      ),
      for (final category in SubscriptionBrand.orderedCategories)
        if ((categoryCounts[category.name] ?? 0) > 0)
          _Chip(
            key: Key('filter-${category.name}'),
            label: category.label,
            count: categoryCounts[category.name] ?? 0,
            selected: selected == category,
            onTap: () => _select(ref, category),
          ),
    ];

    if (wrap) {
      return Wrap(spacing: 6, runSpacing: 6, children: chips);
    }

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        children: [
          for (var i = 0; i < chips.length; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            chips[i],
          ],
        ],
      ),
    );
  }

  void _select(WidgetRef ref, BrandCategory? category) {
    HapticFeedback.selectionClick();
    if (onSelected != null) {
      onSelected!(category);
      return;
    }
    ref.read(subscriptionListQueryProvider.notifier).setCategory(category);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final background = selected ? tokens.accent : Colors.transparent;
    final labelColor = selected ? tokens.accentText : tokens.textSecondary;
    final countColor = selected
        ? tokens.accentText.withValues(alpha: 0.6)
        : tokens.textMuted;

    return Material(
      color: background,
      shape: StadiumBorder(
        side: selected
            ? BorderSide.none
            : BorderSide(color: tokens.borderStrong, width: 0.5),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.1,
                  color: labelColor,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: countColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
