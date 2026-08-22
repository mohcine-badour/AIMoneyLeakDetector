import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/config/app_config.dart';
import 'app/router/app_router.dart';
import 'app/router/app_routes.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'features/analytics/analytics_providers.dart';
import 'features/analytics/data/analytics_factory.dart';
import 'features/cancellation/cancellation_providers.dart';
import 'features/cancellation/data/https_link_opener.dart';
import 'features/cancellation/data/url_launcher_link_opener.dart';
import 'features/notifications/data/local_reminder_scheduler.dart';
import 'features/notifications/notifications_providers.dart';
import 'features/onboarding/data/onboarding_repository.dart';
import 'features/paywall/data/billing_client_factory.dart';
import 'features/paywall/domain/monetization_config.dart';
import 'features/paywall/paywall_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = OnboardingRepository(prefs);
  final analytics = AnalyticsFactory.create(
    enabled: AppConfig.analyticsEnabled,
  );
  final reminderScheduler = LocalReminderScheduler(analytics: analytics);
  await reminderScheduler.initialize();
  final monetization = MonetizationConfig.defaults;
  final billing = BillingClientFactory.create(monetization);
  await billing.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        reminderSchedulerProvider.overrideWithValue(reminderScheduler),
        cancellationLinkOpenerProvider.overrideWithValue(
          const HttpsLinkOpener(UrlLauncherLinkOpener()),
        ),
        monetizationConfigProvider.overrideWithValue(monetization),
        billingClientProvider.overrideWithValue(billing),
        analyticsProvider.overrideWithValue(analytics),
      ],
      child: KichtaApp(
        router: AppRouter.create(
          initialLocation: onboarding.isCompleted
              ? AppRoutes.dashboard
              : AppRoutes.launch,
        ),
      ),
    ),
  );
}
