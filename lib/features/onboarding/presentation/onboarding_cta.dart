import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../domain/onboarding_pages.dart';
import 'onboarding_icons.dart';

class OnboardingCta extends StatelessWidget {
  const OnboardingCta({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final OnboardingIcon? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          key: const Key('onboarding-cta'),
          onPressed: () {
            HapticFeedback.mediumImpact();
            onPressed();
          },
          style: FilledButton.styleFrom(
            backgroundColor: tokens.accent,
            foregroundColor: tokens.accentText,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.1,
                  color: tokens.accentText,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 6),
                Icon(icon!.data, size: 14, color: tokens.accentText),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
