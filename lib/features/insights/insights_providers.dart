import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/clock_provider.dart';
import '../../core/providers/shared_preferences_provider.dart';
import '../subscriptions/subscriptions_providers.dart';
import 'domain/category_breakdown.dart';
import 'domain/insight_item.dart';
import 'domain/insight_list.dart';
import 'domain/insights_timeframe.dart';
import 'domain/spend_metrics.dart';
import 'domain/top_by_cost.dart';

final insightsTimeframeProvider =
    NotifierProvider<InsightsTimeframeController, InsightsTimeframe>(
      InsightsTimeframeController.new,
    );

final dismissedInsightsProvider =
    NotifierProvider<DismissedInsightsController, Set<String>>(
      DismissedInsightsController.new,
    );

/// Last-opened dates are not stored on Subscription. Empty until a source exists.
final insightLastOpenedByIdProvider = Provider<Map<String, DateTime>>(
  (ref) => const {},
);

/// Previous prices are not stored. Empty until a source exists.
final insightPreviousAmountByIdProvider = Provider<Map<String, double>>(
  (ref) => const {},
);

final spendMetricsProvider = Provider<SpendMetrics>((ref) {
  final subscriptions = ref.watch(subscriptionsProvider).asData?.value ?? [];
  final timeframe = ref.watch(insightsTimeframeProvider);
  final now = ref.watch(appNowProvider);
  return SpendMetrics.from(
    subscriptions: subscriptions,
    timeframe: timeframe,
    now: now,
  );
});

final categoryBreakdownProvider = Provider<CategoryBreakdown>((ref) {
  final subscriptions = ref.watch(subscriptionsProvider).asData?.value ?? [];
  final timeframe = ref.watch(insightsTimeframeProvider);
  final now = ref.watch(appNowProvider);
  return CategoryBreakdown.from(
    subscriptions: subscriptions,
    timeframe: timeframe,
    now: now,
  );
});

final topByCostProvider = Provider<TopByCost>((ref) {
  final subscriptions = ref.watch(subscriptionsProvider).asData?.value ?? [];
  return TopByCost.from(subscriptions);
});

final insightListProvider = Provider<List<InsightItem>>((ref) {
  final subscriptions = ref.watch(subscriptionsProvider).asData?.value ?? [];
  final dismissed = ref.watch(dismissedInsightsProvider);
  final now = ref.watch(appNowProvider);
  return InsightListResolver.resolve(
    subscriptions,
    now: now,
    dismissedIds: dismissed,
    lastOpenedById: ref.watch(insightLastOpenedByIdProvider),
    previousAmountById: ref.watch(insightPreviousAmountByIdProvider),
  );
});

class InsightsTimeframeController extends Notifier<InsightsTimeframe> {
  static const storageKey = 'insights/timeframe';

  @override
  InsightsTimeframe build() {
    final raw = ref.watch(sharedPreferencesProvider).getString(storageKey);
    return _parse(raw);
  }

  void setTimeframe(InsightsTimeframe timeframe) {
    state = timeframe;
    ref.read(sharedPreferencesProvider).setString(storageKey, timeframe.name);
  }

  static InsightsTimeframe _parse(String? raw) {
    for (final value in InsightsTimeframe.values) {
      if (value.name == raw) {
        return value;
      }
    }
    return InsightsTimeframe.month;
  }
}

class DismissedInsightsController extends Notifier<Set<String>> {
  static const storageKey = 'insights/dismissed';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  Set<String> build() {
    final raw = ref.watch(sharedPreferencesProvider).getStringList(storageKey);
    return {...?raw};
  }

  void dismiss(String id) {
    state = {...state, id};
    _prefs.setStringList(storageKey, state.toList());
  }

  void reset() {
    state = {};
    _prefs.remove(storageKey);
  }
}
