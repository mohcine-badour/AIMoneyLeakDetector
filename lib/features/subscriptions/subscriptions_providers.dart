import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/drift_subscription_repository.dart';
import 'domain/subscription.dart';
import 'domain/subscription_list_filter.dart';

final subscriptionsProvider = FutureProvider<List<Subscription>>((ref) {
  return ref.watch(subscriptionRepositoryProvider).getAll();
});

final subscriptionByIdProvider =
    FutureProvider.family<Subscription?, String>((ref, id) {
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

class SubscriptionListQueryController extends Notifier<SubscriptionListQuery> {
  @override
  SubscriptionListQuery build() => const SubscriptionListQuery();

  void setSearch(String search) {
    state = SubscriptionListQuery(
      search: search,
      category: state.category,
      sort: state.sort,
    );
  }

  void setCategory(SubscriptionCategory? category) {
    state = SubscriptionListQuery(
      search: state.search,
      category: category,
      sort: state.sort,
    );
  }

  void setSort(SubscriptionSort sort) {
    state = SubscriptionListQuery(
      search: state.search,
      category: state.category,
      sort: sort,
    );
  }
}
