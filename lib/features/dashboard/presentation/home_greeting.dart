import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/day_period.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({
    required this.now,
    required this.renewalCount,
    super.key,
  });

  final DateTime now;
  final int renewalCount;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final title = switch (GreetingPeriodResolver.from(now)) {
      GreetingPeriod.morning => AppStrings.goodMorning,
      GreetingPeriod.afternoon => AppStrings.goodAfternoon,
      GreetingPeriod.evening => AppStrings.goodEvening,
    };
    final subtitle = renewalCount == 0
        ? AppStrings.noRenewalsThisWeek
        : AppStrings.renewalCount(renewalCount);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.4,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: tokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: tokens.bgSubtle,
            shape: const CircleBorder(),
            child: InkWell(
              key: const Key('open-settings'),
              customBorder: const CircleBorder(),
              onTap: () => context.go(AppRoutes.settings),
              child: SizedBox(
                width: 34,
                height: 34,
                child: Icon(
                  AppIcons.settings,
                  size: 15,
                  color: tokens.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
