import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';

class UnlockProBanner extends StatelessWidget {
  const UnlockProBanner({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Material(
        color: tokens.indigoBg,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          key: const Key('dashboard-unlock-pro'),
          onTap: () {
            HapticFeedback.selectionClick();
            onPressed();
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: tokens.borderIndigo, width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: tokens.bgApp.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    AppIcons.sparkles,
                    size: 15,
                    color: tokens.indigoText,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.unlockPro,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        AppStrings.unlockProSubtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.3,
                          color: tokens.indigoText.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(AppIcons.chevronRight, size: 16, color: tokens.indigoText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
