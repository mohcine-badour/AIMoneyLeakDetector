import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import '../subscriptions/data/drift_subscription_repository.dart';
import '../subscriptions/subscriptions_providers.dart';
import 'data/local_subscribe_advice_backend.dart';
import 'data/validated_subscribe_advisor.dart';
import 'domain/subscribe_advisor.dart';
import 'domain/subscribe_impact.dart';
import 'domain/subscription_candidate.dart';

final subscribeAdvisorProvider = Provider<SubscribeAdvisor>((ref) {
  return const ValidatedSubscribeAdvisor(LocalSubscribeAdviceBackend());
});

final subscribeAdviceProvider =
    FutureProvider.family<SubscribeAdvice, SubscribeImpact>((ref, impact) {
      return ref.watch(subscribeAdvisorProvider).advise(impact);
    });

final beforeYouSubscribeControllerProvider =
    Provider<BeforeYouSubscribeController>((ref) {
      return BeforeYouSubscribeController(ref);
    });

class BeforeYouSubscribeController {
  BeforeYouSubscribeController(this._ref);

  final Ref _ref;

  Future<void> confirm(SubscriptionCandidate candidate) async {
    await _ref
        .read(subscriptionRepositoryProvider)
        .save(candidate.toSubscription());
    await _ref
        .read(analyticsProvider)
        .track(
          AnalyticsEvent.subscriptionCreated,
          properties: {'source': candidate.source.name},
        );
    _ref.invalidate(subscriptionsProvider);
  }
}
