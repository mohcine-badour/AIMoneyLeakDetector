import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../domain/subscription_list_filter.dart';
import '../subscriptions_providers.dart';
import 'category_filter_chips.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({required this.categoryCounts, super.key});

  final Map<String, int> categoryCounts;

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late BrandCategory? _category;
  late SubscriptionSort _sort;
  late bool _showInactive;

  @override
  void initState() {
    super.initState();
    final query = ref.read(subscriptionListQueryProvider);
    _category = query.category;
    _sort = query.sort;
    _showInactive = query.showInactive;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: 16 + MediaQuery.paddingOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.filterAndSort,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(subscriptionListQueryProvider.notifier).reset();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.resetFilters,
                    style: TextStyle(color: tokens.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.fieldCategory,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: tokens.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            CategoryFilterChips(
              categoryCounts: widget.categoryCounts,
              wrap: true,
              selectedOverride: _category,
              onSelected: (category) => setState(() => _category = category),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.sortBy,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: tokens.textMuted,
              ),
            ),
            for (final sort in SubscriptionSort.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_labelFor(sort)),
                trailing: sort == _sort
                    ? Icon(AppIcons.check, color: tokens.textPrimary)
                    : null,
                onTap: () => setState(() => _sort = sort),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(AppStrings.showInactive),
              value: _showInactive,
              onChanged: (value) => setState(() => _showInactive = value),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: AppStrings.applyFilters,
              onPressed: () {
                ref
                    .read(subscriptionListQueryProvider.notifier)
                    .apply(
                      category: _category,
                      clearCategory: _category == null,
                      sort: _sort,
                      showInactive: _showInactive,
                    );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _labelFor(SubscriptionSort sort) {
    return switch (sort) {
      SubscriptionSort.nextPayment => AppStrings.sortNextPayment,
      SubscriptionSort.highestCost => AppStrings.sortHighestCost,
      SubscriptionSort.alphabetical => AppStrings.sortAlphabetical,
      SubscriptionSort.recentlyAdded => AppStrings.sortRecentlyAdded,
    };
  }
}
