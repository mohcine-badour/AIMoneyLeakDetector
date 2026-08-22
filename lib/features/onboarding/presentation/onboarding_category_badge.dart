import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../domain/onboarding_pages.dart';
import 'onboarding_icons.dart';

class OnboardingCategoryBadge extends StatelessWidget {
  const OnboardingCategoryBadge({required this.badge, super.key});

  final OnboardingCategoryBadgeData badge;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 3, 9, 3),
      decoration: BoxDecoration(
        color: tokens.indigoBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tokens.borderIndigo, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon.data, size: 11, color: tokens.indigoText),
          const SizedBox(width: 5),
          Text(
            badge.label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
              color: tokens.indigoText,
            ),
          ),
        ],
      ),
    );
  }
}
