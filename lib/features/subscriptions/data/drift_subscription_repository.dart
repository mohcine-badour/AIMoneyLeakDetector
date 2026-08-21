import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/app_database_provider.dart';
import '../domain/subscription.dart';
import '../domain/subscription_repository.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return DriftSubscriptionRepository(ref.watch(appDatabaseProvider));
});

class DriftSubscriptionRepository implements SubscriptionRepository {
  DriftSubscriptionRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Subscription>> getAll() async {
    final rows = await _db.select(_db.subscriptionEntries).get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<Subscription?> getById(String id) async {
    final query = _db.select(_db.subscriptionEntries)
      ..where((row) => row.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> save(Subscription subscription) async {
    await _db
        .into(_db.subscriptionEntries)
        .insertOnConflictUpdate(_toCompanion(subscription));
  }

  @override
  Future<void> deleteById(String id) async {
    await (_db.delete(_db.subscriptionEntries)
          ..where((row) => row.id.equals(id)))
        .go();
  }

  @override
  Stream<List<Subscription>> watchAll() {
    return _db.select(_db.subscriptionEntries).watch().map((rows) {
      return rows.map(_toDomain).toList();
    });
  }

  SubscriptionEntriesCompanion _toCompanion(Subscription subscription) {
    return SubscriptionEntriesCompanion(
      id: Value(subscription.id),
      name: Value(subscription.name),
      merchant: Value(subscription.merchant),
      amount: Value(subscription.amount),
      currency: Value(subscription.currency),
      billingCycle: Value(subscription.billingCycle.name),
      nextBillingDate: Value(subscription.nextBillingDate.toUtc()),
      category: Value(subscription.category.name),
      status: Value(subscription.status.name),
      source: Value(subscription.source.name),
      createdAt: Value(subscription.createdAt.toUtc()),
      updatedAt: Value(subscription.updatedAt.toUtc()),
    );
  }

  Subscription _toDomain(SubscriptionRow row) {
    return Subscription(
      id: row.id,
      name: row.name,
      merchant: row.merchant,
      amount: row.amount,
      currency: row.currency,
      billingCycle: BillingCycle.values.byName(row.billingCycle),
      nextBillingDate: row.nextBillingDate.toUtc(),
      category: SubscriptionCategory.values.byName(row.category),
      status: SubscriptionStatus.values.byName(row.status),
      source: SubscriptionSource.values.byName(row.source),
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
    );
  }
}
