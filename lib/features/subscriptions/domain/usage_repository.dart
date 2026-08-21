import 'subscription_usage.dart';

abstract class UsageRepository {
  Future<SubscriptionUsage?> getBySubscriptionId(String subscriptionId);

  Future<Map<String, int>> declaredCounts();

  Future<void> save(SubscriptionUsage usage);

  Future<void> deleteBySubscriptionId(String subscriptionId);
}
