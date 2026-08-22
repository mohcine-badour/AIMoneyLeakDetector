import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/subscription_list_filter.dart';
import '../subscriptions_providers.dart';

class SortViewControls extends ConsumerWidget {
  const SortViewControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final query = ref.watch(subscriptionListQueryProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          _SortChip(
            label: _labelFor(query.sort),
            onPressed: () => _pickSort(context, ref, query.sort),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: tokens.bgMuted,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                _ViewToggle(
                  key: const Key('view-list'),
                  icon: AppIcons.list,
                  active: query.viewMode == SubscriptionViewMode.list,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(subscriptionListQueryProvider.notifier)
                        .setViewMode(SubscriptionViewMode.list);
                  },
                ),
                _ViewToggle(
                  key: const Key('view-grid'),
                  icon: AppIcons.grid,
                  active: query.viewMode == SubscriptionViewMode.grid,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(AppStrings.comingSoon)),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickSort(
    BuildContext context,
    WidgetRef ref,
    SubscriptionSort current,
  ) async {
    final selected = await showModalBottomSheet<SubscriptionSort>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final sort in SubscriptionSort.values)
                ListTile(
                  title: Text(_labelFor(sort)),
                  trailing: sort == current
                      ? Icon(
                          AppIcons.check,
                          color: AppTokens.of(context).textPrimary,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(sort),
                ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      ref.read(subscriptionListQueryProvider.notifier).setSort(selected);
    }
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

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: tokens.bgMuted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: tokens.border, width: 0.5),
      ),
      child: InkWell(
        key: const Key('sort-control'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.sort, size: 12, color: tokens.textSecondary),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: tokens.textSecondary,
                ),
              ),
              const SizedBox(width: 5),
              Icon(AppIcons.chevronDown, size: 11, color: tokens.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({
    required this.icon,
    required this.active,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 24,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? tokens.bgHover : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          icon,
          size: 12,
          color: active ? tokens.textPrimary : tokens.textMuted,
        ),
      ),
    );
  }
}
