import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/subscription.dart';
import 'subscription_labels.dart';

Future<SubscriptionCategory?> showCategorySheet({
  required BuildContext context,
  SubscriptionCategory? current,
}) {
  final tokens = AppTokens.of(context);
  return showModalBottomSheet<SubscriptionCategory>(
    context: context,
    backgroundColor: tokens.bgCard,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    showDragHandle: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => CategorySheet(current: current),
  );
}

class CategorySheet extends StatelessWidget {
  const CategorySheet({this.current, super.key});

  final SubscriptionCategory? current;

  static List<SubscriptionCategory> get selectable => SubscriptionCategory
      .values
      .where((category) => category != SubscriptionCategory.software)
      .toList();

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final categories = selectable;
    final grid = categories
        .where((category) => category != SubscriptionCategory.other)
        .toList();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          16 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: tokens.borderStrong,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.fieldCategory.toUpperCase(),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: tokens.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.05,
              children: [
                for (final category in grid)
                  _CategoryTile(
                    category: category,
                    selected: category == current,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).pop(category);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _CategoryTile(
              category: SubscriptionCategory.other,
              selected: current == SubscriptionCategory.other,
              wide: true,
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop(SubscriptionCategory.other);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
    this.wide = false,
  });

  final SubscriptionCategory category;
  final bool selected;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: selected ? tokens.indigoBg : tokens.bgMuted,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: Key('category-${category.name}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: wide
              ? const EdgeInsets.fromLTRB(14, 12, 12, 12)
              : const EdgeInsets.fromLTRB(12, 12, 10, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? tokens.borderIndigo : tokens.border,
              width: 0.5,
            ),
          ),
          child: wide ? _wideContent(tokens) : _gridContent(tokens),
        ),
      ),
    );
  }

  Widget _gridContent(AppTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              category.icon,
              size: 18,
              color: selected ? tokens.indigoText : tokens.textSecondary,
            ),
            const Spacer(),
            if (selected)
              Icon(AppIcons.check, size: 16, color: tokens.indigoText),
          ],
        ),
        const Spacer(),
        Text(
          category.label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.15,
            height: 1.2,
            color: tokens.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _wideContent(AppTokens tokens) {
    return Row(
      children: [
        Icon(
          category.icon,
          size: 18,
          color: selected ? tokens.indigoText : tokens.textSecondary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            category.label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.15,
              color: tokens.textPrimary,
            ),
          ),
        ),
        if (selected) Icon(AppIcons.check, size: 16, color: tokens.indigoText),
      ],
    );
  }
}

extension on SubscriptionCategory {
  IconData get icon => switch (this) {
    SubscriptionCategory.entertainment => AppIcons.categoryEntertainment,
    SubscriptionCategory.productivity => AppIcons.categoryProductivity,
    SubscriptionCategory.cloudStorage => AppIcons.categoryCloudStorage,
    SubscriptionCategory.fitness => AppIcons.categoryFitness,
    SubscriptionCategory.education => AppIcons.categoryEducation,
    SubscriptionCategory.software => AppIcons.categorySoftware,
    SubscriptionCategory.news => AppIcons.categoryNews,
    SubscriptionCategory.gaming => AppIcons.categoryGaming,
    SubscriptionCategory.finance => AppIcons.categoryFinance,
    SubscriptionCategory.other => AppIcons.categoryOther,
  };
}
