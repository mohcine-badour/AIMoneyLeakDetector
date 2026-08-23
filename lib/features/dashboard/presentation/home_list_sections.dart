import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../subscriptions/domain/subscription.dart';
import 'home_subscription_row.dart';

class RenewingSoonSection extends StatelessWidget {
  const RenewingSoonSection({
    required this.subscriptions,
    required this.now,
    this.onSeeAll,
    super.key,
  });

  final List<Subscription> subscriptions;
  final DateTime now;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return const SizedBox.shrink();
    }
    final tokens = AppTokens.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.renewingSoon,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              InkWell(
                key: onSeeAll == null ? null : const Key('home-upcoming'),
                onTap: onSeeAll,
                child: Text(
                  onSeeAll == null
                      ? AppStrings.next7Days
                      : AppStrings.viewAll,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: tokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        _HomeListCard(
          children: [
            for (var i = 0; i < subscriptions.length; i++) ...[
              if (i > 0)
                Divider(height: 0.5, thickness: 0.5, color: tokens.border),
              HomeSubscriptionRow(
                subscription: subscriptions[i],
                now: now,
                variant: SubscriptionRowVariant.renewing,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class AllSubscriptionsSection extends StatelessWidget {
  const AllSubscriptionsSection({
    required this.subscriptions,
    required this.now,
    required this.activeCount,
    required this.onSeeAll,
    super.key,
  });

  final List<Subscription> subscriptions;
  final DateTime now;
  final int activeCount;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return const SizedBox.shrink();
    }
    final tokens = AppTokens.of(context);
    final showSeeAll = activeCount > 5;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.allSubscriptions,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              Text(
                AppStrings.activeCountLabel(activeCount),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: tokens.textSecondary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        _HomeListCard(
          children: [
            for (var i = 0; i < subscriptions.length; i++) ...[
              if (i > 0)
                Divider(height: 0.5, thickness: 0.5, color: tokens.border),
              HomeSubscriptionRow(
                subscription: subscriptions[i],
                now: now,
                variant: SubscriptionRowVariant.all,
              ),
            ],
            if (showSeeAll) ...[
              Divider(height: 0.5, thickness: 0.5, color: tokens.border),
              InkWell(
                onTap: onSeeAll,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '${AppStrings.seeAllSubscriptions(activeCount)} →',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: tokens.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _HomeListCard extends StatelessWidget {
  const _HomeListCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: tokens.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Column(children: children),
    );
  }
}
