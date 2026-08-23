import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/ad_config.dart';
import '../domain/ad_placement.dart';
import '../domain/ad_service.dart';

/// Google AdMob banners. Widgets talk to [AdService], not this type.
class AdMobAdService implements AdService {
  const AdMobAdService(this._config);

  final AdConfig _config;

  @override
  Widget banner({required AdPlacement placement, VoidCallback? onUpgrade}) {
    return _AdMobBanner(
      key: Key('ad-banner-${placement.name}'),
      adUnitId: _config.resolvedBannerUnitId,
      onUpgrade: onUpgrade,
    );
  }
}

class _AdMobBanner extends StatefulWidget {
  const _AdMobBanner({required this.adUnitId, this.onUpgrade, super.key});

  final String adUnitId;
  final VoidCallback? onUpgrade;

  @override
  State<_AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<_AdMobBanner> {
  BannerAd? _ad;
  var _ready = false;
  var _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _load();
    }
  }

  Future<void> _load() async {
    final width = MediaQuery.sizeOf(context).width.truncate();
    AdSize? size;
    try {
      size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        width,
      );
    } catch (_) {
      size = AdSize.banner;
    }
    if (!mounted) {
      return;
    }
    final ad = BannerAd(
      adUnitId: widget.adUnitId,
      size: size ?? AdSize.banner,
      request: const AdRequest(nonPersonalizedAds: true),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _ad = ad as BannerAd;
            _ready = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _ad = null;
              _ready = false;
            });
          }
        },
      ),
    );
    try {
      await ad.load();
    } catch (_) {
      ad.dispose();
      if (mounted) {
        setState(() {
          _ad = null;
          _ready = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_ready || ad == null) {
      return const SizedBox.shrink();
    }
    final tokens = AppTokens.of(context);
    return Material(
      color: tokens.bgCard,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              child: Row(
                children: [
                  Text(
                    AppStrings.adLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      color: tokens.textMuted,
                    ),
                  ),
                  const Spacer(),
                  if (widget.onUpgrade != null)
                    GestureDetector(
                      onTap: widget.onUpgrade,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        AppStrings.adRemoveHint,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: tokens.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ],
        ),
      ),
    );
  }
}
