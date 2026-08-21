import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/drift_subscription_repository.dart';
import 'data/drift_usage_repository.dart';
import 'subscriptions_providers.dart';
import 'usage_controller.dart';

final subscriptionDetailControllerProvider =
    Provider<SubscriptionDetailController>((ref) {
  return SubscriptionDetailController(ref);
});

class SubscriptionDetailController {
  SubscriptionDetailController(this._ref);

  final Ref _ref;

  Future<void> delete(String id) async {
    await _ref.read(usageRepositoryProvider).deleteBySubscriptionId(id);
    await _ref.read(subscriptionRepositoryProvider).deleteById(id);
    _ref.invalidate(subscriptionByIdProvider(id));
    _ref.invalidate(subscriptionsProvider);
    _ref.invalidate(usageBySubscriptionProvider(id));
    _ref.invalidate(declaredUsageCountsProvider);
  }
}
