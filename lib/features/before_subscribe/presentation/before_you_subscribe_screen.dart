import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../paywall/domain/paywall_source.dart';
import '../../paywall/paywall_providers.dart';
import '../../savings/domain/leak_copy.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../before_subscribe_providers.dart';
import '../domain/subscribe_impact.dart';
import '../domain/subscription_candidate.dart';

class BeforeYouSubscribeScreen extends ConsumerWidget {
  const BeforeYouSubscribeScreen({this.candidate, super.key});

  final SubscriptionCandidate? candidate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = candidate;
    if (pending == null) {
      return AppScaffold(
        title: AppStrings.beforeYouSubscribeTitle,
        body: ErrorState(
          message: AppStrings.beforeSubscribeMissing,
          retryLabel: AppStrings.backToList,
          onRetry: () => context.go(AppRoutes.subscriptions),
        ),
      );
    }

    final async = ref.watch(subscriptionsProvider);
    return async.when(
      loading: () => const AppScaffold(
        title: AppStrings.beforeYouSubscribeTitle,
        body: LoadingState(),
      ),
      error: (error, stackTrace) => AppScaffold(
        title: AppStrings.beforeYouSubscribeTitle,
        body: ErrorState(
          message: AppStrings.errorLoadSubscriptions,
          onRetry: () => ref.invalidate(subscriptionsProvider),
        ),
      ),
      data: (subscriptions) {
        final impact = SubscribeImpactCalculator.from(
          subscriptions: subscriptions,
          candidate: pending,
        );
        return _ImpactBody(impact: impact);
      },
    );
  }
}

class _ImpactBody extends ConsumerWidget {
  const _ImpactBody({required this.impact});

  final SubscribeImpact impact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advice = ref.watch(subscribeAdviceProvider(impact));
    final textTheme = Theme.of(context).textTheme;
    final candidate = impact.candidate;
    final billed =
        '${MoneyFormat.format(impact.monthlyAmount, currencyCode: impact.currencyCode)}${AppStrings.compactPerMonth}';
    final current =
        '${MoneyFormat.format(impact.currentCategoryMonthly, currencyCode: impact.currencyCode)}${AppStrings.compactPerMonth}';
    final after =
        '${MoneyFormat.format(impact.afterCategoryMonthly, currencyCode: impact.currencyCode)}${AppStrings.compactPerMonth}';
    final annual =
        '+${MoneyFormat.format(impact.annualImpact, currencyCode: impact.currencyCode)}';
    final category = LeakCopy.categoryLabel(candidate.category);

    return AppScaffold(
      title: AppStrings.beforeYouSubscribeTitle,
      padding: const EdgeInsets.all(AppSpacing.page),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(candidate.name, style: textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(billed, style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LabeledAmount(
                    label: AppStrings.currentCategorySpending(category),
                    value: current,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledAmount(label: AppStrings.afterAdding, value: after),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledAmount(label: AppStrings.annualImpact, value: annual),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            advice.when(
              loading: () => const LoadingState(),
              error: (error, stackTrace) => ErrorState(
                message: AppStrings.errorLoadAdvice,
                onRetry: () => ref.invalidate(subscribeAdviceProvider(impact)),
              ),
              data: (result) => AppCard(
                child: Text(result.recommendation, style: textTheme.bodyLarge),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(AppStrings.beforeSubscribeNotice, style: textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              key: const Key('confirm-subscribe'),
              label: AppStrings.addThisSubscription,
              onPressed: () => _confirm(context, ref),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: AppStrings.cancel,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    if (!ref.read(featureAccessProvider).canAddSubscription) {
      context.push(
        AppRoutes.paywallLocation(source: PaywallSource.unlimitedGate),
      );
      return;
    }
    await ref
        .read(beforeYouSubscribeControllerProvider)
        .confirm(impact.candidate);
    if (context.mounted) {
      context.go(AppRoutes.subscriptions);
    }
  }
}

class _LabeledAmount extends StatelessWidget {
  const _LabeledAmount({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: textTheme.headlineMedium),
      ],
    );
  }
}
