import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/brand/brand_registry.dart';
import '../../core/providers/shared_preferences_provider.dart';
import 'data/drift_subscription_repository.dart';
import 'domain/subscription.dart';
import 'domain/subscription_list_filter.dart';

final subscriptionsProvider = FutureProvider<List<Subscription>>((ref) {
  return ref.watch(subscriptionRepositoryProvider).getAll();
});

final subscriptionByIdProvider = FutureProvider.family<Subscription?, String>((
  ref,
  id,
) {
  return ref.watch(subscriptionRepositoryProvider).getById(id);
});

final subscriptionListQueryProvider =
    NotifierProvider<SubscriptionListQueryController, SubscriptionListQuery>(
      SubscriptionListQueryController.new,
    );

final visibleSubscriptionsProvider = Provider<AsyncValue<List<Subscription>>>((
  ref,
) {
  final query = ref.watch(subscriptionListQueryProvider);
  return ref.watch(subscriptionsProvider).whenData((items) {
    return SubscriptionListFilter.apply(items, query);
  });
});

final subscriptionListTotalsProvider = Provider<SubscriptionListTotals>((ref) {
  final visible = ref.watch(visibleSubscriptionsProvider).asData?.value ?? [];
  return SubscriptionListTotals.from(visible);
});

final subscriptionCategoryCountsProvider = Provider<Map<String, int>>((ref) {
  final items = ref.watch(subscriptionsProvider).asData?.value ?? [];
  return SubscriptionListFilter.categoryCounts(items);
});

class SubscriptionListQueryController extends Notifier<SubscriptionListQuery> {
  static const _categoryKey = 'subs.filter.category';
  static const _sortKey = 'subs.filter.sort';
  static const _viewKey = 'subs.filter.view';
  static const _inactiveKey = 'subs.filter.inactive';
  static const _searchKey = 'subs.filter.search';
  static const _recentKey = 'subs.filter.recent';

  @override
  SubscriptionListQuery build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SubscriptionListQuery(
      search: prefs.getString(_searchKey) ?? '',
      category: _parseCategory(prefs.getString(_categoryKey)),
      sort: _parseSort(prefs.getString(_sortKey)),
      viewMode: prefs.getString(_viewKey) == SubscriptionViewMode.grid.name
          ? SubscriptionViewMode.grid
          : SubscriptionViewMode.list,
      showInactive: prefs.getBool(_inactiveKey) ?? false,
    );
  }

  List<String> recentSearches() {
    final raw = ref.read(sharedPreferencesProvider).getStringList(_recentKey);
    return raw ?? const [];
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
    _persist();
  }

  void rememberSearch(String search) {
    final value = search.trim();
    if (value.isEmpty) {
      return;
    }
    final next = [
      value,
      for (final item in recentSearches())
        if (item.toLowerCase() != value.toLowerCase()) item,
    ].take(5).toList();
    ref.read(sharedPreferencesProvider).setStringList(_recentKey, next);
  }

  void setCategory(BrandCategory? category) {
    state = state.copyWith(category: category, clearCategory: category == null);
    _persist();
  }

  void setSort(SubscriptionSort sort) {
    state = state.copyWith(sort: sort);
    _persist();
  }

  void setViewMode(SubscriptionViewMode viewMode) {
    state = state.copyWith(viewMode: viewMode);
    _persist();
  }

  void setShowInactive(bool showInactive) {
    state = state.copyWith(showInactive: showInactive);
    _persist();
  }

  void apply({
    BrandCategory? category,
    bool clearCategory = false,
    SubscriptionSort? sort,
    bool? showInactive,
  }) {
    state = state.copyWith(
      category: category,
      clearCategory: clearCategory,
      sort: sort,
      showInactive: showInactive,
    );
    _persist();
  }

  void reset() {
    state = const SubscriptionListQuery();
    _persist();
  }

  void _persist() {
    final prefs = ref.read(sharedPreferencesProvider);
    final category = state.category?.name ?? 'all';
    prefs.setString(_categoryKey, category);
    prefs.setString(_sortKey, state.sort.name);
    prefs.setString(_viewKey, state.viewMode.name);
    prefs.setBool(_inactiveKey, state.showInactive);
    prefs.setString(_searchKey, state.search);
  }

  static BrandCategory? _parseCategory(String? raw) {
    if (raw == null || raw == 'all') {
      return null;
    }
    for (final value in BrandCategory.values) {
      if (value.name == raw) {
        return value;
      }
    }
    return null;
  }

  static SubscriptionSort _parseSort(String? raw) {
    for (final value in SubscriptionSort.values) {
      if (value.name == raw) {
        return value;
      }
    }
    return SubscriptionSort.nextPayment;
  }
}
