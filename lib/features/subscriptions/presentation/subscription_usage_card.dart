import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../domain/cost_per_use.dart';
import '../domain/subscription.dart';
import '../domain/subscription_cost.dart';
import '../domain/usage_validator.dart';
import '../usage_controller.dart';

class SubscriptionUsageCard extends ConsumerStatefulWidget {
  const SubscriptionUsageCard({required this.subscription, super.key});

  final Subscription subscription;

  @override
  ConsumerState<SubscriptionUsageCard> createState() =>
      _SubscriptionUsageCardState();
}

class _SubscriptionUsageCardState extends ConsumerState<SubscriptionUsageCard> {
  final _usesController = TextEditingController();
  var _hydrated = false;
  String? _usesError;

  @override
  void dispose() {
    _usesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(
      usageBySubscriptionProvider(widget.subscription.id),
    );
    final textTheme = Theme.of(context).textTheme;

    return async.when(
      loading: () => const LoadingState(),
      error: (error, stackTrace) => ErrorState(
        message: AppStrings.errorLoadSubscriptions,
        onRetry: () =>
            ref.invalidate(usageBySubscriptionProvider(widget.subscription.id)),
      ),
      data: (usage) {
        if (!_hydrated) {
          _usesController.text = usage == null ? '' : '${usage.useCount}';
          _hydrated = true;
        }
        final parsed = UsageValidator.parseCount(_usesController.text);
        final usesForPreview = _usesError == null
            ? parsed ?? usage?.useCount
            : usage?.useCount;
        final snapshot = CostPerUse.fromMonthly(
          monthlyAmount: SubscriptionCost.monthlyEquivalent(
            widget.subscription,
          ),
          uses: usesForPreview,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.monthlyLabel, style: textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            MoneyText(
              amount: snapshot.monthlyAmount,
              currencyCode: widget.subscription.currency,
              compact: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              key: const Key('subscription-uses'),
              label: AppStrings.usesLabel,
              hint: AppStrings.usesHint,
              controller: _usesController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              errorText: _usesError,
              onChanged: _onUsesChanged,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(AppStrings.costPerUseLabel, style: textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            if (snapshot.costPerUse == null)
              Text(AppStrings.costPerUseUnavailable, style: textTheme.bodyLarge)
            else
              Text(
                MoneyFormat.format(
                  snapshot.costPerUse!,
                  currencyCode: widget.subscription.currency,
                ),
                style: textTheme.bodyLarge,
              ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: AppStrings.logAUse,
              variant: AppButtonVariant.secondary,
              onPressed: _logUse,
            ),
          ],
        );
      },
    );
  }

  Future<void> _onUsesChanged(String value) async {
    final parsed = UsageValidator.parseCount(value);
    if (value.trim().isEmpty) {
      setState(() => _usesError = null);
      await ref
          .read(subscriptionUsageControllerProvider)
          .clear(widget.subscription.id);
      return;
    }
    if (!UsageValidator.isValidCount(parsed)) {
      setState(() => _usesError = AppStrings.errorUsesInvalid);
      return;
    }
    setState(() => _usesError = null);
    await ref
        .read(subscriptionUsageControllerProvider)
        .setUses(widget.subscription.id, parsed!);
  }

  Future<void> _logUse() async {
    final parsed = UsageValidator.parseCount(_usesController.text);
    final current = UsageValidator.isValidCount(parsed) ? parsed! : 0;
    final next = current + 1;
    _usesController.text = '$next';
    setState(() => _usesError = null);
    await ref
        .read(subscriptionUsageControllerProvider)
        .setUses(widget.subscription.id, next);
  }
}
