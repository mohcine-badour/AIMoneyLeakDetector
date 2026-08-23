import 'entitlement.dart';
import 'monetization_config.dart';

/// Deterministic free/Pro gates. Do not use AI for this.
class FeatureAccess {
  const FeatureAccess({
    required this.entitlement,
    required this.config,
    required this.subscriptionCount,
    required this.trialCount,
  });

  final Entitlement entitlement;
  final MonetizationConfig config;
  final int subscriptionCount;
  final int trialCount;

  bool get canAddSubscription =>
      !config.featureGatesEnabled ||
      entitlement.isPro ||
      subscriptionCount < config.freeSubscriptionLimit;

  bool get canAddTrial {
    if (!config.featureGatesEnabled ||
        entitlement.isPro ||
        !config.trialProtectionRequiresPro) {
      return true;
    }
    return trialCount < config.freeTrialLimit;
  }

  bool get canUseScanner =>
      !config.featureGatesEnabled ||
      entitlement.isPro ||
      !config.scannerRequiresPro;

  bool get canUseAiAnalysis =>
      !config.featureGatesEnabled ||
      entitlement.isPro ||
      !config.aiAnalysisRequiresPro;
}
