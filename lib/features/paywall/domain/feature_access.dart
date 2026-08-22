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
      entitlement.isPro || subscriptionCount < config.freeSubscriptionLimit;

  bool get canAddTrial {
    if (entitlement.isPro || !config.trialProtectionRequiresPro) {
      return true;
    }
    return trialCount < config.freeTrialLimit;
  }

  bool get canUseScanner => entitlement.isPro || !config.scannerRequiresPro;

  bool get canUseAiAnalysis =>
      entitlement.isPro || !config.aiAnalysisRequiresPro;
}
