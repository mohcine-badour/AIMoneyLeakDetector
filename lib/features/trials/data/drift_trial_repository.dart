import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/app_database_provider.dart';
import '../domain/trial.dart';
import '../domain/trial_repository.dart';

final trialRepositoryProvider = Provider<TrialRepository>((ref) {
  return DriftTrialRepository(ref.watch(appDatabaseProvider));
});

class DriftTrialRepository implements TrialRepository {
  DriftTrialRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Trial>> getAll() async {
    final rows = await _db.select(_db.trialEntries).get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<Trial?> getById(String id) async {
    final query = _db.select(_db.trialEntries)
      ..where((row) => row.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> save(Trial trial) async {
    await _db.into(_db.trialEntries).insertOnConflictUpdate(_toCompanion(trial));
  }

  @override
  Future<void> deleteById(String id) async {
    await (_db.delete(_db.trialEntries)..where((row) => row.id.equals(id))).go();
  }

  TrialEntriesCompanion _toCompanion(Trial trial) {
    return TrialEntriesCompanion(
      id: Value(trial.id),
      subscriptionName: Value(trial.subscriptionName),
      amountAfterTrial: Value(trial.amountAfterTrial),
      currency: Value(trial.currency),
      trialEndDate: Value(trial.trialEndDate.toUtc()),
      status: Value(trial.status.name),
      createdAt: Value(trial.createdAt.toUtc()),
      updatedAt: Value(trial.updatedAt.toUtc()),
    );
  }

  Trial _toDomain(TrialRow row) {
    return Trial(
      id: row.id,
      subscriptionName: row.subscriptionName,
      amountAfterTrial: row.amountAfterTrial,
      currency: row.currency,
      trialEndDate: row.trialEndDate.toUtc(),
      status: TrialStatus.values.byName(row.status),
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
    );
  }
}
