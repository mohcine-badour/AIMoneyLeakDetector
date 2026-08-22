import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/ads/data/ad_service_factory.dart';
import 'package:kichta/features/ads/data/disabled_ad_service.dart';
import 'package:kichta/features/ads/data/local_ad_service.dart';
import 'package:kichta/features/ads/domain/ad_config.dart';
import 'package:kichta/features/ads/domain/ad_placement.dart';
import 'package:kichta/features/ads/domain/ad_policy.dart';

void main() {
  test('free users only see banners on browsing screens', () {
    expect(
      AdPolicy.canShow(
        placement: AdPlacement.dashboard,
        isPro: false,
        adsEnabled: true,
      ),
      isFalse,
    );
    expect(
      AdPolicy.canShow(
        placement: AdPlacement.subscriptions,
        isPro: false,
        adsEnabled: true,
      ),
      isFalse,
    );
    expect(
      AdPolicy.canShow(
        placement: AdPlacement.trials,
        isPro: false,
        adsEnabled: true,
      ),
      isTrue,
    );
  });

  test('pro users never see ads', () {
    expect(
      AdPolicy.canShow(
        placement: AdPlacement.dashboard,
        isPro: true,
        adsEnabled: true,
      ),
      isFalse,
    );
  });

  test('sensitive financial operations never show ads', () {
    const blocked = [
      AdPlacement.addSubscription,
      AdPlacement.editSubscription,
      AdPlacement.beforeYouSubscribe,
      AdPlacement.cancellation,
      AdPlacement.paywall,
      AdPlacement.scanner,
      AdPlacement.savings,
      AdPlacement.subscriptionDetail,
      AdPlacement.trialDetail,
      AdPlacement.settings,
      AdPlacement.onboarding,
    ];
    for (final placement in blocked) {
      expect(
        AdPolicy.canShow(placement: placement, isPro: false, adsEnabled: true),
        isFalse,
        reason: '$placement must not show ads',
      );
    }
  });

  test('disabled config shows no ads', () {
    expect(
      AdPolicy.canShow(
        placement: AdPlacement.dashboard,
        isPro: false,
        adsEnabled: false,
      ),
      isFalse,
    );
    expect(
      AdServiceFactory.create(const AdConfig(enabled: false)),
      isA<DisabledAdService>(),
    );
  });

  test('factory keeps AdMob out of the rest of the app', () {
    expect(AdServiceFactory.create(const AdConfig()), isA<LocalAdService>());
  });
}
