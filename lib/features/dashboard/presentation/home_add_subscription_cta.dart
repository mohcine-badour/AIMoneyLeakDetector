import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';

class HomeAddSubscriptionCta extends StatelessWidget {
  const HomeAddSubscriptionCta({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Material(
        color: tokens.accent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          key: const Key('dashboard-add-subscription'),
          onTap: () {
            HapticFeedback.selectionClick();
            onPressed();
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: tokens.accentText.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(AppIcons.add, size: 18, color: tokens.accentText),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.addSubscriptionCta,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.1,
                          color: tokens.accentText,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        AppStrings.addFirstSubscriptionMessage,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.3,
                          color: tokens.accentText.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  AppIcons.chevronRight,
                  size: 16,
                  color: tokens.accentText.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
