import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/core/brand/brand_registry.dart';
import 'package:billkiller_ai/features/insights/domain/category_breakdown.dart';
import 'package:billkiller_ai/features/insights/domain/category_colors.dart';
import 'package:billkiller_ai/features/insights/domain/insight_item.dart';
import 'package:billkiller_ai/features/insights/domain/insight_list.dart';
import 'package:billkiller_ai/features/insights/domain/insights_timeframe.dart';
import 'package:billkiller_ai/features/insights/domain/spend_math.dart';
import 'package:billkiller_ai/features/insights/domain/spend_metrics.dart';
import 'package:billkiller_ai/features/insights/domain/top_by_cost.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

Subscription _sub({
  required String id,
  required String name,
  required double amount,
  required SubscriptionCategory category,
  BillingCycle cycle = BillingCycle.monthly,
  DateTime? nextBillingDate,
  DateTime? createdAt,
  DateTime? now,
}) {
  final clock = now ?? DateTime.utc(2026, 8, 21);
  return Subscription.create(
    id: id,
    name: name,
    merchant: name,
    amount: amount,
    billingCycle: cycle,
    nextBillingDate: nextBillingDate ?? DateTime.utc(2026, 9, 10),
    category: category,
    createdAt: createdAt ?? DateTime.utc(2026, 1, 15),
    updatedAt: clock,
  );
}

void main() {
  final now = DateTime.utc(2026, 8, 21, 20);
  final netflix = _sub(
    id: 'netflix',
    name: 'Netflix',
    amount: 22.99,
    category: SubscriptionCategory.entertainment,
    now: now,
  );
  final hulu = _sub(
    id: 'hulu',
    name: 'Hulu',
    amount: 17.99,
    category: SubscriptionCategory.entertainment,
    now: now,
  );
  final adobe = _sub(
    id: 'adobe',
    name: 'Adobe',
    amount: 59.99,
    category: SubscriptionCategory.productivity,
    now: now,
  );

  test('monthly total normalizes cycles before summing', () {
    final weekly = _sub(
      id: 'spotify',
      name: 'Spotify',
      amount: 2.99,
      category: SubscriptionCategory.entertainment,
      cycle: BillingCycle.weekly,
      now: now,
    );
    expect(
      SpendMath.computeTotalMonthly([weekly]),
      closeTo(2.99 * 52 / 12, 0.001),
    );
  });

  test('spark uses createdAt existence and marks the series estimated', () {
    final spark = SpendMath.computeSpark6mo([netflix, hulu], now);
    expect(spark.values.length, 6);
    expect(spark.isEstimated, isTrue);
    expect(spark.values.last, closeTo(40.98, 0.001));
    expect(spark.values.first, closeTo(40.98, 0.001));
  });

  test('spend delta is signed and hides small moves in the hero', () {
    expect(SpendMath.computeSpendDelta(40.98, 52.98), closeTo(-12, 0.001));
    expect(SpendMath.computeSpendDelta(40.98, 40.98).abs() < 1, isTrue);
  });

  test('last 6 months hero is the spark sum', () {
    final metrics = SpendMetrics.from(
      subscriptions: [netflix, hulu],
      timeframe: InsightsTimeframe.sixMonths,
      now: now,
    );
    expect(metrics.periodTotal, closeTo(40.98 * 6, 0.001));
    expect(metrics.totalYearly, closeTo(40.98 * 12, 0.001));
  });

  test('category breakdown sorts by amount and uses shared colors', () {
    final breakdown = CategoryBreakdown.from(
      subscriptions: [netflix, adobe],
      timeframe: InsightsTimeframe.month,
      now: now,
    );
    expect(breakdown.rows.first.category, BrandCategory.productivity);
    expect(breakdown.rows.first.color, CategoryColors.of(BrandCategory.productivity));
    expect(breakdown.rows.last.category, BrandCategory.entertainment);
  });

  test('top by cost covers the leading share of monthly spend', () {
    final top = TopByCost.from([adobe, netflix, hulu]);
    expect(top.rows.map((row) => row.subscription.id), ['adobe', 'netflix', 'hulu']);
    expect(top.totalCoveredPercent, closeTo(100, 0.001));
  });

  test('overlap is current and not duplicated per subscription', () {
    final insights = InsightListResolver.resolve([netflix, hulu], now: now);
    expect(insights, hasLength(1));
    expect(insights.first.kind, InsightKind.overlap);
    expect(insights.first.potentialSavings, 17.99);
  });

  test('unused beats overlap for the same subscription', () {
    final insights = InsightListResolver.resolve(
      [netflix, hulu],
      now: now,
      lastOpenedById: {netflix.id: now.subtract(const Duration(days: 42))},
    );
    expect(insights.first.kind, InsightKind.unused);
    expect(insights.first.featured.id, netflix.id);
    expect(insights.where((item) => item.kind == InsightKind.overlap), isEmpty);
  });

  test('dismissed ids stay out of the shown list', () {
    final insights = InsightListResolver.resolve(
      [netflix, hulu],
      now: now,
      dismissedIds: {'overlap:entertainment'},
    );
    expect(insights, isEmpty);
  });

  test('weekly entertainment is flagged as a possible wrong cycle', () {
    final weekly = _sub(
      id: 'netflix-week',
      name: 'Netflix',
      amount: 15.49,
      category: SubscriptionCategory.entertainment,
      cycle: BillingCycle.weekly,
      now: now,
    );
    final insights = InsightListResolver.resolve([weekly], now: now);
    expect(insights.single.kind, InsightKind.wrongCycle);
  });
}
