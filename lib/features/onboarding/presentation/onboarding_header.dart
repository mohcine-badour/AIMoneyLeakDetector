import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../domain/onboarding_pages.dart';
import 'onboarding_progress_pills.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    required this.currentIndex,
    required this.totalPages,
    required this.onSkip,
    required this.onPillPress,
    this.onBack,
    super.key,
  });

  final int currentIndex;
  final int totalPages;
  final VoidCallback? onBack;
  final VoidCallback onSkip;
  final ValueChanged<int> onPillPress;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
      child: Row(
        children: [
          if (onBack != null)
            _RoundBackButton(onPressed: onBack!)
          else
            const SizedBox(width: 32, height: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Center(
              child: OnboardingProgressPills(
                currentIndex: currentIndex,
                totalPages: totalPages,
                onPillPress: onPillPress,
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            key: const Key('onboarding-skip'),
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: tokens.textMuted,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              OnboardingPages.skip,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.05,
                color: tokens.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  const _RoundBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        color: tokens.textPrimary.withValues(alpha: 0.05),
        shape: const CircleBorder(),
        child: InkWell(
          key: const Key('onboarding-back'),
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(
            AppIcons.chevronLeft,
            size: 15,
            color: tokens.textPrimary,
          ),
        ),
      ),
    );
  }
}
