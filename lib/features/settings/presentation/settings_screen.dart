import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/section_header.dart';
import '../../insights/insights_providers.dart';
import '../domain/local_data_eraser.dart';
import '../settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(privacyActionProvider);
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: AppStrings.settingsTitle,
      showTabs: true,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.md,
      ),
      body: ListView(
        children: [
          const SectionHeader(title: AppStrings.privacySection),
          const SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(AppStrings.privacyPolicy, style: textTheme.titleSmall),
            onTap: () => context.push(AppRoutes.privacyPolicy),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(AppStrings.privacyMinimalCollection, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: AppStrings.yourDataSection),
          const SizedBox(height: AppSpacing.md),
          Text(AppStrings.deleteDataExplanation, style: textTheme.bodyLarge),
          if (action.error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              action.error!,
              style: textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            key: const Key('reset-dismissed-insights'),
            label: AppStrings.resetDismissedInsights,
            variant: AppButtonVariant.tertiary,
            onPressed: () =>
                ref.read(dismissedInsightsProvider.notifier).reset(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            key: const Key('delete-local-data'),
            label: AppStrings.deleteMyData,
            variant: AppButtonVariant.secondary,
            isLoading: action.isErasing,
            onPressed: action.isErasing
                ? null
                : () => _confirm(
                    context,
                    ref,
                    kind: ErasureKind.localData,
                    title: AppStrings.deleteMyDataTitle,
                    message: AppStrings.deleteMyDataMessage,
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            key: const Key('delete-account'),
            label: AppStrings.deleteAccount,
            variant: AppButtonVariant.danger,
            isLoading: action.isErasing,
            onPressed: action.isErasing
                ? null
                : () => _confirm(
                    context,
                    ref,
                    kind: ErasureKind.account,
                    title: AppStrings.deleteAccountTitle,
                    message: AppStrings.deleteAccountMessage,
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.appStoreBillingNotice, style: textTheme.bodySmall),
        ],
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context,
    WidgetRef ref, {
    required ErasureKind kind,
    required String title,
    required String message,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            AppButton(
              label: AppStrings.cancel,
              variant: AppButtonVariant.tertiary,
              expand: false,
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            AppButton(
              key: const Key('confirm-erasure'),
              label: AppStrings.delete,
              variant: AppButtonVariant.danger,
              expand: false,
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final result = await ref.read(privacyActionProvider.notifier).erase(kind);
    if (result != null && context.mounted) {
      context.go(AppRoutes.launch);
    }
  }
}
