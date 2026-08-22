import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/insights_timeframe.dart';
import '../insights_providers.dart';

class InsightsHeader extends ConsumerWidget {
  const InsightsHeader({required this.onTimeframePress, super.key});

  final VoidCallback onTimeframePress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final timeframe = ref.watch(insightsTimeframeProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Row(
        children: [
          Text(
            AppStrings.insightsTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.6,
              height: 24 / 22,
              color: tokens.textPrimary,
            ),
          ),
          const Spacer(),
          Material(
            color: tokens.bgMuted,
            shape: StadiumBorder(
              side: BorderSide(color: tokens.borderStrong, width: 0.5),
            ),
            child: InkWell(
              key: const Key('timeframe-chip'),
              onTap: () {
                HapticFeedback.selectionClick();
                onTimeframePress();
              },
              customBorder: const StadiumBorder(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 5, 10, 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeframe.label,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.05,
                        color: tokens.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      AppIcons.chevronDown,
                      size: 11,
                      color: tokens.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
