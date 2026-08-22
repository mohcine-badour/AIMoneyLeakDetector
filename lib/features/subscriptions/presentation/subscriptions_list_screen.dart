import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../domain/subscription.dart';
import '../subs_scroll.dart';
import '../subscriptions_providers.dart';
import 'category_filter_chips.dart';
import 'empty_filter_state.dart';
import 'filter_sheet.dart';
import 'search_overlay.dart';
import 'sort_view_controls.dart';
import 'subscription_list_row.dart';
import 'subscription_list_total.dart';
import 'subscriptions_header.dart';

class SubscriptionsListScreen extends ConsumerStatefulWidget {
  const SubscriptionsListScreen({super.key});

  @override
  ConsumerState<SubscriptionsListScreen> createState() =>
      _SubscriptionsListScreenState();
}

class _SubscriptionsListScreenState
    extends ConsumerState<SubscriptionsListScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = ref.watch(visibleSubscriptionsProvider);
    final all = ref.watch(subscriptionsProvider);
    final totals = ref.watch(subscriptionListTotalsProvider);
    final counts = ref.watch(subscriptionCategoryCountsProvider);
    final tokens = AppTokens.of(context);

    ref.listen(subscriptionsScrollToTopProvider, (previous, next) {
      if (previous == next || !_scroll.hasClients) {
        return;
      }
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });

    return AppScaffold(
      showAppBar: false,
      showTabs: true,
      padding: EdgeInsets.zero,
      body: ColoredBox(
        color: tokens.bgApp,
        child: visible.when(
          loading: () => const LoadingState(),
          error: (error, stackTrace) => ErrorState(
            message: AppStrings.errorLoadSubscriptions,
            onRetry: () => ref.invalidate(subscriptionsProvider),
          ),
          data: (items) {
            final allItems = all.asData?.value ?? const <Subscription>[];
            final currency = items.isNotEmpty
                ? items.first.currency
                : MoneyFormat.defaultCurrencyCode;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SubscriptionsHeader(
                  activeCount: totals.count,
                  monthly: totals.monthly,
                  currencyCode: currency,
                  hasAny: allItems.isNotEmpty,
                  onSearchPress: () => _openSearch(allItems),
                  onFilterPress: () => _openFilters(counts),
                ),
                if (allItems.isNotEmpty) ...[
                  CategoryFilterChips(categoryCounts: counts),
                  const SortViewControls(),
                ],
                Expanded(
                  child: items.isEmpty
                      ? ListView(
                          controller: _scroll,
                          children: [
                            EmptyFilterState(
                              hasAnySubscriptions: allItems.isNotEmpty,
                            ),
                          ],
                        )
                      : ListView(
                          controller: _scroll,
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
                              decoration: BoxDecoration(
                                color: tokens.bgCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: tokens.border,
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  for (var i = 0; i < items.length; i++)
                                    SubscriptionListRow(
                                      subscription: items[i],
                                      isLast: i == items.length - 1,
                                    ),
                                ],
                              ),
                            ),
                            SubscriptionListTotal(
                              totals: totals,
                              currencyCode: currency,
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openSearch(List<Subscription> subscriptions) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => SearchOverlay(subscriptions: subscriptions),
      ),
    );
  }

  Future<void> _openFilters(Map<String, int> counts) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return FilterSheet(categoryCounts: counts);
      },
    );
  }
}
