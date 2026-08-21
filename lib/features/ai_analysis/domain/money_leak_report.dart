import '../../savings/domain/analysis_summary.dart';
import '../../savings/domain/leak_recommendation.dart';

class MoneyAnalysisFacts {
  const MoneyAnalysisFacts({
    required this.monthlySpend,
    required this.potentialSavings,
    required this.currencyCode,
    required this.summary,
    required this.recommendations,
  });

  final double monthlySpend;
  final double potentialSavings;
  final String currencyCode;
  final AnalysisSummary summary;
  final List<LeakRecommendation> recommendations;
}

class ExplainedRecommendation {
  const ExplainedRecommendation({
    required this.recommendation,
    required this.explanation,
  });

  final LeakRecommendation recommendation;
  final String explanation;
}

class MoneyLeakReport {
  const MoneyLeakReport({
    required this.monthlySpend,
    required this.potentialSavings,
    required this.currencyCode,
    required this.summary,
    required this.items,
  });

  final double monthlySpend;
  final double potentialSavings;
  final String currencyCode;
  final AnalysisSummary summary;
  final List<ExplainedRecommendation> items;
}
