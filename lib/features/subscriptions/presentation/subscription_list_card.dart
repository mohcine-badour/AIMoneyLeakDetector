import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/money_text.dart';
import '../domain/subscription.dart';
import 'subscription_labels.dart';

class SubscriptionListCard extends StatelessWidget {
  const SubscriptionListCard({
    required this.subscription,
    this.onTap,
    super.key,
  });

  final Subscription subscription;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subscription.name, style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          MoneyText(
            amount: subscription.amount,
            currencyCode: subscription.currency,
            suffix: subscription.billingCycle.periodSuffix,
            compact: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(subscription.category.label, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),
          Text(AppStrings.nextPayment, style: textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppDateFormat.monthDay(subscription.nextBillingDate),
            style: textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
