import '../../subscriptions/domain/subscription.dart';
import 'insights_timeframe.dart';
import 'spend_math.dart';

class SpendMetrics {
  const SpendMetrics({
    required this.periodTotal,
    required this.totalMonthly,
    required this.totalYearly,
    required this.monthDelta,
    required this.spark,
    required this.avg6mo,
    required this.renewalsThisWeek,
    required this.timeframe,
    required this.currencyCode,
  });

  final double periodTotal;
  final double totalMonthly;
  final double totalYearly;
  final double monthDelta;
  final Spark6mo spark;
  final double avg6mo;
  final int renewalsThisWeek;
  final InsightsTimeframe timeframe;
  final String currencyCode;

  static SpendMetrics from({
    required List<Subscription> subscriptions,
    required InsightsTimeframe timeframe,
    required DateTime now,
  }) {
    final totalMonthly = SpendMath.computeTotalMonthly(subscriptions);
    final spark = SpendMath.computeSpark6mo(subscriptions, now);
    final current = spark.values.isEmpty ? 0.0 : spark.values.last;
    final previous = spark.values.length > 1
        ? spark.values[spark.values.length - 2]
        : 0.0;
    final currencies = {
      for (final item in SpendMath.activeOf(subscriptions)) item.currency,
    };
    final sparkSum = spark.values.fold<double>(0, (sum, value) => sum + value);

    return SpendMetrics(
      periodTotal: SpendMath.periodTotal(
        subscriptions: subscriptions,
        timeframe: timeframe,
        now: now,
      ),
      totalMonthly: totalMonthly,
      totalYearly: totalMonthly * 12,
      monthDelta: SpendMath.computeSpendDelta(current, previous),
      spark: spark,
      avg6mo: spark.values.isEmpty ? 0 : (sparkSum / spark.values.length),
      renewalsThisWeek: SpendMath.countRenewalsWithin(subscriptions, 7, now),
      timeframe: timeframe,
      currencyCode: currencies.length == 1
          ? currencies.first
          : 'USD',
    );
  }
}
