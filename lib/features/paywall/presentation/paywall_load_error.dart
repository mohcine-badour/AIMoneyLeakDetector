import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';

class PaywallLoadError extends StatelessWidget {
  const PaywallLoadError({
    required this.onRetry,
    required this.onDismiss,
    this.loading = false,
    super.key,
  });

  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tokens.bgSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(AppIcons.wifiOff, size: 22, color: tokens.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.offersLoadTitle,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppStrings.offersLoadMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: tokens.textSecondary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
              child: AppButton(
                label: AppStrings.retry,
                variant: AppButtonVariant.secondary,
                onPressed: onRetry,
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: AppStrings.dismiss,
              variant: AppButtonVariant.tertiary,
              onPressed: onDismiss,
            ),
          ],
        ),
      ),
    );
  }
}
