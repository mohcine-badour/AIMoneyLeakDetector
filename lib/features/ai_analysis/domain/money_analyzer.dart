import 'money_leak_report.dart';

/// Port for AI money analysis. Implementations must not embed AI API keys.
abstract class MoneyAnalysisBackend {
  Future<Map<String, dynamic>> analyze(MoneyAnalysisFacts facts);
}

abstract class MoneyAnalyzer {
  Future<MoneyLeakReport> analyze(MoneyAnalysisFacts facts);
}
