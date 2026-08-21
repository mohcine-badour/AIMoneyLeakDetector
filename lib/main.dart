import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'app/router/app_routes.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'features/cancellation/cancellation_providers.dart';
import 'features/cancellation/data/url_launcher_link_opener.dart';
import 'features/notifications/data/local_reminder_scheduler.dart';
import 'features/notifications/notifications_providers.dart';
import 'features/onboarding/data/onboarding_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = OnboardingRepository(prefs);
  final reminderScheduler = LocalReminderScheduler();
  await reminderScheduler.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        reminderSchedulerProvider.overrideWithValue(reminderScheduler),
        cancellationLinkOpenerProvider.overrideWithValue(
          const UrlLauncherLinkOpener(),
        ),
      ],
      child: BillKillerApp(
        router: AppRouter.create(
          initialLocation: onboarding.isCompleted
              ? AppRoutes.dashboard
              : AppRoutes.launch,
        ),
      ),
    ),
  );
}
