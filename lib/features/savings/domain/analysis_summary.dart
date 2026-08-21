import '../../subscriptions/domain/subscription.dart';
import 'leak_engine.dart';
import 'leak_recommendation.dart';

class AnalysisSummary {
  const AnalysisSummary({
    required this.subscriptionsToReview,
    required this.possibleOverlaps,
    required this.upcomingExpensiveRenewals,
  });

  final int subscriptionsToReview;
  final int possibleOverlaps;
  final int upcomingExpensiveRenewals;
}

/// Deterministic report counts. Do not use AI for this.
abstract final class AnalysisSummaryCalculator {
  static AnalysisSummary from({
    required List<Subscription> subscriptions,
    required List<LeakRecommendation> recommendations,
  }) {
    final active = [
      for (final item in subscriptions)
        if (item.status == SubscriptionStatus.active) item,
    ];
    final ids = <String>{
      for (final rec in recommendations)
        if (rec.subscriptionId != null) rec.subscriptionId!,
    };

    final byCategory = <SubscriptionCategory, List<Subscription>>{};
    final byMerchant = <String, List<Subscription>>{};
    for (final item in active) {
      byCategory.putIfAbsent(item.category, () => []).add(item);
      final key = item.merchant.trim().toLowerCase();
      byMerchant.putIfAbsent(key, () => []).add(item);
    }
    for (final group in byCategory.values) {
      if (group.length >= LeakEngine.overlappingMinimum) {
        ids.addAll(group.map((item) => item.id));
      }
    }
    for (final group in byMerchant.values) {
      if (group.length >= 2) {
        ids.addAll(group.map((item) => item.id));
      }
    }

    final upcoming = {
      for (final rec in recommendations)
        if (rec.kind == LeakKind.upcomingRenewal && rec.subscriptionId != null)
          rec.subscriptionId!,
    };
    final expensive = {
      for (final rec in recommendations)
        if (rec.kind == LeakKind.expensive && rec.subscriptionId != null)
          rec.subscriptionId!,
    };

    return AnalysisSummary(
      subscriptionsToReview: ids.length,
      possibleOverlaps: recommendations
          .where((rec) => rec.kind == LeakKind.overlappingCategory)
          .length,
      upcomingExpensiveRenewals: upcoming.intersection(expensive).length,
    );
  }
}
