import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_tokens.dart';
import '../../features/dashboard/home_scroll.dart';
import '../../features/subscriptions/subs_scroll.dart';
import '../constants/app_icons.dart';
import '../constants/app_strings.dart';

class AppTabBar extends ConsumerWidget {
  const AppTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final location = GoRouterState.of(context).uri.path;
    final index = _indexFor(location);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: tokens.bgCard,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 0.5, thickness: 0.5, color: tokens.border),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < 4; i++)
                  _TabItem(
                    icon: _icons[i],
                    label: _labels[i],
                    active: i == index,
                    onTap: () => _select(context, ref, location, index, i),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _select(
    BuildContext context,
    WidgetRef ref,
    String location,
    int current,
    int selected,
  ) {
    HapticFeedback.lightImpact();
    if (selected == current) {
      if (selected == 0) {
        ref.read(homeScrollToTopProvider.notifier).request();
      } else if (selected == 1) {
        ref.read(subscriptionsScrollToTopProvider.notifier).request();
      }
      return;
    }
    final target = switch (selected) {
      0 => AppRoutes.dashboard,
      1 => AppRoutes.subscriptions,
      2 => AppRoutes.savings,
      _ => AppRoutes.settings,
    };
    if (location == target) {
      return;
    }
    context.go(target);
  }

  static int _indexFor(String location) {
    if (location.startsWith(AppRoutes.subscriptions)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.savings)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.settings)) {
      return 3;
    }
    return 0;
  }

  static const _icons = [
    AppIcons.home,
    AppIcons.subscriptions,
    AppIcons.savings,
    AppIcons.settings,
  ];

  static const _labels = [
    AppStrings.tabHome,
    AppStrings.tabSubscriptions,
    AppStrings.tabInsights,
    AppStrings.tabSettings,
  ];
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final color = active ? tokens.textPrimary : tokens.textMuted;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: active ? 14 : 12,
        ),
        decoration: BoxDecoration(
          color: active ? tokens.bgSubtle : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 0.1,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
