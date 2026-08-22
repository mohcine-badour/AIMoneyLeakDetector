import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_strings.dart';
import '../features/analytics/analytics_providers.dart';
import '../features/notifications/notifications_providers.dart';
import '../features/paywall/paywall_providers.dart';
import 'config/app_config.dart';
import 'theme/app_theme.dart';

class KichtaApp extends ConsumerWidget {
  const KichtaApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(reminderSyncProvider);
    ref.watch(liveEntitlementProvider);
    ref.watch(analyticsSessionProvider);
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      locale: const Locale(AppConfig.defaultLanguageCode),
      supportedLocales: const [Locale(AppConfig.defaultLanguageCode)],
      routerConfig: router,
    );
  }
}
