import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/merchant_mark.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../cancellation_providers.dart';
import '../domain/cancellation_catalog.dart';
import '../domain/cancellation_guide.dart';
import '../domain/cancellation_message.dart';
import 'cancellation_message_dialog.dart';

class CancellationGuideScreen extends ConsumerWidget {
  const CancellationGuideScreen({required this.subscriptionId, super.key});

  final String subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      analyticsScreenViewProvider(AnalyticsEvent.cancellationGuideOpened),
    );
    final async = ref.watch(subscriptionByIdProvider(subscriptionId));

    return async.when(
      loading: () => const AppScaffold(
        title: AppStrings.cancellationGuide,
        body: LoadingState(),
      ),
      error: (error, stackTrace) => AppScaffold(
        title: AppStrings.cancellationGuide,
        body: ErrorState(
          message: AppStrings.errorLoadSubscriptions,
          onRetry: () =>
              ref.invalidate(subscriptionByIdProvider(subscriptionId)),
        ),
      ),
      data: (subscription) {
        if (subscription == null) {
          return AppScaffold(
            title: AppStrings.cancellationGuide,
            body: ErrorState(
              message: AppStrings.subscriptionNotFound,
              retryLabel: AppStrings.backToList,
              onRetry: () => context.go(AppRoutes.subscriptions),
            ),
          );
        }
        final guide = CancellationCatalog.lookup(
          merchant: subscription.merchant,
          name: subscription.name,
        );
        return _CancellationGuideBody(subscription: subscription, guide: guide);
      },
    );
  }
}

class _CancellationGuideBody extends ConsumerWidget {
  const _CancellationGuideBody({
    required this.subscription,
    required this.guide,
  });

  final Subscription subscription;
  final CancellationGuide guide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extraNotes = guide.extraNotes;

    return AppScaffold(
      title: AppStrings.cancellationGuide,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.lg,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GuideHero(
                    name: subscription.name,
                    merchantLabel: guide.merchantLabel,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _TimeChip(estimatedTime: guide.estimatedTime),
                  const SizedBox(height: AppSpacing.xl),
                  _SectionCard(
                    label: AppStrings.howToCancel,
                    body: guide.instructions,
                  ),
                  if (extraNotes != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _SectionCard(
                      label: AppStrings.goodToKnow,
                      body: extraNotes,
                      muted: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _GuideActions(
            canOpenPage: guide.canOpenPage,
            includeMessage: guide.includeMessage,
            onOpenPage: () => _openPage(context, ref),
            onGenerateMessage: () => _showMessage(context),
          ),
        ],
      ),
    );
  }

  Future<void> _openPage(BuildContext context, WidgetRef ref) async {
    final uri = guide.officialUrl;
    if (uri == null) {
      return;
    }
    HapticFeedback.mediumImpact();
    final opened = await ref.read(cancellationLinkOpenerProvider).open(uri);
    if (!context.mounted) {
      return;
    }
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.cancellationOpenFailed)),
      );
    }
  }

  Future<void> _showMessage(BuildContext context) {
    HapticFeedback.selectionClick();
    final message = CancellationMessage.compose(
      merchant: subscription.merchant,
      subscriptionName: subscription.name,
      nextBillingDate: subscription.nextBillingDate,
    );
    return showCancellationMessageDialog(context: context, message: message);
  }
}

class _GuideHero extends StatelessWidget {
  const _GuideHero({required this.name, required this.merchantLabel});

  final String name;
  final String merchantLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MerchantMark(name: name, size: AppSpacing.brandMark),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                merchantLabel,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.4,
                  height: 1.15,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.cancellationDidNotHappen,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: tokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.estimatedTime});

  final String estimatedTime;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
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
          Icon(AppIcons.trials, size: 14, color: tokens.indigoText),
          const SizedBox(width: 6),
          Text(
            AppStrings.cancellationEstimatedTime,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: tokens.indigoText.withValues(alpha: 0.85),
            ),
          ),
          Text(
            '  ·  ',
            style: TextStyle(fontSize: 12, color: tokens.indigoText),
          ),
          Text(
            estimatedTime,
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.label,
    required this.body,
    this.muted = false,
  });

  final String label;
  final String body;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: muted ? tokens.bgSubtle : tokens.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 15,
              height: 1.45,
              fontWeight: FontWeight.w400,
              color: tokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideActions extends StatelessWidget {
  const _GuideActions({
    required this.canOpenPage,
    required this.includeMessage,
    required this.onOpenPage,
    required this.onGenerateMessage,
  });

  final bool canOpenPage;
  final bool includeMessage;
  final VoidCallback onOpenPage;
  final VoidCallback onGenerateMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canOpenPage)
          _GuideButton(
            key: const Key('open-cancellation-page'),
            label: AppStrings.openCancellationPage,
            filled: true,
            icon: AppIcons.arrowRight,
            onPressed: onOpenPage,
          ),
        if (canOpenPage && includeMessage)
          const SizedBox(height: AppSpacing.sm),
        if (includeMessage)
          _GuideButton(
            key: const Key('generate-cancellation-message'),
            label: AppStrings.generateCancellationMessage,
            filled: !canOpenPage,
            onPressed: onGenerateMessage,
          ),
      ],
    );
  }
}

class _GuideButton extends StatelessWidget {
  const _GuideButton({
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
    final text = Text(
      label,
      style: TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1,
        color: filled ? tokens.accentText : tokens.textPrimary,
      ),
    );
    final child = icon == null
        ? text
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              text,
              const SizedBox(width: 6),
              Icon(
                icon,
                size: 16,
                color: filled ? tokens.accentText : tokens.textPrimary,
              ),
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
