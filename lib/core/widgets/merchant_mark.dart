import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import '../../features/subscriptions/domain/subscription_catalog.dart';
import '../brand/brand_icon.dart';

class MerchantMark extends StatelessWidget {
  const MerchantMark({required this.name, this.size = 40, super.key});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final slug = SubscriptionCatalog.slugFor(name: name);
    return BrandIcon(
      slug: slug,
      brand: SubscriptionCatalog.brandForSlug(slug),
      size: size,
      fallbackInitial: name.trim().isEmpty ? '?' : name.trim()[0],
    );
  }
}

/// Kept for callers that still import this file for the old gray tile.
class MerchantMarkFallback extends StatelessWidget {
  const MerchantMarkFallback({required this.name, this.size = 40, super.key});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final letter = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tokens.bgMuted,
        borderRadius: BorderRadius.circular(size * 0.24),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w500,
          color: tokens.textSecondary,
          height: 1,
        ),
      ),
    );
  }
}
