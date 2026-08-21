import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/money_text.dart';
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

    return AppCard(
      onTap: () => context.push(
        AppRoutes.subscriptionDetailLocation(payment.subscriptionId),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppDateFormat.upcomingLabel(payment.billingDate, now),
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(payment.name, style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          MoneyText(
            amount: payment.amount,
            currencyCode: payment.currencyCode,
            compact: true,
          ),
        ],
      ),
    );
  }
}
