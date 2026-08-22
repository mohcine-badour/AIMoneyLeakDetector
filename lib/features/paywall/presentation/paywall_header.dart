import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';

class PaywallHeader extends StatelessWidget {
  const PaywallHeader({required this.onDismiss, super.key});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: tokens.bgSubtle,
            shape: const CircleBorder(),
            child: InkWell(
              key: const Key('paywall-dismiss'),
              customBorder: const CircleBorder(),
              onTap: () {
                HapticFeedback.lightImpact();
                onDismiss();
              },
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  AppIcons.close,
                  size: 15,
                  color: tokens.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
