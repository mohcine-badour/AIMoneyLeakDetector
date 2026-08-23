import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_config.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../cancellation/cancellation_providers.dart';
import '../../notifications/notifications_providers.dart';
import '../../paywall/domain/entitlement_copy.dart';
import '../../paywall/domain/paywall_source.dart';
import '../../paywall/paywall_navigation.dart';
import '../../paywall/paywall_providers.dart';
import '../domain/local_data_eraser.dart';
import '../settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = ref.watch(privacyActionProvider);
    final gatesEnabled = ref
        .watch(monetizationConfigProvider)
        .featureGatesEnabled;
    final entitlement = ref.watch(entitlementProvider);
    final tokens = AppTokens.of(context);

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
          if (gatesEnabled) ...[
            _SectionLabel(AppStrings.planSection),
            const SizedBox(height: AppSpacing.sm),
            _PlanCard(
              isPro: entitlement.isPro,
              status: EntitlementCopy.status(entitlement),
              onUnlock: () {
                HapticFeedback.selectionClick();
                PaywallNavigation.paywall(
                  context,
                  source: PaywallSource.settings,
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            _SettingsCard(
              children: [
                _SettingsRow(
                  key: const Key('manage-subscription'),
                  icon: AppIcons.apple,
                  title: AppStrings.manageSubscription,
                  chevron: true,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(cancellationLinkOpenerProvider)
                        .open(Uri.parse(AppConfig.manageSubscriptionUrl));
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          _SectionLabel(AppStrings.remindersSection),
          const SizedBox(height: AppSpacing.sm),
          _SettingsCard(
            children: [
              _RemindersToggle(),
              Divider(height: 1, color: tokens.border),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Text(
                  AppStrings.remindersExplanation,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: tokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionLabel(AppStrings.privacySection),
          const SizedBox(height: AppSpacing.sm),
          _SettingsCard(
            children: [
              _SettingsRow(
                icon: AppIcons.lock,
                title: AppStrings.privacyPolicy,
                chevron: true,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push(AppRoutes.privacyPolicy);
                },
              ),
              Divider(height: 1, color: tokens.border),
              _SettingsRow(
                icon: AppIcons.info,
                title: AppStrings.termsOfUseTitle,
                chevron: true,
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.push(AppRoutes.termsOfUse);
                },
              ),
              Divider(height: 1, color: tokens.border),
              _SettingsRow(
                key: const Key('settings-support'),
                icon: AppIcons.mail,
                title: AppStrings.support,
                chevron: true,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(cancellationLinkOpenerProvider)
                      .open(Uri.parse(AppConfig.supportUrl));
                },
              ),
              Divider(height: 1, color: tokens.border),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Text(
                  AppStrings.privacyMinimalCollection,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: tokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionLabel(AppStrings.yourDataSection),
          const SizedBox(height: AppSpacing.sm),
          _SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                child: Text(
                  AppStrings.deleteDataExplanation,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: tokens.textSecondary,
                  ),
                ),
              ),
              if (action.error != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                  child: Text(
                    action.error!,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: tokens.dangerText,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
                child: AppButton(
                  key: const Key('delete-local-data'),
                  label: AppStrings.deleteMyData,
                  variant: AppButtonVariant.danger,
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Text(
                  AppStrings.appStoreBillingNotice,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: tokens.textMuted,
                  ),
                ),
              ),
            ],
          ),
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
    HapticFeedback.selectionClick();
    final confirmed = await showConfirmDialog(
      context: context,
      title: title,
      message: message,
      confirmKey: const Key('confirm-erasure'),
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

class _RemindersToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final enabled = ref.watch(remindersEnabledProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: tokens.bgMuted,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              AppIcons.bellRinging,
              size: 16,
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppStrings.remindersToggle,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.15,
                color: tokens.textPrimary,
              ),
            ),
          ),
          Switch.adaptive(
            key: const Key('reminders-toggle'),
            value: enabled,
            activeTrackColor: tokens.accent,
            onChanged: (value) async {
              HapticFeedback.selectionClick();
              if (value) {
                final allowed = await ref
                    .read(remindersEnabledProvider.notifier)
                    .enable();
                if (!allowed && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.reminderPermissionDenied),
                    ),
                  );
                }
              } else {
                await ref.read(remindersEnabledProvider.notifier).disable();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: tokens.textMuted,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tokens.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.isPro,
    required this.status,
    required this.onUnlock,
  });

  final bool isPro;
  final String? status;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final title = isPro ? AppStrings.paywallProBadge : AppStrings.unlockPro;
    final subtitle = isPro
        ? (status ?? AppStrings.alreadyPro)
        : (status ?? AppStrings.unlockProSubtitle);

    return Material(
      color: tokens.indigoBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: isPro ? null : const Key('settings-unlock-pro'),
        onTap: isPro ? null : onUnlock,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
                      title,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        color: tokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: tokens.indigoText.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isPro)
                Icon(AppIcons.chevronRight, size: 16, color: tokens.indigoText),
            ],
          ),
        ),
      ),
    );
  }
}

enum _RowTone { normal, danger }

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.chevron = false,
    this.enabled = true,
    this.loading = false,
    this.tone = _RowTone.normal,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool chevron;
  final bool enabled;
  final bool loading;
  final _RowTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final fg = tone == _RowTone.danger ? tokens.dangerText : tokens.textPrimary;
    final iconBg = tone == _RowTone.danger ? tokens.dangerBg : tokens.bgMuted;
    final iconFg = tone == _RowTone.danger
        ? tokens.dangerText
        : tokens.textSecondary;

    return InkWell(
      onTap: enabled && !loading ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 16, color: iconFg),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.15,
                  color: fg,
                ),
              ),
            ),
            if (loading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: tokens.textMuted,
                ),
              )
            else if (chevron)
              Icon(AppIcons.chevronRight, size: 16, color: tokens.textMuted),
          ],
        ),
      ),
    );
  }
}
