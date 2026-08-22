import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
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
    final tokens = AppTokens.of(context);

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
        final monthly = MoneyFormat.format(
          snapshot.monthlyAmount,
          currencyCode: widget.subscription.currency,
        );
        final perUse = snapshot.costPerUse == null
            ? null
            : MoneyFormat.format(
                snapshot.costPerUse!,
                currencyCode: widget.subscription.currency,
              );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: BoxDecoration(
            color: tokens.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.costPerUseLabel.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: tokens.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    AppStrings.monthlyLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: tokens.textMuted,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    monthly,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: tokens.textPrimary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
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
              const SizedBox(height: AppSpacing.md),
              Text(
                AppStrings.costPerUseLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: tokens.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                perUse ?? AppStrings.costPerUseUnavailable,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w400,
                  color: perUse == null
                      ? tokens.textSecondary
                      : tokens.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _logUse,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: tokens.textPrimary,
                    backgroundColor: tokens.bgMuted,
                    side: BorderSide(color: tokens.borderStrong),
                    minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    AppStrings.logAUse,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1,
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
