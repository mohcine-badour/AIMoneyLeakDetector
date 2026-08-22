import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../domain/entitlement_copy.dart';
import '../domain/paywall_plan.dart';
import '../paywall_providers.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(analyticsScreenViewProvider(AnalyticsEvent.paywallViewed));
    final config = ref.watch(monetizationConfigProvider);
    final selected = ref.watch(paywallPlanProvider);
    final action = ref.watch(paywallActionProvider);
    final entitlement = ref.watch(entitlementProvider);
    final status = EntitlementCopy.status(entitlement);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      title: AppStrings.paywallTitle,
      padding: const EdgeInsets.all(AppSpacing.page),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppStrings.paywallHeadline, style: textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xl),
            Text(AppStrings.paywallUnlock, style: textTheme.titleSmall),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < config.unlockPerks.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              _PerkRow(label: config.unlockPerks[i]),
            ],
            const SizedBox(height: AppSpacing.xl),
            _PlanCard(
              key: const Key('paywall-plan-monthly'),
              label: config.monthlyPriceLabel,
              selected: selected == PaywallPlan.monthly,
              onTap: action.isBusy
                  ? null
                  : () => ref
                        .read(paywallPlanProvider.notifier)
                        .select(PaywallPlan.monthly),
            ),
            const SizedBox(height: AppSpacing.md),
            _PlanCard(
              key: const Key('paywall-plan-yearly'),
              label: config.yearlyPriceLabel,
              selected: selected == PaywallPlan.yearly,
              onTap: action.isBusy
                  ? null
                  : () => ref
                        .read(paywallPlanProvider.notifier)
                        .select(PaywallPlan.yearly),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(AppStrings.introOfferAvailable, style: textTheme.bodyLarge),
            if (status != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(status, style: textTheme.bodyLarge),
            ],
            if (action.error != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                action.error!,
                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            if (!entitlement.isPro)
              AppButton(
                key: const Key('unlock-pro'),
                label: AppStrings.unlockPro,
                isLoading: action.isPurchasing,
                onPressed: action.isBusy
                    ? null
                    : () => _purchase(context, ref, selected),
              ),
            if (!entitlement.isPro) const SizedBox(height: AppSpacing.md),
            AppButton(
              key: const Key('restore-purchases'),
              label: AppStrings.restorePurchases,
              variant: AppButtonVariant.secondary,
              isLoading: action.isRestoring,
              onPressed: action.isBusy ? null : () => _restore(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchase(
    BuildContext context,
    WidgetRef ref,
    PaywallPlan plan,
  ) async {
    final unlocked = await ref
        .read(paywallActionProvider.notifier)
        .purchase(plan);
    if (unlocked && context.mounted) {
      _leave(context);
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final unlocked = await ref.read(paywallActionProvider.notifier).restore();
    if (unlocked && context.mounted) {
      _leave(context);
    }
  }

  void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.dashboard);
  }
}

class _PerkRow extends StatelessWidget {
  const _PerkRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          AppIcons.check,
          size: AppIcons.md,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      selected: selected,
      onTap: onTap,
      child: Text(label, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
