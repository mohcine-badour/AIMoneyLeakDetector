import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/widgets/placeholder_screen.dart';
import '../../features/launch/launch_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/subscriptions/presentation/add_subscription_screen.dart';
import 'app_routes.dart';

/// Application router. Screens stay as placeholders until their feature step.
abstract final class AppRouter {
  static GoRouter create({String initialLocation = AppRoutes.launch}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.launch,
          builder: (context, state) => const LaunchScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (context, state) => const PlaceholderScreen(
            title: AppStrings.dashboardTitle,
          ),
        ),
        GoRoute(
          path: AppRoutes.subscriptions,
          builder: (context, state) => const PlaceholderScreen(
            title: AppStrings.subscriptionsTitle,
          ),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddSubscriptionScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return PlaceholderScreen(
                  title: AppStrings.subscriptionDetailTitle,
                  subtitle: id,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.trials,
          builder: (context, state) => const PlaceholderScreen(
            title: AppStrings.trialsTitle,
          ),
        ),
        GoRoute(
          path: AppRoutes.savings,
          builder: (context, state) => const PlaceholderScreen(
            title: AppStrings.savingsTitle,
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const PlaceholderScreen(
            title: AppStrings.settingsTitle,
          ),
        ),
        GoRoute(
          path: AppRoutes.paywall,
          builder: (context, state) => const PlaceholderScreen(
            title: AppStrings.paywallTitle,
          ),
        ),
      ],
      errorBuilder: (context, state) => PlaceholderScreen(
        title: AppStrings.notFoundTitle,
        subtitle: state.uri.toString(),
        actionLabel: AppStrings.goHome,
        onAction: () => context.go(AppRoutes.launch),
      ),
    );
  }
}
