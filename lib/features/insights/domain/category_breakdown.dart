import 'package:flutter/material.dart';

import '../../../core/brand/brand_registry.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_brand.dart';
import 'category_colors.dart';
import 'insights_timeframe.dart';
import 'spend_math.dart';

class CategoryBreakdownRow {
  const CategoryBreakdownRow({
    required this.category,
    required this.amount,
    required this.percentOfTotal,
    required this.color,
    required this.subCount,
  });

  final BrandCategory category;
  final double amount;
  final double percentOfTotal;
  final Color color;
  final int subCount;
}

class CategoryBreakdown {
  const CategoryBreakdown({required this.rows, required this.total});

  final List<CategoryBreakdownRow> rows;
  final double total;

  static CategoryBreakdown from({
    required List<Subscription> subscriptions,
    required InsightsTimeframe timeframe,
    required DateTime now,
  }) {
    final active = SpendMath.activeOf(subscriptions);
    final byCat = <BrandCategory, double>{};
    final counts = <BrandCategory, int>{};

    for (final item in active) {
      final category = SubscriptionBrand.categoryFor(item);
      final amount = SpendMath.amountInWindow(
        subscription: item,
        timeframe: timeframe,
        now: now,
      );
      byCat[category] = (byCat[category] ?? 0) + amount;
      counts[category] = (counts[category] ?? 0) + 1;
    }

    final total = byCat.values.fold<double>(0, (sum, value) => sum + value);
    final rows = [
      for (final entry in byCat.entries)
        CategoryBreakdownRow(
          category: entry.key,
          amount: entry.value,
          percentOfTotal: total > 0 ? (entry.value / total) * 100 : 0,
          color: CategoryColors.of(entry.key),
          subCount: counts[entry.key] ?? 0,
        ),
    ]..sort((a, b) => b.amount.compareTo(a.amount));

    return CategoryBreakdown(rows: rows, total: total);
  }
}
