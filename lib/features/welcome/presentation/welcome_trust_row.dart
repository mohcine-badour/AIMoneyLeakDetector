import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';

class WelcomeTrustRow extends StatelessWidget {
  const WelcomeTrustRow({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 6,
        children: [
          _Item(
            icon: AppIcons.shieldCheck,
            iconColor: tokens.positiveText,
            label: AppStrings.dataStaysOnThisPhone,
            textColor: tokens.textMuted,
          ),
          Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              color: tokens.textMuted,
              shape: BoxShape.circle,
            ),
          ),
          _Item(
            icon: AppIcons.lock,
            iconColor: tokens.textMuted,
            label: AppStrings.privateByDefault,
            textColor: tokens.textMuted,
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.textColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: iconColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            letterSpacing: -0.05,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
