import '../../../core/constants/app_strings.dart';
import '../../savings/domain/leak_recommendation.dart';
import '../domain/money_analyzer.dart';
import '../domain/money_leak_report.dart';

/// Local stand-in for the AI analysis backend.
///
/// It returns structured JSON and copies money figures from local facts so the
/// Flutter app never holds AI credentials. A remote HTTP client replaces this
/// in a later step.
class LocalMoneyAnalysisBackend implements MoneyAnalysisBackend {
  const LocalMoneyAnalysisBackend({this.delay = Duration.zero});

  final Duration delay;

  @override
  Future<Map<String, dynamic>> analyze(MoneyAnalysisFacts facts) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return {
      'monthly_spend': facts.monthlySpend,
      'currency': facts.currencyCode,
      'potential_savings': facts.potentialSavings,
      'mutates_data': false,
      'explanations': [
        for (final rec in facts.recommendations) explanationFor(rec.kind),
      ],
    };
  }

  static String explanationFor(LeakKind kind) {
    return switch (kind) {
      LeakKind.overlappingCategory => AppStrings.analysisOverlapExplanation,
      LeakKind.expensive => AppStrings.analysisExpensiveExplanation,
      LeakKind.suspiciousDuplicate => AppStrings.analysisDuplicateExplanation,
      LeakKind.upcomingRenewal => AppStrings.analysisRenewalExplanation,
      LeakKind.trialConversion => AppStrings.analysisTrialExplanation,
      LeakKind.lowUsage => AppStrings.analysisLowUsageExplanation,
    };
  }
}
