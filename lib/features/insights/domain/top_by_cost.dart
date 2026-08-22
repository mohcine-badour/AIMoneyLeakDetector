import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_cost.dart';
import 'spend_math.dart';

class TopByCostRow {
  const TopByCostRow({
    required this.subscription,
    required this.monthlyAmount,
    required this.percentOfTotal,
  });

  final Subscription subscription;
  final double monthlyAmount;
  final double percentOfTotal;
}

class TopByCost {
  const TopByCost({required this.rows, required this.totalCoveredPercent});

  final List<TopByCostRow> rows;
  final double totalCoveredPercent;

  static TopByCost from(List<Subscription> subscriptions, {int n = 3}) {
    final active = SpendMath.activeOf(subscriptions);
    final total = SpendMath.computeTotalMonthly(active);
    final sorted = [
      for (final item in active)
        (
          subscription: item,
          monthly: SubscriptionCost.monthlyEquivalent(item),
        ),
    ]..sort((a, b) => b.monthly.compareTo(a.monthly));

    final rows = [
      for (final item in sorted.take(n))
        TopByCostRow(
          subscription: item.subscription,
          monthlyAmount: item.monthly,
          percentOfTotal: total > 0 ? (item.monthly / total) * 100 : 0,
        ),
    ];

    return TopByCost(
      rows: rows,
      totalCoveredPercent: rows.fold<double>(
        0,
        (sum, row) => sum + row.percentOfTotal,
      ),
    );
  }
}