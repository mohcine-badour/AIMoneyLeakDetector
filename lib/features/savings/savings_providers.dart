import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/clock_provider.dart';
import '../subscriptions/subscriptions_providers.dart';
import '../subscriptions/usage_controller.dart';
import '../trials/trials_providers.dart';
import 'domain/leak_engine.dart';
import 'domain/leak_recommendation.dart';

final leakRecommendationsProvider =
    Provider<AsyncValue<List<LeakRecommendation>>>((ref) {
      final subscriptions = ref.watch(subscriptionsProvider);
      final trials = ref.watch(trialsProvider);
      final usage = ref.watch(declaredUsageCountsProvider);
      final now = ref.watch(appNowProvider);

      if (subscriptions.hasError) {
        return AsyncError(
          subscriptions.error!,
          subscriptions.stackTrace ?? StackTrace.empty,
        );
      }
      if (trials.hasError) {
        return AsyncError(trials.error!, trials.stackTrace ?? StackTrace.empty);
      }
      if (usage.hasError) {
        return AsyncError(usage.error!, usage.stackTrace ?? StackTrace.empty);
      }
      if (!subscriptions.hasValue || !trials.hasValue || !usage.hasValue) {
        return const AsyncLoading();
      }
      return AsyncData(
        LeakEngine.analyze(
          subscriptions: subscriptions.requireValue,
          trials: trials.requireValue,
          now: now,
          usageBySubscriptionId: usage.requireValue,
        ),
      );
    });
