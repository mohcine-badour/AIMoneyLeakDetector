import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../domain/onboarding_pages.dart';
import 'onboarding_icons.dart';

class OnboardingSwipeHint extends StatelessWidget {
  const OnboardingSwipeHint({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(OnboardingIcon.swipe.data, size: 11, color: tokens.textMuted),
        const SizedBox(width: 6),
        Text(
          OnboardingPages.swipeHint,
          style: TextStyle(
            fontSize: 10.5,
            letterSpacing: -0.05,
            color: tokens.textMuted,
          ),
        ),
      ],
    );
  }
}
