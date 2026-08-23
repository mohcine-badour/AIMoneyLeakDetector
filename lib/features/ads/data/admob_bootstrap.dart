import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/ad_config.dart';

/// Starts AdMob without blocking the first frame if Google is slow.
abstract final class AdMobBootstrap {
  static Future<void> initialize(AdConfig config) async {
    if (!config.enabled) {
      return;
    }
    try {
      await MobileAds.instance.initialize();
    } catch (_) {
      // Ads stay hidden if the SDK cannot start.
    }
  }
}
