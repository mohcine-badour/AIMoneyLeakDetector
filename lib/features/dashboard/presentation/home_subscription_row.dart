import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_icon.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_brand.dart';
import '../../subscriptions/presentation/subscription_labels.dart';

enum SubscriptionRowVariant { renewing, all }

class HomeSubscriptionRow extends StatelessWidget {
  const HomeSubscriptionRow({
    required this.subscription,
    required this.now,
    required this.variant,
    super.key,
  });

  final Subscription subscription;
  final DateTime now;
  final SubscriptionRowVariant variant;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final slug = BrandRegistry.slugFor(
      name: subscription.name,
      merchant: subscription.merchant,
    );
    final brand = BrandRegistry.getBrand(slug);
    final name = subscription.name;
    final size = variant == SubscriptionRowVariant.renewing ? 34.0 : 30.0;
    final relative = AppDateFormat.relative(subscription.nextBillingDate, now);
    final absolute = AppDateFormat.monthDayShort(subscription.nextBillingDate);
    final subtitle = variant == SubscriptionRowVariant.renewing
        ? (relative.isEmpty ? absolute : '$relative · $absolute')
        : _allSubtitle(brand);

    return InkWell(
      onTap: () =>
          context.push(AppRoutes.subscriptionDetailLocation(subscription.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            BrandIcon(
              slug: slug,
              size: size,
              fallbackInitial: name.isEmpty ? '?' : name[0],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: tokens.textPrimary,
                      letterSpacing: -0.1,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: tokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  MoneyFormat.format(
                    subscription.amount,
                    currencyCode: subscription.currency,
                  ),
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: tokens.textPrimary,
                    letterSpacing: -0.2,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                if (variant == SubscriptionRowVariant.renewing)
                  Text(
                    subscription.billingCycle.rowCycle,
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
    );
  }

  String _allSubtitle(Brand? brand) {
    final label = brand?.category.label ?? SubscriptionBrand.fromStored(subscription.category).label;
    if (subscription.billingCycle == BillingCycle.yearly) {
      return '$label · Yearly';
    }
    return label;
  }
}
