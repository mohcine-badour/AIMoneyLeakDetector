import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_usage_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription_usage.dart';

void main() {
  late AppDatabase database;
  late DriftUsageRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftUsageRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('saves and reads declared usage', () async {
    await repository.save(
      SubscriptionUsage.create(
        subscriptionId: 'netflix',
        useCount: 8,
        updatedAt: DateTime.utc(2026, 8, 21),
      ),
    );

    final stored = await repository.getBySubscriptionId('netflix');
    expect(stored, isNotNull);
    expect(stored!.useCount, 8);
    expect(await repository.declaredCounts(), {'netflix': 8});
  });

  test('updates an existing usage count', () async {
    await repository.save(
      SubscriptionUsage.create(subscriptionId: 'netflix', useCount: 1),
    );
    await repository.save(
      SubscriptionUsage.create(subscriptionId: 'netflix', useCount: 8),
    );

    final stored = await repository.getBySubscriptionId('netflix');
    expect(stored!.useCount, 8);
  });

  test('deletes usage for a subscription', () async {
    await repository.save(
      SubscriptionUsage.create(subscriptionId: 'netflix', useCount: 8),
    );
    await repository.deleteBySubscriptionId('netflix');

    expect(await repository.getBySubscriptionId('netflix'), isNull);
    expect(await repository.declaredCounts(), isEmpty);
  });
}
