import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/bootstrap_error_app.dart';
import 'app/config/app_config.dart';
import 'app/router/app_router.dart';
import 'app/router/app_routes.dart';
import 'app/store_screenshots.dart';
import 'core/database/app_database.dart';
import 'core/database/database_encryption.dart';
import 'core/providers/app_database_provider.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'core/security/platform_secure_store.dart';
import 'core/security/security_providers.dart';
import 'features/ads/data/admob_bootstrap.dart';
import 'features/ads/domain/ad_config.dart';
import 'features/analytics/analytics_providers.dart';
import 'features/analytics/data/analytics_factory.dart';
import 'features/cancellation/cancellation_providers.dart';
import 'features/cancellation/data/https_link_opener.dart';
import 'features/cancellation/data/url_launcher_link_opener.dart';
import 'features/crash_reporting/crash_reporting_providers.dart';
import 'features/crash_reporting/data/crash_reporter_factory.dart';
import 'features/crash_reporting/data/logging_crash_reporter.dart';
import 'features/crash_reporting/domain/crash_reporter.dart';
import 'features/notifications/data/local_reminder_scheduler.dart';
import 'features/notifications/notifications_providers.dart';
import 'features/onboarding/data/onboarding_repository.dart';
import 'features/paywall/data/billing_client_factory.dart';
import 'features/paywall/domain/monetization_config.dart';
import 'features/paywall/paywall_providers.dart';

/// Active crash reporter used by the global error handlers below. Starts as a
/// console logger so an early boot error is still visible, then is replaced
/// with the opt-in-aware reporter once preferences load.
CrashReporter _crashReporter = const LoggingCrashReporter();

void main() {
  runZonedGuarded(_bootstrap, (error, stack) {
    unawaited(
      _crashReporter.recordError(error, stack, fatal: true, context: 'zone'),
    );
  });
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Framework errors (build/layout/paint): keep the default console dump, then
  // forward to the reporter.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    unawaited(_crashReporter.recordFlutterError(details));
  };
  // Errors outside the Flutter call stack (async gaps, platform channels).
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    unawaited(
      _crashReporter.recordError(
        error,
        stack,
        fatal: true,
        context: 'platform',
      ),
    );
    return true;
  };

  final prefs = await SharedPreferences.getInstance();
  _crashReporter = CrashReporterFactory.create(
    enabled:
        prefs.getBool(CrashReportingEnabledController.storageKey) ?? false,
  );

  await _startApp(prefs);
}

/// Boots the app. Critical init (the encrypted database) is required; anything
/// else is best-effort so one failing subsystem cannot block startup.
Future<void> _startApp(SharedPreferences prefs) async {
  final PlatformSecureStore secureStore;
  final AppDatabase database;
  try {
    secureStore = PlatformSecureStore();
    final databaseKey = await DatabaseEncryption.ensureKey(secureStore);
    await DatabaseEncryption.migratePlaintextIfNeeded(databaseKey);
    AppDatabase.bindEncryptionKey(databaseKey);
    database = AppDatabase.encrypted(databaseKey);
  } catch (error, stack) {
    await _crashReporter.recordError(
      error,
      stack,
      fatal: true,
      context: 'bootstrap.database',
    );
    runApp(BootstrapErrorApp(onRetry: () => _startApp(prefs)));
    return;
  }

  final onboarding = OnboardingRepository(prefs);
  // Debug-only App Store screenshot mode (null in release builds).
  final shotsLocation = await StoreScreenshots.prepare(prefs, database);
  final analytics = AnalyticsFactory.create(
    enabled: AppConfig.analyticsEnabled,
  );

  // Best-effort subsystems: a failure here is reported but never blocks boot.
  final reminderScheduler = LocalReminderScheduler(analytics: analytics);
  await _guard('reminders', () => reminderScheduler.initialize());

  final monetization = MonetizationConfig.defaults;
  final billing = BillingClientFactory.create(monetization);
  await _guard('billing', () => billing.initialize());

  await _guard('ads', () => AdMobBootstrap.initialize(AdConfig.defaults));

  final router = AppRouter.create(
    initialLocation:
        shotsLocation ??
        (onboarding.isCompleted ? AppRoutes.dashboard : AppRoutes.launch),
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        secureStoreProvider.overrideWithValue(secureStore),
        appDatabaseProvider.overrideWithValue(database),
        reminderSchedulerProvider.overrideWithValue(reminderScheduler),
        cancellationLinkOpenerProvider.overrideWithValue(
          const HttpsLinkOpener(UrlLauncherLinkOpener()),
        ),
        monetizationConfigProvider.overrideWithValue(monetization),
        billingClientProvider.overrideWithValue(billing),
        analyticsProvider.overrideWithValue(analytics),
        crashReporterProvider.overrideWithValue(_crashReporter),
      ],
      child: KichtaApp(router: router),
    ),
  );
  StoreScreenshots.afterStart(router);
}

/// Runs a best-effort init step, reporting failure without aborting startup.
Future<void> _guard(String stage, Future<void> Function() init) async {
  try {
    await init();
  } catch (error, stack) {
    await _crashReporter.recordError(error, stack, context: 'bootstrap.$stage');
  }
}
