import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';

class WelcomeCta extends StatelessWidget {
  const WelcomeCta({
    required this.pending,
    required this.onPressed,
    super.key,
  });

  final bool pending;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          key: const Key('get-started'),
          onPressed: pending
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  onPressed?.call();
                },
          style: FilledButton.styleFrom(
            backgroundColor: tokens.accent,
            foregroundColor: tokens.accentText,
            disabledBackgroundColor: tokens.accent,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: pending
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: tokens.accentText,
                  ),
                )
              : Text(
                  AppStrings.getStarted,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                    color: tokens.accentText,
                  ),
                ),
        ),
      ),
    );
  }
}
