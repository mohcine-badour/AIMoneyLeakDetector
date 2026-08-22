import 'package:flutter/material.dart';

import '../constants/app_icons.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import 'app_button.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    this.onRetry,
    this.retryLabel = AppStrings.retry,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.error, size: AppIcons.xl, color: colorScheme.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: retryLabel, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
