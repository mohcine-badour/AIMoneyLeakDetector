import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../paywall/paywall_navigation.dart';
import '../subscriptions_providers.dart';

class EmptyFilterState extends ConsumerWidget {
  const EmptyFilterState({required this.hasAnySubscriptions, super.key});

  final bool hasAnySubscriptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    if (!hasAnySubscriptions) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tokens.bgSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(AppIcons.add, size: 22, color: tokens.filterDot),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.addFirstSubscriptionTitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.addFirstSubscriptionMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: tokens.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: AppStrings.addSubscriptionTitle,
              onPressed: () => PaywallNavigation.addSubscription(context, ref),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tokens.bgSubtle,
              shape: BoxShape.circle,
            ),
            child: Icon(AppIcons.filterOff, size: 18, color: tokens.textMuted),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.noMatchingSubscriptionsTitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            AppStrings.noMatchingSubscriptionsMessage,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () =>
                ref.read(subscriptionListQueryProvider.notifier).reset(),
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              side: BorderSide(color: tokens.borderStrong),
              foregroundColor: tokens.textPrimary,
            ),
            child: const Text(AppStrings.resetFilters),
          ),
        ],
      ),
    );
  }
}
