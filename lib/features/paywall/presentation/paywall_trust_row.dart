import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';

class PaywallTrustRow extends StatelessWidget {
  const PaywallTrustRow({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final apple = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.refresh_rounded, size: 11, color: tokens.textMuted),
          const SizedBox(width: 4),
          Text(
            AppStrings.cancelAnytime,
            style: TextStyle(
              fontSize: 10.5,
              letterSpacing: -0.05,
              color: tokens.textMuted,
            ),
          ),
          Container(
            width: 3,
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: tokens.textMuted,
              shape: BoxShape.circle,
            ),
          ),
          Icon(
            apple ? AppIcons.apple : Icons.shop_outlined,
            size: 11,
            color: tokens.textMuted,
          ),
          const SizedBox(width: 4),
          Text(
            apple
                ? AppStrings.securedByAppStore
                : AppStrings.securedByGooglePlay,
            style: TextStyle(
              fontSize: 10.5,
              letterSpacing: -0.05,
              color: tokens.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
