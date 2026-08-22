import 'ad_placement.dart';

/// Deterministic ad rules. Do not use AI for this.
///
/// Only lightweight banners on browsing screens. No interstitials. No ads
/// during financial operations.
abstract final class AdPolicy {
  static const Set<AdPlacement> allowedPlacements = {
    AdPlacement.trials,
    AdPlacement.upcoming,
  };

  static bool canShow({
    required AdPlacement placement,
    required bool isPro,
    required bool adsEnabled,
  }) {
    if (!adsEnabled || isPro) {
      return false;
    }
    return allowedPlacements.contains(placement);
  }
}
