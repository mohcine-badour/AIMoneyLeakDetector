import '../domain/ad_config.dart';
import '../domain/ad_service.dart';
import 'disabled_ad_service.dart';
import 'local_ad_service.dart';

/// Chooses an ad implementation without exposing AdMob to the rest of the app.
abstract final class AdServiceFactory {
  static AdService create(AdConfig config) {
    if (!config.enabled) {
      return const DisabledAdService();
    }
    return const LocalAdService();
  }
}
