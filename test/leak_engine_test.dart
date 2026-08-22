import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/features/savings/domain/leak_engine.dart';
import 'package:kichta/features/savings/domain/leak_recommendation.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';
import 'package:kichta/features/trials/domain/trial.dart';

Subscription _sub({
  required String id,
  required String name,
  required double amount,
  required DateTime nextBillingDate,
  required SubscriptionCategory category,
  String? merchant,
  BillingCycle cycle = BillingCycle.monthly,
  SubscriptionStatus status = SubscriptionStatus.active,
}) {
  return Subscription.create(
    id: id,
    name: name,
    merchant: merchant ?? name,
    amount: amount,
    billingCycle: cycle,
    nextBillingDate: nextBillingDate,
    category: category,
    status: status,
  );
}

void main() {
  final now = DateTime.utc(2026, 8, 21);

  test('overlapping category spend includes a review reason', () {
    final recs = LeakEngine.analyze(
      subscriptions: [
        _sub(
          id: 'netflix',
          name: 'Netflix',
          amount: 22.99,
          nextBillingDate: DateTime.utc(2026, 9, 3),
          category: SubscriptionCategory.entertainment,
        ),
        _sub(
          id: 'hulu',
          name: 'Hulu',
          amount: 17.99,
          nextBillingDate: DateTime.utc(2026, 9, 10),
          category: SubscriptionCategory.entertainment,
        ),
        _sub(
          id: 'adobe',
          name: 'Adobe',
          amount: 59.99,
          nextBillingDate: DateTime.utc(2026, 9, 7),
          category: SubscriptionCategory.productivity,
        ),
      ],
      trials: const [],
      now: now,
    );

    final overlap = recs.where(
      (item) => item.kind == LeakKind.overlappingCategory,
    );
    expect(overlap, hasLength(1));
    expect(
      overlap.single.title,
      'You spend \$40.98/month on Entertainment subscriptions.',
    );
    expect(overlap.single.reason, AppStrings.leakOverlappingReason);
  });

  test('expensive subscriptions at or above \$50/month are flagged', () {
    final recs = LeakEngine.analyze(
      subscriptions: [
        _sub(
          id: 'netflix',
          name: 'Netflix',
          amount: 22.99,
          nextBillingDate: DateTime.utc(2026, 9, 3),
          category: SubscriptionCategory.entertainment,
        ),
        _sub(
          id: 'adobe',
          name: 'Adobe',
          amount: 59.99,
          nextBillingDate: DateTime.utc(2026, 9, 7),
          category: SubscriptionCategory.productivity,
        ),
      ],
      trials: const [],
      now: now,
    );

    final expensive = recs.where((item) => item.kind == LeakKind.expensive);
    expect(expensive, hasLength(1));
    expect(expensive.single.title, 'Adobe is \$59.99/month.');
    expect(expensive.single.reason, AppStrings.leakExpensiveReason);
    expect(expensive.single.subscriptionId, 'adobe');
  });

  test('duplicate merchants are flagged without claiming fraud', () {
    final recs = LeakEngine.analyze(
      subscriptions: [
        _sub(
          id: 'a',
          name: 'Netflix',
          merchant: 'Netflix',
          amount: 22.99,
          nextBillingDate: DateTime.utc(2026, 9, 3),
          category: SubscriptionCategory.entertainment,
        ),
        _sub(
          id: 'b',
          name: 'Netflix Extra',
          merchant: 'Netflix',
          amount: 6.99,
          nextBillingDate: DateTime.utc(2026, 9, 4),
          category: SubscriptionCategory.entertainment,
        ),
      ],
      trials: const [],
      now: now,
    );

    final duplicates = recs.where(
      (item) => item.kind == LeakKind.suspiciousDuplicate,
    );
    expect(duplicates, hasLength(1));
    expect(duplicates.single.title, 'You have 2 active Netflix subscriptions.');
    expect(duplicates.single.reason, AppStrings.leakDuplicateReason);
  });

  test('upcoming renewals within 7 days include a review reason', () {
    final recs = LeakEngine.analyze(
      subscriptions: [
        _sub(
          id: 'netflix',
          name: 'Netflix',
          amount: 22.99,
          nextBillingDate: DateTime.utc(2026, 8, 22),
          category: SubscriptionCategory.entertainment,
        ),
      ],
      trials: const [],
      now: now,
    );

    final upcoming = recs.where(
      (item) => item.kind == LeakKind.upcomingRenewal,
    );
    expect(upcoming.single.title, 'Netflix renews tomorrow.');
    expect(upcoming.single.reason, AppStrings.leakRenewalReason);
  });

  test('active trials are flagged as conversions', () {
    final recs = LeakEngine.analyze(
      subscriptions: const [],
      trials: [
        Trial.create(
          id: 'chatgpt',
          subscriptionName: 'ChatGPT',
          amountAfterTrial: 20,
          trialEndDate: DateTime.utc(2026, 8, 26),
        ),
      ],
      now: now,
    );

    expect(recs, hasLength(1));
    expect(recs.single.kind, LeakKind.trialConversion);
    expect(recs.single.title, 'ChatGPT trial ends in 5 days.');
    expect(recs.single.reason, r'After the trial it converts to $20.00/month.');
    expect(recs.single.trialId, 'chatgpt');
  });

  test('cancelled subscriptions and expired trials are skipped', () {
    final recs = LeakEngine.analyze(
      subscriptions: [
        _sub(
          id: 'hulu',
          name: 'Hulu',
          amount: 80,
          nextBillingDate: DateTime.utc(2026, 8, 22),
          category: SubscriptionCategory.entertainment,
          status: SubscriptionStatus.cancelled,
        ),
      ],
      trials: [
        Trial.create(
          id: 'old',
          subscriptionName: 'Old Trial',
          amountAfterTrial: 20,
          trialEndDate: DateTime.utc(2026, 8, 1),
        ),
      ],
      now: now,
    );

    expect(recs, isEmpty);
  });

  test('low-usage recommendations are not invented without usage data', () {
    final recs = LeakEngine.analyze(
      subscriptions: [
        _sub(
          id: 'netflix',
          name: 'Netflix',
          amount: 22.99,
          nextBillingDate: DateTime.utc(2026, 9, 21),
          category: SubscriptionCategory.entertainment,
        ),
      ],
      trials: const [],
      now: now,
    );

    expect(recs.where((item) => item.kind == LeakKind.lowUsage), isEmpty);
  });

  test('declared low usage is flagged with a reason', () {
    final recs = LeakEngine.analyze(
      subscriptions: [
        _sub(
          id: 'netflix',
          name: 'Netflix',
          amount: 22.99,
          nextBillingDate: DateTime.utc(2026, 9, 21),
          category: SubscriptionCategory.entertainment,
        ),
      ],
      trials: const [],
      now: now,
      usageBySubscriptionId: const {'netflix': 2},
    );

    final lowUsage = recs.where((item) => item.kind == LeakKind.lowUsage);
    expect(lowUsage, hasLength(1));
    expect(lowUsage.single.title, 'Netflix was used 2 times.');
    expect(lowUsage.single.reason, AppStrings.leakLowUsageReason);
    expect(lowUsage.single.subscriptionId, 'netflix');
  });

  test('higher declared usage is not treated as a leak', () {
    final recs = LeakEngine.analyze(
      subscriptions: [
        _sub(
          id: 'netflix',
          name: 'Netflix',
          amount: 22.99,
          nextBillingDate: DateTime.utc(2026, 9, 21),
          category: SubscriptionCategory.entertainment,
        ),
      ],
      trials: const [],
      now: now,
      usageBySubscriptionId: const {'netflix': 8},
    );

    expect(recs.where((item) => item.kind == LeakKind.lowUsage), isEmpty);
  });
}
