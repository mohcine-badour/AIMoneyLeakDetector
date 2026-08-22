import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/providers/clock_provider.dart';
import '../../ads/domain/ad_placement.dart';
import '../../ads/presentation/ad_banner_slot.dart';
import '../../paywall/paywall_navigation.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../upcoming_providers.dart';
import 'upcoming_payment_tile.dart';

class UpcomingPaymentsScreen extends ConsumerWidget {
  const UpcomingPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(upcomingPaymentsProvider);
    final now = ref.watch(appNowProvider);

    return AppScaffold(
      title: AppStrings.upcomingPayments,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.page,
      ),
      bottomBanner: const AdBannerSlot(placement: AdPlacement.upcoming),
      body: async.when(
        loading: () => const LoadingState(),
        error: (error, stackTrace) => ErrorState(
          message: AppStrings.errorLoadSubscriptions,
          onRetry: () => ref.invalidate(subscriptionsProvider),
        ),
        data: (payments) {
          if (payments.isEmpty) {
            return EmptyState(
              title: AppStrings.emptyUpcomingTitle,
              message: AppStrings.emptyUpcomingMessage,
              actionLabel: AppStrings.addSubscriptionTitle,
              onAction: () => PaywallNavigation.addSubscription(context, ref),
            );
          }

          return ListView.separated(
            itemCount: payments.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return UpcomingPaymentTile(payment: payments[index], now: now);
            },
          );
        },
      ),
    );
  }
}
