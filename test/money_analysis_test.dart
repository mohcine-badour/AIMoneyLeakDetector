import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/features/ai_analysis/data/local_money_analysis_backend.dart';
import 'package:kichta/features/ai_analysis/data/validated_money_analyzer.dart';
import 'package:kichta/features/ai_analysis/domain/money_analysis_exception.dart';
import 'package:kichta/features/ai_analysis/domain/money_analysis_facts_builder.dart';
import 'package:kichta/features/ai_analysis/domain/money_analysis_validator.dart';
import 'package:kichta/features/ai_analysis/domain/money_analyzer.dart';
import 'package:kichta/features/ai_analysis/domain/money_leak_report.dart';
import 'package:kichta/features/savings/domain/leak_recommendation.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';

Subscription _sub({
  required String id,
  required String name,
  required double amount,
  required DateTime nextBillingDate,
  required SubscriptionCategory category,
}) {
  return Subscription.create(
    id: id,
    name: name,
    merchant: name,
    amount: amount,
    billingCycle: BillingCycle.monthly,
    nextBillingDate: nextBillingDate,
    category: category,
  );
}

class _JsonBackend implements MoneyAnalysisBackend {
  const _JsonBackend(this.json);

  final Map<String, dynamic> json;

  @override
  Future<Map<String, dynamic>> analyze(MoneyAnalysisFacts facts) async => json;
}

void main() {
  final now = DateTime.utc(2026, 8, 21);

  MoneyAnalysisFacts factsFor() {
    return MoneyAnalysisFactsBuilder.from(
      subscriptions: [
        _sub(
          id: 'netflix',
          name: 'Netflix',
          amount: 22.99,
          nextBillingDate: DateTime.utc(2026, 9, 3),
          category: SubscriptionCategory.entertainment,
        ),
        _sub(
          id: 'hulu',
          name: 'Hulu',
          amount: 17.99,
          nextBillingDate: DateTime.utc(2026, 9, 10),
          category: SubscriptionCategory.entertainment,
        ),
      ],
      trials: const [],
      now: now,
    );
  }

  test('facts keep spend and overlap extras in Dart', () {
    final facts = factsFor();

    expect(facts.monthlySpend, closeTo(40.98, 0.0001));
    expect(facts.potentialSavings, closeTo(17.99, 0.0001));
    expect(facts.summary.subscriptionsToReview, 2);
    expect(facts.summary.possibleOverlaps, 1);
    expect(facts.summary.upcomingExpensiveRenewals, 0);
    expect(facts.recommendations.single.kind, LeakKind.overlappingCategory);
  });

  test('upcoming expensive renewals are counted when both rules match', () {
    final facts = MoneyAnalysisFactsBuilder.from(
      subscriptions: [
        _sub(
          id: 'adobe',
          name: 'Adobe',
          amount: 59.99,
          nextBillingDate: DateTime.utc(2026, 8, 22),
          category: SubscriptionCategory.productivity,
        ),
      ],
      trials: const [],
      now: now,
    );

    expect(facts.summary.subscriptionsToReview, 1);
    expect(facts.summary.upcomingExpensiveRenewals, 1);
    expect(facts.potentialSavings, 0);
  });

  test('local backend explains recs without changing money figures', () async {
    final facts = factsFor();
    final report = await const ValidatedMoneyAnalyzer(
      LocalMoneyAnalysisBackend(),
    ).analyze(facts);

    expect(report.monthlySpend, closeTo(facts.monthlySpend, 0.0001));
    expect(report.potentialSavings, closeTo(facts.potentialSavings, 0.0001));
    expect(report.items, hasLength(1));
    expect(
      report.items.single.explanation,
      AppStrings.analysisOverlapExplanation,
    );
  });

  test('validator rejects money figures that do not match local facts', () {
    final facts = factsFor();
    expect(
      () => MoneyAnalysisValidator.parse(
        json: {
          'monthly_spend': 999,
          'potential_savings': facts.potentialSavings,
          'currency': facts.currencyCode,
          'mutates_data': false,
          'explanations': [AppStrings.analysisOverlapExplanation],
        },
        facts: facts,
      ),
      throwsA(isA<MoneyAnalysisException>()),
    );
  });

  test('validator rejects payloads that would mutate financial data', () async {
    final facts = factsFor();
    final analyzer = ValidatedMoneyAnalyzer(
      _JsonBackend({
        'monthly_spend': facts.monthlySpend,
        'potential_savings': facts.potentialSavings,
        'currency': facts.currencyCode,
        'mutates_data': true,
        'explanations': [AppStrings.analysisOverlapExplanation],
      }),
    );

    expect(
      () => analyzer.analyze(facts),
      throwsA(isA<MoneyAnalysisException>()),
    );
  });
}
