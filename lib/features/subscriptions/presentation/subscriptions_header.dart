import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../paywall/paywall_navigation.dart';
import '../subscriptions_providers.dart';

class SubscriptionsHeader extends ConsumerWidget {
  const SubscriptionsHeader({
    required this.activeCount,
    required this.monthly,
    required this.currencyCode,
    required this.hasAny,
    required this.onSearchPress,
    required this.onFilterPress,
    super.key,
  });

  final int activeCount;
  final double monthly;
  final String currencyCode;
  final bool hasAny;
  final VoidCallback onSearchPress;
  final VoidCallback onFilterPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final query = ref.watch(subscriptionListQueryProvider);
    final amount = MoneyFormat.short(monthly, currencyCode: currencyCode);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.subscriptionsTitle,
                  style: TextStyle(
                    fontSize: 22,
                    height: 24 / 22,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.6,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                if (!hasAny)
                  Text(
                    AppStrings.emptySubscriptionsTitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.05,
                      color: tokens.textMuted,
                    ),
                  )
                else
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.05,
                        color: tokens.textMuted,
                      ),
                      children: [
                        TextSpan(text: '$activeCount active · '),
                        TextSpan(
                          text: '$amount/mo',
                          style: TextStyle(
                            color: tokens.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              _HeaderIconButton(
                key: const Key('open-search'),
                icon: AppIcons.search,
                color: tokens.textSecondary,
                onPressed: onSearchPress,
              ),
              const SizedBox(width: 4),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _HeaderIconButton(
                    key: const Key('open-filter'),
                    icon: AppIcons.filter,
                    color: tokens.textSecondary,
                    onPressed: onFilterPress,
                  ),
                  if (query.hasActiveFilters)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: tokens.filterDot,
                          shape: BoxShape.circle,
                          border: Border.all(color: tokens.bgApp, width: 1),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
              Material(
                color: tokens.accent,
                shape: const CircleBorder(),
                child: Tooltip(
                  message: AppStrings.addSubscriptionTitle,
                  child: InkWell(
                    key: const Key('add-subscription'),
                    customBorder: const CircleBorder(),
                    onTap: () =>
                        PaywallNavigation.addSubscription(context, ref),
                    child: SizedBox(
                      width: 34,
                      height: 34,
                      child: Icon(
                        AppIcons.add,
                        size: 15,
                        color: tokens.accentText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 15, color: color),
      style: IconButton.styleFrom(
        minimumSize: const Size(34, 34),
        maximumSize: const Size(34, 34),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
