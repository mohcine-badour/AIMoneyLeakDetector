import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

class OnboardingProgressPills extends StatelessWidget {
  const OnboardingProgressPills({
    required this.currentIndex,
    required this.totalPages,
    required this.onPillPress,
    super.key,
  });

  final int currentIndex;
  final int totalPages;
  final ValueChanged<int> onPillPress;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final inactive = dark
        ? const Color(0x26FFFFFF)
        : const Color(0x1F000000);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < totalPages; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          _Pill(
            index: i,
            currentIndex: currentIndex,
            activeColor: tokens.textPrimary,
            completedColor: tokens.textPrimary.withValues(alpha: 0.4),
            inactiveColor: inactive,
            onPressed: () => onPillPress(i),
          ),
        ],
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.index,
    required this.currentIndex,
    required this.activeColor,
    required this.completedColor,
    required this.inactiveColor,
    required this.onPressed,
  });

  final int index;
  final int currentIndex;
  final Color activeColor;
  final Color completedColor;
  final Color inactiveColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final active = index == currentIndex;
    final completed = index < currentIndex;
    return GestureDetector(
      key: Key('onboarding-pill-$index'),
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          width: active ? 22 : 18,
          height: 3,
          decoration: BoxDecoration(
            color: active
                ? activeColor
                : completed
                ? completedColor
                : inactiveColor,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
