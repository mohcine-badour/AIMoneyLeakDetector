import 'package:flutter/material.dart';

import '../../features/launch/launch_screen.dart';
import 'app_routes.dart';

/// Navigator 1.0 routing. Feature screens are registered here as they appear.
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.launch:
        return _page(settings, const LaunchScreen());
      default:
        return _page(settings, const LaunchScreen());
    }
  }

  static MaterialPageRoute<void> _page(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => child,
    );
  }
}
