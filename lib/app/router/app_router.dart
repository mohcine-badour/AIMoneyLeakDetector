import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/widgets/placeholder_screen.dart';
import '../../features/before_subscribe/domain/subscription_candidate.dart';
import '../../features/before_subscribe/presentation/before_you_subscribe_screen.dart';
import '../../features/cancellation/presentation/cancellation_guide_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/welcome/presentation/welcome_screen.dart';
import '../../features/paywall/domain/paywall_source.dart';
import '../../features/paywall/presentation/paywall_screen.dart';
import '../../features/upcoming/presentation/upcoming_payments_screen.dart';
import '../../features/insights/presentation/insights_screen.dart';
import '../../features/scanner/presentation/scan_receipt_screen.dart';
import '../../features/settings/presentation/privacy_policy_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/subscriptions/presentation/add_subscription_screen.dart';
import '../../features/subscriptions/presentation/subscription_detail_screen.dart';
import '../../features/subscriptions/presentation/subscriptions_list_screen.dart';
import '../../features/trials/presentation/add_trial_screen.dart';
import '../../features/trials/presentation/trial_detail_screen.dart';
import '../../features/trials/presentation/trials_list_screen.dart';
import 'app_routes.dart';

/// Application router. Screens stay as placeholders until their feature step.
abstract final class AppRouter {
  static GoRouter create({String initialLocation = AppRoutes.launch}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.launch,
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.signIn,
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.subscriptions,
          builder: (context, state) => const SubscriptionsListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddSubscriptionScreen(),
            ),
            GoRoute(
              path: 'scan',
              builder: (context, state) => const ScanReceiptScreen(),
            ),
            GoRoute(
              path: 'evaluate',
              builder: (context, state) {
                final extra = state.extra;
                return BeforeYouSubscribeScreen(
                  candidate: extra is SubscriptionCandidate ? extra : null,
                );
              },
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return SubscriptionDetailScreen(subscriptionId: id);
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final id = state.pathParameters['id'];
                    return AddSubscriptionScreen(subscriptionId: id);
                  },
                ),
                GoRoute(
                  path: 'cancel',
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return CancellationGuideScreen(subscriptionId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.upcoming,
          builder: (context, state) => const UpcomingPaymentsScreen(),
        ),
        GoRoute(
          path: AppRoutes.trials,
          builder: (context, state) => const TrialsListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddTrialScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return TrialDetailScreen(trialId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.savings,
          builder: (context, state) => const InsightsScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'privacy',
              builder: (context, state) => const PrivacyPolicyScreen(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.paywall,
          pageBuilder: (context, state) {
            final source = PaywallSourceX.parse(
              state.uri.queryParameters['source'],
            );
            return CustomTransitionPage<void>(
              key: state.pageKey,
              fullscreenDialog: true,
              child: PaywallScreen(source: source),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                );
              },
            );
          },
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
