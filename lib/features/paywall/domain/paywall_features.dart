import 'package:flutter/material.dart';

import '../../../core/constants/app_icons.dart';

enum PaywallFeatureColor { indigo, green, pink, blue, amber, gray }

class PaywallFeature {
  const PaywallFeature({
    required this.id,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final String id;
  final IconData icon;
  final PaywallFeatureColor color;
  final String title;
  final String description;
}

class PaywallFeatureTone {
  const PaywallFeatureTone({required this.bg, required this.fg});

  final Color bg;
  final Color fg;
}

/// Mid-tone tiles that read in dark and light mode without inversion.
abstract final class PaywallFeatureColors {
  static const Map<PaywallFeatureColor, PaywallFeatureTone> values = {
    PaywallFeatureColor.indigo: PaywallFeatureTone(
      bg: Color(0x2E7F77DD),
      fg: Color(0xFF7F77DD),
    ),
    PaywallFeatureColor.green: PaywallFeatureTone(
      bg: Color(0x2E1F8F4D),
      fg: Color(0xFF3D9B6E),
    ),
    PaywallFeatureColor.pink: PaywallFeatureTone(
      bg: Color(0x2EED93B1),
      fg: Color(0xFFE56B8A),
    ),
    PaywallFeatureColor.blue: PaywallFeatureTone(
      bg: Color(0x2E4C8DDB),
      fg: Color(0xFF4C8DDB),
    ),
    PaywallFeatureColor.amber: PaywallFeatureTone(
      bg: Color(0x2EBA7517),
      fg: Color(0xFFC4841D),
    ),
    PaywallFeatureColor.gray: PaywallFeatureTone(
      bg: Color(0x147F7F7F),
      fg: Color(0xFF8A8A84),
    ),
  };

  static PaywallFeatureTone of(PaywallFeatureColor color) => values[color]!;
}

/// Ordered by conversion, not complexity. Do not alphabetize.
abstract final class PaywallFeatures {
  static const List<PaywallFeature> all = [
    PaywallFeature(
      id: 'ai_analysis',
      icon: AppIcons.sparkles,
      color: PaywallFeatureColor.indigo,
      title: 'AI money analysis',
      description: 'Ask questions, get personalized recommendations.',
    ),
    PaywallFeature(
      id: 'trial_protection',
      icon: AppIcons.shieldCheck,
      color: PaywallFeatureColor.green,
      title: 'Trial protection',
      description: 'Get reminded before free trials auto-charge.',
    ),
    PaywallFeature(
      id: 'price_monitoring',
      icon: AppIcons.bellRinging,
      color: PaywallFeatureColor.pink,
      title: 'Price monitoring',
      description: 'Know the moment Netflix ups the price again.',
    ),
    PaywallFeature(
      id: 'advanced_insights',
      icon: AppIcons.chartLine,
      color: PaywallFeatureColor.blue,
      title: 'Advanced insights',
      description: 'Year-over-year trends, category forecasts, export to CSV.',
    ),
    PaywallFeature(
      id: 'receipt_scanner',
      icon: AppIcons.scan,
      color: PaywallFeatureColor.amber,
      title: 'Receipt scanner',
      description: 'Snap a receipt or email — auto-add the subscription.',
    ),
    PaywallFeature(
      id: 'unlimited_subs',
      icon: AppIcons.infinity,
      color: PaywallFeatureColor.gray,
      title: 'Unlimited subscriptions',
      description: 'Track as many as you have — no cap, no ads.',
    ),
  ];
}
