import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../paywall/paywall_navigation.dart';
import '../ads_providers.dart';
import '../domain/ad_placement.dart';

class AdBannerSlot extends ConsumerWidget {
  const AdBannerSlot({required this.placement, super.key});

  final AdPlacement placement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(canShowAdProvider(placement))) {
      return const SizedBox.shrink();
    }
    return ref
        .watch(adServiceProvider)
        .banner(
          placement: placement,
          onUpgrade: () => PaywallNavigation.paywall(context),
        );
  }
}
