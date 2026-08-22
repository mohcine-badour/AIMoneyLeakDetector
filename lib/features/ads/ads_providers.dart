import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../paywall/paywall_providers.dart';
import 'data/ad_service_factory.dart';
import 'domain/ad_config.dart';
import 'domain/ad_placement.dart';
import 'domain/ad_policy.dart';
import 'domain/ad_service.dart';

final adConfigProvider = Provider<AdConfig>((ref) {
  return AdConfig.defaults;
});

final adServiceProvider = Provider<AdService>((ref) {
  return AdServiceFactory.create(ref.watch(adConfigProvider));
});

final canShowAdProvider = Provider.family<bool, AdPlacement>((ref, placement) {
  return AdPolicy.canShow(
    placement: placement,
    isPro: ref.watch(entitlementProvider).isPro,
    adsEnabled: ref.watch(adConfigProvider).enabled,
  );
});
