import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import 'config/app_config.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';
import 'theme/app_theme.dart';

class BillKillerApp extends StatelessWidget {
  const BillKillerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      locale: const Locale(AppConfig.defaultLanguageCode),
      supportedLocales: const [Locale(AppConfig.defaultLanguageCode)],
      initialRoute: AppRoutes.launch,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
