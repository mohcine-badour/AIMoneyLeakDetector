import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_icon.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../domain/subscription.dart';
import '../domain/subscription_brand.dart';
import '../domain/subscription_cost.dart';
import '../subscription_detail_controller.dart';
import '../subscriptions_providers.dart';
import 'subscription_labels.dart';
import 'subscription_usage_card.dart';

class SubscriptionDetailScreen extends ConsumerWidget {
  const SubscriptionDetailScreen({required this.subscriptionId, super.key});

  final String subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(subscriptionByIdProvider(subscriptionId));

    return async.when(
      loading: () => const AppScaffold(
        title: AppStrings.subscriptionDetailTitle,
        body: LoadingState(),
      ),
      error: (error, stackTrace) => AppScaffold(
        title: AppStrings.subscriptionDetailTitle,
        body: ErrorState(
          message: AppStrings.errorLoadSubscriptions,
          onRetry: () =>
              ref.invalidate(subscriptionByIdProvider(subscriptionId)),
        ),
      ),
      data: (subscription) {
        if (subscription == null) {
          return AppScaffold(
            title: AppStrings.subscriptionDetailTitle,
            body: ErrorState(
              message: AppStrings.subscriptionNotFound,
              retryLabel: AppStrings.backToList,
              onRetry: () => context.go(AppRoutes.subscriptions),
            ),
          );
        }
        return _SubscriptionDetailBody(subscription: subscription);
      },
    );
  }
}

