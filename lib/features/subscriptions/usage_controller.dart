import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/drift_usage_repository.dart';
import 'domain/subscription_usage.dart';

final usageBySubscriptionProvider =
    FutureProvider.family<SubscriptionUsage?, String>((ref, subscriptionId) {
  return ref.watch(usageRepositoryProvider).getBySubscriptionId(subscriptionId);
});

final declaredUsageCountsProvider = FutureProvider<Map<String, int>>((ref) {
  return ref.watch(usageRepositoryProvider).declaredCounts();
});

final subscriptionUsageControllerProvider =
    Provider<SubscriptionUsageController>((ref) {
  return SubscriptionUsageController(ref);
});

class SubscriptionUsageController {
  SubscriptionUsageController(this._ref);

  final Ref _ref;

  Future<void> setUses(String subscriptionId, int useCount) async {
    await _ref.read(usageRepositoryProvider).save(
      SubscriptionUsage.create(
        subscriptionId: subscriptionId,
        useCount: useCount,
      ),
    );
    _invalidate(subscriptionId);
  }

  Future<void> logUse(String subscriptionId) async {
    final current = await _ref
        .read(usageRepositoryProvider)
        .getBySubscriptionId(subscriptionId);
    await setUses(subscriptionId, (current?.useCount ?? 0) + 1);
  }

  Future<void> clear(String subscriptionId) async {
    await _ref
        .read(usageRepositoryProvider)
        .deleteBySubscriptionId(subscriptionId);
    _invalidate(subscriptionId);
  }

  void _invalidate(String subscriptionId) {
    _ref.invalidate(usageBySubscriptionProvider(subscriptionId));
    _ref.invalidate(declaredUsageCountsProvider);
  }
}
