import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/clock_provider.dart';
import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import '../subscriptions/subscriptions_providers.dart';
import '../subscriptions/usage_controller.dart';
import '../trials/trials_providers.dart';
import 'data/local_money_analysis_backend.dart';
import 'data/validated_money_analyzer.dart';
import 'domain/money_analysis_facts_builder.dart';
import 'domain/money_analyzer.dart';
import 'domain/money_leak_report.dart';

final moneyAnalyzerProvider = Provider<MoneyAnalyzer>((ref) {
  return const ValidatedMoneyAnalyzer(LocalMoneyAnalysisBackend());
});

final moneyLeakReportProvider = FutureProvider<MoneyLeakReport>((ref) async {
  final analytics = ref.read(analyticsProvider);
  await analytics.track(AnalyticsEvent.aiAnalysisStarted);
  try {
    final subscriptions = await ref.watch(subscriptionsProvider.future);
    final trials = await ref.watch(trialsProvider.future);
    final usage = await ref.watch(declaredUsageCountsProvider.future);
    final now = ref.watch(appNowProvider);
    final facts = MoneyAnalysisFactsBuilder.from(
      subscriptions: subscriptions,
      trials: trials,
      now: now,
      usageBySubscriptionId: usage,
    );
    final report = await ref.read(moneyAnalyzerProvider).analyze(facts);
    await analytics.track(
      AnalyticsEvent.aiAnalysisCompleted,
      properties: const {'success': true},
    );
    return report;
  } on Object {
    await analytics.track(
      AnalyticsEvent.aiAnalysisCompleted,
      properties: const {'success': false},
    );
    rethrow;
  }
});
