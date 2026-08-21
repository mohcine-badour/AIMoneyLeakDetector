import 'subscription.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getAll();

  Future<Subscription?> getById(String id);

  Future<void> save(Subscription subscription);

  Future<void> deleteById(String id);

  Stream<List<Subscription>> watchAll();
}
