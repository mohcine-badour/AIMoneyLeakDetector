import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_brand_icon.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 22),
            child: AppBrandIcon(size: 76),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              AppStrings.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.9,
                height: 33 / 30,
                color: tokens.textPrimary,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              AppStrings.tagline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.05,
                height: 21 / 14,
                color: tokens.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
