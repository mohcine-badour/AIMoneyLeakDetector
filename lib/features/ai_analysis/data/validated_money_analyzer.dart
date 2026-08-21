import '../domain/money_analyzer.dart';
import '../domain/money_analysis_validator.dart';
import '../domain/money_leak_report.dart';

/// Turns validated backend JSON into a read-only money leak report.
class ValidatedMoneyAnalyzer implements MoneyAnalyzer {
  const ValidatedMoneyAnalyzer(this._backend);

  final MoneyAnalysisBackend _backend;

  @override
  Future<MoneyLeakReport> analyze(MoneyAnalysisFacts facts) async {
    final json = await _backend.analyze(facts);
    final explanations = MoneyAnalysisValidator.parse(
      json: json,
      facts: facts,
    );
    return MoneyLeakReport(
      monthlySpend: facts.monthlySpend,
      potentialSavings: facts.potentialSavings,
      currencyCode: facts.currencyCode,
      summary: facts.summary,
      items: [
        for (var i = 0; i < facts.recommendations.length; i++)
          ExplainedRecommendation(
            recommendation: facts.recommendations[i],
            explanation: explanations[i],
          ),
      ],
    );
  }
}
