import '../../../app/config/app_config.dart';

/// Centralized ad flags. Keep network unit IDs out of widgets.
class AdConfig {
  const AdConfig({
    this.enabled = true,
    this.useTestAds = true,
    this.bannerAdUnitId = '',
  });

  static const AdConfig defaults = AdConfig(
    enabled: AppConfig.adsEnabled,
    useTestAds: bool.fromEnvironment('ADMOB_USE_TEST_ADS', defaultValue: true),
    bannerAdUnitId: String.fromEnvironment('ADMOB_BANNER_UNIT_ID'),
  );

  static const testIosBannerUnitId = 'ca-app-pub-3940256099942544/2934735716';

  final bool enabled;
  final bool useTestAds;
  final String bannerAdUnitId;

  /// Google iOS sample unit unless a real unit is supplied and test ads are off.
  String get resolvedBannerUnitId {
    if (!useTestAds && bannerAdUnitId.isNotEmpty) {
      return bannerAdUnitId;
    }
    return testIosBannerUnitId;
  }
}
