import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import 'data/drift_subscription_repository.dart';
import 'data/drift_usage_repository.dart';
import 'domain/subscription.dart';
import 'subscriptions_providers.dart';
import 'usage_controller.dart';

final subscriptionDetailControllerProvider =
    Provider<SubscriptionDetailController>((ref) {
      return SubscriptionDetailController(ref);
    });

class SubscriptionDetailController {
  SubscriptionDetailController(this._ref);

  final Ref _ref;

  Future<void> setStatus(String id, SubscriptionStatus status) async {
    final current = await _ref.read(subscriptionRepositoryProvider).getById(id);
    if (current == null) {
      return;
    }
    await _ref
        .read(subscriptionRepositoryProvider)
        .save(
          current.copyWith(status: status, updatedAt: DateTime.now().toUtc()),
        );
    _ref.invalidate(subscriptionByIdProvider(id));
    _ref.invalidate(subscriptionsProvider);
  }

  Future<void> delete(String id) async {
    await _ref.read(usageRepositoryProvider).deleteBySubscriptionId(id);
    await _ref.read(subscriptionRepositoryProvider).deleteById(id);
    await _ref
        .read(analyticsProvider)
        .track(AnalyticsEvent.subscriptionDeleted);
    _ref.invalidate(subscriptionByIdProvider(id));
    _ref.invalidate(subscriptionsProvider);
    _ref.invalidate(usageBySubscriptionProvider(id));
    _ref.invalidate(declaredUsageCountsProvider);
  }
}