class _SubscriptionDetailBody extends ConsumerWidget {
  const _SubscriptionDetailBody({required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(appNowProvider);
    final billed =
        '${MoneyFormat.format(subscription.amount, currencyCode: subscription.currency)}${subscription.billingCycle.compactPeriod}';
    final monthly = SubscriptionCost.monthlyEquivalent(subscription);
    final annual = SubscriptionCost.annualEquivalent(subscription);
    final category = SubscriptionBrand.categoryFor(subscription).label;

    return AppScaffold(
      title: subscription.name,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.lg,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailHero(
              subscription: subscription,
              billed: billed,
              category: category,
            ),
            const SizedBox(height: AppSpacing.lg),
            _NextBillChip(date: subscription.nextBillingDate, now: now),
            const SizedBox(height: AppSpacing.lg),
            _CostCard(
              monthly: monthly,
              annual: annual,
              currencyCode: subscription.currency,
            ),
            const SizedBox(height: AppSpacing.lg),
            _DetailButton(
              label: AppStrings.cancellationGuide,
              filled: true,
              icon: AppIcons.arrowRight,
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.push(
                  AppRoutes.cancellationGuideLocation(subscription.id),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            _DetailsCard(subscription: subscription),
            const SizedBox(height: AppSpacing.md),
            SubscriptionUsageCard(subscription: subscription),
            const SizedBox(height: AppSpacing.lg),
            _DetailButton(
              label: AppStrings.edit,
              filled: false,
              onPressed: () => context.push(
                AppRoutes.editSubscriptionLocation(subscription.id),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _DetailButton(
              key: subscription.status == SubscriptionStatus.paused
                  ? const Key('resume-subscription')
                  : const Key('pause-subscription'),
              label: subscription.status == SubscriptionStatus.paused
                  ? AppStrings.resume
                  : AppStrings.pause,
              filled: false,
              onPressed: () => _togglePause(ref),
            ),
            const SizedBox(height: 4),
            _DeleteButton(onPressed: () => _confirmDelete(context, ref)),
          ],
        ),
      ),
    );
  }

  Future<void> _togglePause(WidgetRef ref) {
    HapticFeedback.selectionClick();
    final next = subscription.status == SubscriptionStatus.paused
        ? SubscriptionStatus.active
        : SubscriptionStatus.paused;
    return ref
        .read(subscriptionDetailControllerProvider)
        .setStatus(subscription.id, next);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.deleteSubscriptionTitle),
          content: const Text(AppStrings.deleteSubscriptionMessage),
          actions: [
            AppButton(
              label: AppStrings.cancel,
              expand: false,
              variant: AppButtonVariant.tertiary,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            AppButton(
              label: AppStrings.delete,
              expand: false,
              variant: AppButtonVariant.danger,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await ref
        .read(subscriptionDetailControllerProvider)
        .delete(subscription.id);
    if (context.mounted) {
      context.go(AppRoutes.subscriptions);
    }
  }
}

class _DetailHero extends StatelessWidget {
  const _DetailHero({
    required this.subscription,
    required this.billed,
    required this.category,
  });

  final Subscription subscription;
  final String billed;
  final String category;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BrandIcon(
          slug: SubscriptionBrand.slugFor(subscription),
          size: AppSpacing.brandMark,
          fallbackInitial: subscription.name.trim().isEmpty
              ? '?'
              : subscription.name.trim()[0],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                billed,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.4,
                  height: 1.15,
                  color: tokens.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _MetaChip(label: subscription.billingCycle.label),
                  _MetaChip(label: category),
                  if (subscription.status == SubscriptionStatus.paused)
                    _MetaChip(
                      label: AppStrings.pausedLabel,
                      tone: _ChipTone.warning,
                    ),
                  if (subscription.status == SubscriptionStatus.cancelled)
                    _MetaChip(
                      label: AppStrings.trialCancelled,
                      tone: _ChipTone.danger,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _ChipTone { muted, warning, danger }

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, this.tone = _ChipTone.muted});

  final String label;
  final _ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final (Color bg, Color fg, Color border) = switch (tone) {
      _ChipTone.muted => (tokens.bgMuted, tokens.textSecondary, tokens.border),
      _ChipTone.warning => (
        tokens.warningBg,
        tokens.warningText,
        tokens.borderWarning,
      ),
      _ChipTone.danger => (
        tokens.dangerBg,
        tokens.dangerText,
        tokens.borderDanger,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}

class _NextBillChip extends StatelessWidget {
  const _NextBillChip({required this.date, required this.now});

  final DateTime date;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final relative = AppDateFormat.relative(date, now);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
      decoration: BoxDecoration(
        color: tokens.indigoBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tokens.borderIndigo, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.upcoming, size: 14, color: tokens.indigoText),
          const SizedBox(width: 6),
          Text(
            AppStrings.nextPayment,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: tokens.indigoText.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            relative.isEmpty ? AppDateFormat.monthDayShort(date) : relative,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: tokens.indigoText,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostCard extends StatelessWidget {
  const _CostCard({
    required this.monthly,
    required this.annual,
    required this.currencyCode,
  });

  final double monthly;
  final double annual;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: tokens.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CostColumn(
              label: AppStrings.fieldMonthlyEquivalent,
              amount: monthly,
              suffix: AppStrings.compactPerMonth,
              currencyCode: currencyCode,
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 0.5, height: 52, color: tokens.border),
          const SizedBox(width: 16),
          Expanded(
            child: _CostColumn(
              label: AppStrings.annualLabel,
              amount: annual,
              suffix: AppStrings.compactPerYear,
              currencyCode: currencyCode,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostColumn extends StatelessWidget {
  const _CostColumn({
    required this.label,
    required this.amount,
    required this.suffix,
    required this.currencyCode,
  });

  final String label;
  final double amount;
  final String suffix;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: tokens.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          MoneyFormat.format(amount, currencyCode: currencyCode),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.4,
            color: tokens.textPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          suffix,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: tokens.textMuted,
          ),
        ),
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final rows = [
      (AppStrings.fieldMerchant, subscription.merchant),
      (
        AppStrings.fieldAmount,
        MoneyFormat.format(
          subscription.amount,
          currencyCode: subscription.currency,
        ),
      ),
      (
        AppStrings.fieldNextBillingDate,
        AppDateFormat.short(subscription.nextBillingDate),
      ),
      (AppStrings.fieldCreated, AppDateFormat.short(subscription.createdAt)),
      (AppStrings.fieldSource, subscription.source.label),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: tokens.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.details.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++) ...[
            _DetailRow(label: rows[i].$1, value: rows[i].$2),
            if (i != rows.length - 1) Divider(height: 1, color: tokens.border),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: tokens.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: tokens.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailButton extends StatelessWidget {
  const _DetailButton({
    required this.label,
    required this.filled,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final bool filled;
  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final color = filled ? tokens.accentText : tokens.textPrimary;
    final text = Text(
      label,
      style: TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
        color: color,
      ),
    );
    final child = icon == null
        ? text
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text,
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: color),
            ],
          );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );

    if (filled) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: tokens.accent,
            foregroundColor: tokens.accentText,
            minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
            shape: shape,
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.textPrimary,
          backgroundColor: tokens.bgMuted,
          side: BorderSide(color: tokens.borderStrong),
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: shape,
        ),
        child: child,
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return TextButton(
      onPressed: onPressed,
      child: Text(
        AppStrings.delete,
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: tokens.dangerText,
        ),
      ),
    );
  }
}
