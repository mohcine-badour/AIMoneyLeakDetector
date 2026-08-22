import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_icon.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../domain/subscription.dart';
import '../domain/subscription_brand.dart';
import '../subscription_detail_controller.dart';
import 'subscription_labels.dart';

class SubscriptionListRow extends ConsumerWidget {
  const SubscriptionListRow({
    required this.subscription,
    required this.isLast,
    super.key,
  });

  final Subscription subscription;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final now = ref.watch(appNowProvider);
    final slug = SubscriptionBrand.slugFor(subscription);
    final faded = subscription.status != SubscriptionStatus.active;
    final relative = AppDateFormat.relative(subscription.nextBillingDate, now);
    final when = relative.isEmpty
        ? AppDateFormat.monthDayShort(subscription.nextBillingDate)
        : relative;
    final category = SubscriptionBrand.categoryFor(subscription).label;
    var subtitle = '$category · $when';
    if (subscription.billingCycle == BillingCycle.yearly) {
      subtitle = '$subtitle · Yearly';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>
            context.push(AppRoutes.subscriptionDetailLocation(subscription.id)),
        onLongPress: () => _showMenu(context, ref),
        child: Opacity(
          opacity: faded ? 0.5 : 1,
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(color: tokens.border, width: 0.5),
                    ),
            ),
            child: Row(
              children: [
                BrandIcon(
                  slug: slug,
                  size: 40,
                  fallbackInitial: subscription.name.isEmpty
                      ? '?'
                      : subscription.name[0],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subscription.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.15,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: tokens.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      MoneyFormat.format(
                        subscription.amount,
                        currencyCode: subscription.currency,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        color: tokens.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subscription.billingCycle.listInterval,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: tokens.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMenu(BuildContext context, WidgetRef ref) async {
    final paused = subscription.status == SubscriptionStatus.paused;
    final action = await showModalBottomSheet<_RowAction>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(AppIcons.edit),
                title: const Text(AppStrings.edit),
                onTap: () => Navigator.pop(context, _RowAction.edit),
              ),
              ListTile(
                leading: const Icon(AppIcons.pause),
                title: Text(paused ? AppStrings.resume : AppStrings.pause),
                onTap: () => Navigator.pop(
                  context,
                  paused ? _RowAction.resume : _RowAction.pause,
                ),
              ),
              ListTile(
                leading: const Icon(AppIcons.delete),
                title: const Text(AppStrings.delete),
                onTap: () => Navigator.pop(context, _RowAction.delete),
              ),
            ],
          ),
        );
      },
    );
    if (!context.mounted || action == null) {
      return;
    }
    switch (action) {
      case _RowAction.edit:
        context.push(AppRoutes.editSubscriptionLocation(subscription.id));
      case _RowAction.pause:
        await ref
            .read(subscriptionDetailControllerProvider)
            .setStatus(subscription.id, SubscriptionStatus.paused);
      case _RowAction.resume:
        await ref
            .read(subscriptionDetailControllerProvider)
            .setStatus(subscription.id, SubscriptionStatus.active);
      case _RowAction.delete:
        await _confirmDelete(context, ref);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: AppStrings.deleteSubscriptionTitle,
      message: AppStrings.deleteSubscriptionMessage,
    );
    if (confirmed == true) {
      await ref
          .read(subscriptionDetailControllerProvider)
          .delete(subscription.id);
    }
  }
}

enum _RowAction { edit, pause, resume, delete }
