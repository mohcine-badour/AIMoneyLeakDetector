import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_cost.dart';
import '../../trials/domain/trial.dart';
import '../../trials/domain/trial_countdown.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import 'leak_copy.dart';
import 'leak_recommendation.dart';

/// Deterministic money-leak rules. Do not use AI for this.
///
/// Low-usage recommendations require a declared use count.
abstract final class LeakEngine {
  static const double expensiveMonthlyThreshold = 50;
  static const int overlappingMinimum = 2;
  static const int upcomingRenewalDays = 7;
  static const int dashboardLimit = 3;
  static const int lowUsageMax = 2;

  static List<LeakRecommendation> analyze({
    required List<Subscription> subscriptions,
    required List<Trial> trials,
    required DateTime now,
    Map<String, int> usageBySubscriptionId = const {},
  }) {
    final active = [
      for (final item in subscriptions)
        if (item.status == SubscriptionStatus.active) item,
    ];
    final currency = _currency(active);
    final recs = <LeakRecommendation>[
      ..._trialConversions(trials, now),
      ..._upcomingRenewals(active, now),
      ..._overlapping(active, currency),
      ..._duplicates(active),
      ..._expensive(active, currency),
      ..._lowUsage(active, usageBySubscriptionId),
    ];
    recs.sort((left, right) {
      final byKind = left.kind.index.compareTo(right.kind.index);
      if (byKind != 0) {
        return byKind;
      }
      return left.title.compareTo(right.title);
    });
    return recs;
  }

  static List<LeakRecommendation> preview(List<LeakRecommendation> recs) {
    return recs.take(dashboardLimit).toList();
  }

  static List<LeakRecommendation> _trialConversions(
    List<Trial> trials,
    DateTime now,
  ) {
    final items = <LeakRecommendation>[];
    for (final trial in trials) {
      final status = TrialCountdown.displayStatus(
        stored: trial.status,
        trialEndDate: trial.trialEndDate,
        now: now,
      );
      if (status == TrialStatus.cancelled || status == TrialStatus.expired) {
        continue;
      }
      final days = TrialCountdown.remainingDays(trial.trialEndDate, now);
      items.add(
        LeakRecommendation(
          kind: LeakKind.trialConversion,
          title: LeakCopy.trialTitle(
            name: trial.subscriptionName,
            days: days,
          ),
          reason: LeakCopy.trialReason(trial),
          trialId: trial.id,
        ),
      );
    }
    return items;
  }

  static List<LeakRecommendation> _upcomingRenewals(
    List<Subscription> active,
    DateTime now,
  ) {
    final items = <LeakRecommendation>[];
    for (final item in active) {
      final days = _calendarDays(item.nextBillingDate, now);
      if (days < 0 || days > upcomingRenewalDays) {
        continue;
      }
      items.add(
        LeakRecommendation(
          kind: LeakKind.upcomingRenewal,
          title: LeakCopy.renewalTitle(name: item.name, days: days),
          reason: AppStrings.leakRenewalReason,
          subscriptionId: item.id,
        ),
      );
    }
    return items;
  }

  static List<LeakRecommendation> _overlapping(
    List<Subscription> active,
    String currency,
  ) {
    final grouped = <SubscriptionCategory, List<Subscription>>{};
    for (final item in active) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    final items = <LeakRecommendation>[];
    for (final entry in grouped.entries) {
      if (entry.value.length < overlappingMinimum) {
        continue;
      }
      final monthly = entry.value.fold<double>(
        0,
        (sum, item) => sum + SubscriptionCost.monthlyEquivalent(item),
      );
      items.add(
        LeakRecommendation(
          kind: LeakKind.overlappingCategory,
          title: LeakCopy.overlappingTitle(
            amount: LeakCopy.money(monthly, currency),
            category: LeakCopy.categoryLabel(entry.key),
          ),
          reason: AppStrings.leakOverlappingReason,
        ),
      );
    }
    return items;
  }

  static List<LeakRecommendation> _duplicates(List<Subscription> active) {
    final grouped = <String, List<Subscription>>{};
    for (final item in active) {
      final key = item.merchant.trim().toLowerCase();
      grouped.putIfAbsent(key, () => []).add(item);
    }
    final items = <LeakRecommendation>[];
    for (final entry in grouped.entries) {
      if (entry.value.length < 2) {
        continue;
      }
      items.add(
        LeakRecommendation(
          kind: LeakKind.suspiciousDuplicate,
          title: LeakCopy.duplicateTitle(
            merchant: entry.value.first.merchant,
            count: entry.value.length,
          ),
          reason: AppStrings.leakDuplicateReason,
        ),
      );
    }
    return items;
  }

  static List<LeakRecommendation> _expensive(
    List<Subscription> active,
    String currency,
  ) {
    final items = <LeakRecommendation>[];
    for (final item in active) {
      final monthly = SubscriptionCost.monthlyEquivalent(item);
      if (monthly < expensiveMonthlyThreshold) {
        continue;
      }
      items.add(
        LeakRecommendation(
          kind: LeakKind.expensive,
          title: LeakCopy.expensiveTitle(
            name: item.name,
            amount: LeakCopy.money(monthly, currency),
          ),
          reason: AppStrings.leakExpensiveReason,
          subscriptionId: item.id,
        ),
      );
    }
    return items;
  }

  static List<LeakRecommendation> _lowUsage(
    List<Subscription> subscriptions,
    Map<String, int> usageBySubscriptionId,
  ) {
    final items = <LeakRecommendation>[];
    for (final item in subscriptions) {
      final uses = usageBySubscriptionId[item.id];
      if (uses == null || uses > lowUsageMax) {
        continue;
      }
      items.add(
        LeakRecommendation(
          kind: LeakKind.lowUsage,
          title: LeakCopy.lowUsageTitle(name: item.name, uses: uses),
          reason: AppStrings.leakLowUsageReason,
          subscriptionId: item.id,
        ),
      );
    }
    return items;
  }

  static int _calendarDays(DateTime date, DateTime now) {
    final target = DateTime.utc(date.year, date.month, date.day);
    final today = DateTime.utc(now.year, now.month, now.day);
    return target.difference(today).inDays;
  }

  static String _currency(List<Subscription> active) {
    final codes = {for (final item in active) item.currency};
    if (codes.length == 1) {
      return codes.first;
    }
    return MoneyFormat.defaultCurrencyCode;
  }
}
