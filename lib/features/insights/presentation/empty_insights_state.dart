import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../paywall/paywall_navigation.dart';

class EmptyInsightsState extends ConsumerWidget {
  const EmptyInsightsState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: tokens.bgSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.chartLine,
                size: 24,
                color: tokens.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.insightsComing,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                AppStrings.insightsEmptyMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: tokens.textSecondary),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 220,
              child: AppButton(
                key: const Key('insights-add'),
                label: AppStrings.addSubscriptionCta,
                onPressed: () =>
                    PaywallNavigation.addSubscription(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
