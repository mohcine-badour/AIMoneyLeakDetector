import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/core/utils/id_generator.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

void main() {
  late AppDatabase database;
  late DriftSubscriptionRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftSubscriptionRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  Subscription sample({String id = 'sub-1', String name = 'Netflix'}) {
    return Subscription.create(
      id: id,
      name: name,
      merchant: 'Netflix',
      amount: 22.99,
      billingCycle: BillingCycle.monthly,
      nextBillingDate: DateTime.utc(2026, 9, 21),
      category: SubscriptionCategory.entertainment,
    );
  }

  test('IdGenerator creates distinct values', () {
    expect(IdGenerator.next(), isNot(IdGenerator.next()));
  });

  test('saves and reads a subscription', () async {
    await repository.save(sample());

    final stored = await repository.getById('sub-1');
    expect(stored, isNotNull);
    expect(stored!.name, 'Netflix');
    expect(stored.merchant, 'Netflix');
    expect(stored.amount, closeTo(22.99, 0.001));
    expect(stored.currency, 'USD');
    expect(stored.billingCycle, BillingCycle.monthly);
    expect(stored.nextBillingDate, DateTime.utc(2026, 9, 21));
    expect(stored.category, SubscriptionCategory.entertainment);
    expect(stored.status, SubscriptionStatus.active);
    expect(stored.source, SubscriptionSource.manual);
  });

  test('updates an existing subscription', () async {
    await repository.save(sample());
    await repository.save(
      sample().copyWith(name: 'Netflix Basic', amount: 15.99),
    );

    final stored = await repository.getById('sub-1');
    expect(stored!.name, 'Netflix Basic');
    expect(stored.amount, closeTo(15.99, 0.001));
    expect(stored.createdAt, isNotNull);
  });

  test('deletes a subscription', () async {
    await repository.save(sample());
    await repository.deleteById('sub-1');

    expect(await repository.getById('sub-1'), isNull);
    expect(await repository.getAll(), isEmpty);
  });

  test('getAll returns every saved subscription', () async {
    await repository.save(sample(id: 'a', name: 'A'));
    await repository.save(sample(id: 'b', name: 'B'));

    final all = await repository.getAll();
    expect(all.map((item) => item.id), containsAll(['a', 'b']));
  });

  test('persists every billing cycle and category', () async {
    var index = 0;
    for (final cycle in BillingCycle.values) {
      for (final category in SubscriptionCategory.values) {
        index += 1;
        await repository.save(
          sample(
            id: 'row-$index',
          ).copyWith(billingCycle: cycle, category: category),
        );
      }
    }

    final all = await repository.getAll();
    expect(
      all,
      hasLength(
        BillingCycle.values.length * SubscriptionCategory.values.length,
      ),
    );
    expect(
      all.map((item) => item.billingCycle).toSet(),
      BillingCycle.values.toSet(),
    );
    expect(
      all.map((item) => item.category).toSet(),
      SubscriptionCategory.values.toSet(),
    );
  });
}
