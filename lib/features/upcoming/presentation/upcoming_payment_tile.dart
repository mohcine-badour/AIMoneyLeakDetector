import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/merchant_mark.dart';
import '../domain/upcoming_payment.dart';

class UpcomingPaymentTile extends StatelessWidget {
  const UpcomingPaymentTile({
    required this.payment,
    required this.now,
    super.key,
  });

  final UpcomingPayment payment;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final when = AppDateFormat.upcomingLabel(payment.billingDate, now);

    return InkWell(
      onTap: () => context.push(
        AppRoutes.subscriptionDetailLocation(payment.subscriptionId),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            MerchantMark(name: payment.name),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(when, style: textTheme.labelMedium),
                  const SizedBox(height: 2),
                  Text(payment.name, style: textTheme.titleSmall),
                ],
              ),
            ),
            Text(
              MoneyFormat.format(
                payment.amount,
                currencyCode: payment.currencyCode,
              ),
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
