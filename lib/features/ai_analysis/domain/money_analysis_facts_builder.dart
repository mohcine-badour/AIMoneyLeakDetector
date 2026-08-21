import '../../dashboard/domain/dashboard_snapshot.dart';
import '../../savings/domain/analysis_summary.dart';
import '../../savings/domain/leak_engine.dart';
import '../../savings/domain/potential_savings.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../trials/domain/trial.dart';
import 'money_leak_report.dart';

/// Builds analysis facts from local data. Money math stays in Dart.
abstract final class MoneyAnalysisFactsBuilder {
  static MoneyAnalysisFacts from({
    required List<Subscription> subscriptions,
    required List<Trial> trials,
    required DateTime now,
    Map<String, int> usageBySubscriptionId = const {},
  }) {
    final snapshot = DashboardCalculator.fromSubscriptions(subscriptions);
    final recommendations = LeakEngine.analyze(
      subscriptions: subscriptions,
      trials: trials,
      now: now,
      usageBySubscriptionId: usageBySubscriptionId,
    );
    return MoneyAnalysisFacts(
      monthlySpend: snapshot.monthlyTotal,
      potentialSavings: PotentialSavingsCalculator.fromSubscriptions(
        subscriptions,
      ),
      currencyCode: snapshot.currencyCode,
      summary: AnalysisSummaryCalculator.from(
        subscriptions: subscriptions,
        recommendations: recommendations,
      ),
      recommendations: recommendations,
    );
  }
}
