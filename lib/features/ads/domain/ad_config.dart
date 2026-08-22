import '../../../app/config/app_config.dart';

/// Centralized ad flags. Keep network unit IDs out of widgets.
class AdConfig {
  const AdConfig({this.enabled = true, this.bannerAdUnitId = ''});

  static const AdConfig defaults = AdConfig(
    enabled: AppConfig.adsEnabled,
    bannerAdUnitId: String.fromEnvironment('ADMOB_BANNER_UNIT_ID'),
  );

  final bool enabled;

  /// Optional AdMob banner unit ID. Widgets never read this.
  final String bannerAdUnitId;
}
