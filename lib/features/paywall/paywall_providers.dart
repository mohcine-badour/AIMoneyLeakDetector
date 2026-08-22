import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import '../subscriptions/subscriptions_providers.dart';
import '../trials/trials_providers.dart';
import 'data/unconfigured_billing_client.dart';
import 'domain/billing_client.dart';
import 'domain/billing_copy.dart';
import 'domain/billing_exception.dart';
import 'domain/entitlement.dart';
import 'domain/feature_access.dart';
import 'domain/monetization_config.dart';
import 'domain/paywall_offerings.dart';
import 'domain/paywall_plan.dart';

final monetizationConfigProvider = Provider<MonetizationConfig>((ref) {
  return MonetizationConfig.defaults;
});

/// Production overrides this with [RevenueCatBillingClient] when a public SDK
/// key is present. The default never grants Pro from the client.
final billingClientProvider = Provider<BillingClient>((ref) {
  return const UnconfiguredBillingClient();
});

final liveEntitlementProvider =
    NotifierProvider<LiveEntitlementController, Entitlement>(
      LiveEntitlementController.new,
    );

final entitlementProvider = Provider<Entitlement>((ref) {
  return ref.watch(liveEntitlementProvider);
});

final featureAccessProvider = Provider<FeatureAccess>((ref) {
  return FeatureAccess(
    entitlement: ref.watch(entitlementProvider),
    config: ref.watch(monetizationConfigProvider),
    subscriptionCount:
        ref.watch(subscriptionsProvider).asData?.value.length ?? 0,
    trialCount: ref.watch(trialsProvider).asData?.value.length ?? 0,
  );
});

final paywallOfferingsProvider = Provider<PaywallOfferings>((ref) {
  return PaywallOfferings.fromConfig(ref.watch(monetizationConfigProvider));
});

final paywallPlanProvider =
    NotifierProvider<PaywallPlanController, PaywallPlan>(
      PaywallPlanController.new,
      isAutoDispose: true,
    );

final paywallActionProvider =
    NotifierProvider<PaywallActionController, PaywallActionState>(
      PaywallActionController.new,
      isAutoDispose: true,
    );

class LiveEntitlementController extends Notifier<Entitlement> {
  @override
  Entitlement build() {
    final billing = ref.watch(billingClientProvider);
    final sub = billing.entitlements().listen((entitlement) {
      state = entitlement;
    });
    ref.onDispose(sub.cancel);
    return billing.current;
  }
}

class PaywallPlanController extends Notifier<PaywallPlan> {
  @override
  PaywallPlan build() => PaywallPlan.yearly;

  void select(PaywallPlan plan) {
    state = plan;
  }
}

class PaywallActionState {
  const PaywallActionState({
    this.isPurchasing = false,
    this.isRestoring = false,
    this.error,
  });

  final bool isPurchasing;
  final bool isRestoring;
  final String? error;

  bool get isBusy => isPurchasing || isRestoring;
}

class PaywallActionController extends Notifier<PaywallActionState> {
  @override
  PaywallActionState build() => const PaywallActionState();

  Future<bool> purchase(PaywallPlan plan) async {
    await ref
        .read(analyticsProvider)
        .track(AnalyticsEvent.purchaseStarted, properties: {'plan': plan.name});
    final success = await _run(
      busy: (error) => PaywallActionState(isPurchasing: true, error: error),
      action: () => ref.read(billingClientProvider).purchase(plan),
      emptyRestore: false,
    );
    if (success || state.error != null) {
      await ref
          .read(analyticsProvider)
          .track(
            AnalyticsEvent.purchaseCompleted,
            properties: {'plan': plan.name, 'success': success},
          );
    }
    return success;
  }

  Future<bool> restore() async {
    final success = await _run(
      busy: (error) => PaywallActionState(isRestoring: true, error: error),
      action: () => ref.read(billingClientProvider).restore(),
      emptyRestore: true,
    );
    await ref
        .read(analyticsProvider)
        .track(
          AnalyticsEvent.purchaseRestored,
          properties: {'success': success},
        );
    return success;
  }

  Future<bool> _run({
    required PaywallActionState Function(String? error) busy,
    required Future<void> Function() action,
    required bool emptyRestore,
  }) async {
    state = busy(null);
    try {
      await action();
      if (emptyRestore && !ref.read(billingClientProvider).current.isPro) {
        state = const PaywallActionState(error: AppStrings.restoreNone);
        return false;
      }
      state = const PaywallActionState();
      return true;
    } on BillingException catch (error) {
      if (error.isCancelled) {
        state = const PaywallActionState();
        return false;
      }
      state = PaywallActionState(error: BillingCopy.forException(error));
      return false;
    }
  }
}
