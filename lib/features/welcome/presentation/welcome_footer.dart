import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';

class WelcomeFooter extends StatelessWidget {
  const WelcomeFooter({
    required this.onSignIn,
    required this.onTerms,
    required this.onPrivacy,
    super.key,
  });

  final VoidCallback onSignIn;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              Text(
                AppStrings.alreadyHaveAccount,
                style: TextStyle(fontSize: 12, color: tokens.textMuted),
              ),
              GestureDetector(
                key: const Key('welcome-sign-in'),
                behavior: HitTestBehavior.opaque,
                onTap: onSignIn,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    AppStrings.signIn,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.05,
              height: 15.5 / 10.5,
              color: tokens.textMuted,
            ),
            children: [
              const TextSpan(text: '${AppStrings.legalContinuingPrefix} '),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: _LegalLink(
                  key: const Key('welcome-terms'),
                  label: AppStrings.terms,
                  color: tokens.textMuted,
                  onTap: onTerms,
                ),
              ),
              const TextSpan(text: ' ${AppStrings.legalAnd} '),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: _LegalLink(
                  key: const Key('welcome-privacy'),
                  label: AppStrings.privacyPolicy,
                  color: tokens.textMuted,
                  onTap: onPrivacy,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  const _LegalLink({
    required this.label,
    required this.color,
    required this.onTap,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.05,
          height: 15.5 / 10.5,
          color: color,
          decoration: TextDecoration.underline,
          decorationColor: color.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}
