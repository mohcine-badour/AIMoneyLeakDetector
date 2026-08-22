import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/features/trials/data/drift_trial_repository.dart';
import 'package:kichta/features/trials/domain/trial.dart';

void main() {
  late AppDatabase database;
  late DriftTrialRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftTrialRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  Trial sample({
    String id = 'trial-1',
    String name = 'ChatGPT',
    TrialStatus status = TrialStatus.active,
  }) {
    return Trial.create(
      id: id,
      subscriptionName: name,
      amountAfterTrial: 20,
      trialEndDate: DateTime.utc(2026, 8, 26),
      status: status,
    );
  }

  test('saves and reads a trial', () async {
    await repository.save(sample());

    final stored = await repository.getById('trial-1');
    expect(stored, isNotNull);
    expect(stored!.subscriptionName, 'ChatGPT');
    expect(stored.amountAfterTrial, closeTo(20, 0.001));
    expect(stored.currency, 'USD');
    expect(stored.trialEndDate, DateTime.utc(2026, 8, 26));
    expect(stored.status, TrialStatus.active);
  });

  test('updates an existing trial', () async {
    await repository.save(sample());
    await repository.save(
      sample().copyWith(amountAfterTrial: 24, status: TrialStatus.cancelled),
    );

    final stored = await repository.getById('trial-1');
    expect(stored!.amountAfterTrial, closeTo(24, 0.001));
    expect(stored.status, TrialStatus.cancelled);
  });

  test('deletes a trial', () async {
    await repository.save(sample());
    await repository.deleteById('trial-1');

    expect(await repository.getById('trial-1'), isNull);
    expect(await repository.getAll(), isEmpty);
  });
}
