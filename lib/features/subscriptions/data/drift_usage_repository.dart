import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/app_database_provider.dart';
import '../domain/subscription_usage.dart';
import '../domain/usage_repository.dart';

final usageRepositoryProvider = Provider<UsageRepository>((ref) {
  return DriftUsageRepository(ref.watch(appDatabaseProvider));
});

class DriftUsageRepository implements UsageRepository {
  DriftUsageRepository(this._db);

  final AppDatabase _db;

  @override
  Future<SubscriptionUsage?> getBySubscriptionId(String subscriptionId) async {
    final query = _db.select(_db.usageEntries)
      ..where((row) => row.subscriptionId.equals(subscriptionId));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<Map<String, int>> declaredCounts() async {
    final rows = await _db.select(_db.usageEntries).get();
    return {for (final row in rows) row.subscriptionId: row.useCount};
  }

  @override
  Future<void> save(SubscriptionUsage usage) async {
    await _db
        .into(_db.usageEntries)
        .insertOnConflictUpdate(_toCompanion(usage));
  }

  @override
  Future<void> deleteBySubscriptionId(String subscriptionId) async {
    await (_db.delete(
      _db.usageEntries,
    )..where((row) => row.subscriptionId.equals(subscriptionId))).go();
  }

  UsageEntriesCompanion _toCompanion(SubscriptionUsage usage) {
    return UsageEntriesCompanion(
      subscriptionId: Value(usage.subscriptionId),
      useCount: Value(usage.useCount),
      updatedAt: Value(usage.updatedAt.toUtc()),
    );
  }

  SubscriptionUsage _toDomain(UsageRow row) {
    return SubscriptionUsage(
      subscriptionId: row.subscriptionId,
      useCount: row.useCount,
      updatedAt: row.updatedAt.toUtc(),
    );
  }
}
