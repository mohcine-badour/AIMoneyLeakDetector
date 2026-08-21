import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../domain/subscription.dart';
import '../domain/subscription_list_filter.dart';
import '../subscriptions_providers.dart';
import 'subscription_labels.dart';
import 'subscription_list_card.dart';

class SubscriptionsListScreen extends ConsumerWidget {
  const SubscriptionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(visibleSubscriptionsProvider);
    final query = ref.watch(subscriptionListQueryProvider);
    final all = ref.watch(subscriptionsProvider);

    return AppScaffold(
      title: AppStrings.subscriptionsTitle,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addSubscription),
        tooltip: AppStrings.addSubscriptionTitle,
        child: const Icon(AppIcons.add),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.page,
      ),
      body: visible.when(
        loading: () => const LoadingState(),
        error: (error, stackTrace) => ErrorState(
          message: AppStrings.errorLoadSubscriptions,
          onRetry: () => ref.invalidate(subscriptionsProvider),
        ),
        data: (items) {
          final hasAny = all.asData?.value.isNotEmpty ?? false;
          if (!hasAny) {
            return EmptyState(
              title: AppStrings.emptySubscriptionsTitle,
              message: AppStrings.emptySubscriptionsMessage,
              actionLabel: AppStrings.addSubscriptionTitle,
              onAction: () => context.push(AppRoutes.addSubscription),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                key: const Key('subscriptions-search'),
                label: AppStrings.searchSubscriptions,
                prefixIcon: AppIcons.search,
                onChanged: ref
                    .read(subscriptionListQueryProvider.notifier)
                    .setSearch,
              ),
              const SizedBox(height: AppSpacing.md),
              _CategoryFilters(
                selected: query.category,
                onSelected: ref
                    .read(subscriptionListQueryProvider.notifier)
                    .setCategory,
              ),
              const SizedBox(height: AppSpacing.sm),
              _SortFilters(
                selected: query.sort,
                onSelected: ref
                    .read(subscriptionListQueryProvider.notifier)
                    .setSort,
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(
                        title: AppStrings.noMatchingSubscriptionsTitle,
                        message: AppStrings.noMatchingSubscriptionsMessage,
                      )
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final subscription = items[index];
                          return SubscriptionListCard(
                            subscription: subscription,
                            onTap: () => context.push(
                              AppRoutes.subscriptionDetailLocation(
                                subscription.id,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.selected,
    required this.onSelected,
  });

  final SubscriptionCategory? selected;
  final ValueChanged<SubscriptionCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: AppStrings.filterAll,
            selected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final category in SubscriptionCategory.values)
            _FilterChip(
              label: category.label,
              selected: selected == category,
              onTap: () => onSelected(category),
            ),
        ],
      ),
    );
  }
}

class _SortFilters extends StatelessWidget {
  const _SortFilters({
    required this.selected,
    required this.onSelected,
  });

  final SubscriptionSort selected;
  final ValueChanged<SubscriptionSort> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        _FilterChip(
          label: AppStrings.sortNextDate,
          selected: selected == SubscriptionSort.nextBillingDate,
          onTap: () => onSelected(SubscriptionSort.nextBillingDate),
        ),
        _FilterChip(
          label: AppStrings.sortMonthlyCost,
          selected: selected == SubscriptionSort.monthlyCost,
          onTap: () => onSelected(SubscriptionSort.monthlyCost),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
