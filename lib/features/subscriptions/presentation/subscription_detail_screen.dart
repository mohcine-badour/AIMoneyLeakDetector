import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../domain/subscription.dart';
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
          onRetry: () => ref.invalidate(subscriptionByIdProvider(subscriptionId)),
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
    final textTheme = Theme.of(context).textTheme;
    final billed =
        '${MoneyFormat.format(subscription.amount, currencyCode: subscription.currency)}${subscription.billingCycle.compactPeriod}';
    final monthly = SubscriptionCost.monthlyEquivalent(subscription);
    final annual = SubscriptionCost.annualEquivalent(subscription);

    return AppScaffold(
      title: subscription.name,
      padding: const EdgeInsets.all(AppSpacing.page),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(billed, style: textTheme.headlineMedium),
                const SizedBox(height: AppSpacing.lg),
                Text(AppStrings.annualLabel, style: textTheme.labelMedium),
                const SizedBox(height: AppSpacing.xs),
                MoneyText(
                  amount: annual,
                  currencyCode: subscription.currency,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SubscriptionUsageCard(subscription: subscription),
          const SizedBox(height: AppSpacing.xl),
          _DetailRow(label: AppStrings.fieldMerchant, value: subscription.merchant),
          _DetailRow(
            label: AppStrings.fieldAmount,
            value: MoneyFormat.format(
              subscription.amount,
              currencyCode: subscription.currency,
            ),
          ),
          _DetailRow(
            label: AppStrings.fieldBillingCycle,
            value: subscription.billingCycle.label,
          ),
          _DetailRow(
            label: AppStrings.fieldMonthlyEquivalent,
            value: MoneyFormat.format(
              monthly,
              currencyCode: subscription.currency,
            ),
          ),
          _DetailRow(
            label: AppStrings.fieldAnnualEquivalent,
            value: MoneyFormat.format(
              annual,
              currencyCode: subscription.currency,
            ),
          ),
          _DetailRow(
            label: AppStrings.fieldNextBillingDate,
            value: AppDateFormat.short(subscription.nextBillingDate),
          ),
          _DetailRow(
            label: AppStrings.fieldCategory,
            value: subscription.category.label,
          ),
          _DetailRow(
            label: AppStrings.fieldCreated,
            value: AppDateFormat.short(subscription.createdAt),
          ),
          _DetailRow(
            label: AppStrings.fieldSource,
            value: subscription.source.label,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: AppStrings.edit,
            onPressed: () => context.push(
              AppRoutes.editSubscriptionLocation(subscription.id),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: AppStrings.cancellationGuide,
            variant: AppButtonVariant.secondary,
            onPressed: () => context.push(
              AppRoutes.cancellationGuideLocation(subscription.id),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: AppStrings.delete,
            variant: AppButtonVariant.danger,
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
        ),
      ),
    );
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
    await ref.read(subscriptionDetailControllerProvider).delete(subscription.id);
    if (context.mounted) {
      context.go(AppRoutes.subscriptions);
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
