import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kichta/app/app.dart';
import 'package:kichta/app/router/app_router.dart';
import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/core/providers/app_database_provider.dart';
import 'package:kichta/core/providers/shared_preferences_provider.dart';
import 'package:kichta/core/security/in_memory_secure_store.dart';
import 'package:kichta/core/security/security_providers.dart';
import 'package:kichta/core/providers/clock_provider.dart';
import 'package:kichta/features/cancellation/cancellation_providers.dart';
import 'package:kichta/features/cancellation/domain/cancellation_link_opener.dart';
import 'package:kichta/features/notifications/domain/reminder_scheduler.dart';
import 'package:kichta/features/notifications/notifications_providers.dart';
import 'package:kichta/features/ads/ads_providers.dart';
import 'package:kichta/features/ads/data/disabled_ad_service.dart';
import 'package:kichta/features/ads/domain/ad_config.dart';
import 'package:kichta/features/ads/domain/ad_service.dart';
import 'package:kichta/features/auth/auth_providers.dart';
import 'package:kichta/features/auth/domain/anonymous_auth.dart';
import 'package:kichta/features/analytics/analytics_providers.dart';
import 'package:kichta/features/analytics/data/disabled_analytics.dart';
import 'package:kichta/features/analytics/domain/analytics.dart';
import 'package:kichta/features/paywall/data/fake_billing_client.dart';
import 'package:kichta/features/paywall/domain/billing_client.dart';
import 'package:kichta/features/paywall/domain/entitlement.dart';
import 'package:kichta/features/paywall/domain/monetization_config.dart';
import 'package:kichta/features/paywall/paywall_providers.dart';
import 'package:kichta/features/scanner/domain/receipt_extractor.dart';
import 'package:kichta/features/scanner/domain/receipt_image.dart';
import 'package:kichta/features/scanner/scan_flow_controller.dart';

Future<(GoRouter, SharedPreferences, AppDatabase)> pumpKichtaApp(
  WidgetTester tester, {
  String location = AppRoutes.launch,
  Map<String, Object> prefs = const {},
  Future<void> Function(AppDatabase database)? seed,
  DateTime? now,
  ReminderScheduler? reminderScheduler,
  ReceiptImagePicker? imagePicker,
  ReceiptExtractor? extractor,
  CancellationLinkOpener? cancellationLinkOpener,
  Entitlement? entitlement,
  MonetizationConfig? monetizationConfig,
  BillingClient? billingClient,
  AdConfig? adConfig,
  AdService? adService,
  Analytics? analytics,
  AnonymousAuth? anonymousAuth,
  bool settle = true,
}) async {
  SharedPreferences.setMockInitialValues(Map<String, Object>.from(prefs));
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = AppDatabase(NativeDatabase.memory());
  if (seed != null) {
    await seed(database);
  }
  final router = AppRouter.create(initialLocation: location);
  final billing = billingClient ?? FakeBillingClient();
  final analyticsClient = SanitizingAnalytics(
    analytics ?? const DisabledAnalytics(),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        secureStoreProvider.overrideWithValue(InMemorySecureStore()),
        appDatabaseProvider.overrideWithValue(database),
        if (now != null) appNowProvider.overrideWithValue(now),
        if (reminderScheduler != null)
          reminderSchedulerProvider.overrideWithValue(reminderScheduler),
        if (imagePicker != null)
          receiptImagePickerProvider.overrideWithValue(imagePicker),
        if (extractor != null)
          receiptExtractorProvider.overrideWithValue(extractor),
        if (cancellationLinkOpener != null)
          cancellationLinkOpenerProvider.overrideWithValue(
            cancellationLinkOpener,
          ),
        billingClientProvider.overrideWithValue(billing),
        analyticsProvider.overrideWithValue(analyticsClient),
        if (anonymousAuth != null)
          anonymousAuthProvider.overrideWithValue(anonymousAuth),
        if (entitlement != null)
          entitlementProvider.overrideWithValue(entitlement),
        monetizationConfigProvider.overrideWithValue(
          monetizationConfig ??
              (location.startsWith(AppRoutes.paywall)
                  ? const MonetizationConfig(featureGatesEnabled: true)
                  : const MonetizationConfig()),
        ),
        if (adConfig != null) adConfigProvider.overrideWithValue(adConfig),
        adServiceProvider.overrideWithValue(
          adService ?? const DisabledAdService(),
        ),
      ],
      child: KichtaApp(router: router),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  addTearDown(router.dispose);
  addTearDown(database.close);
  return (router, sharedPreferences, database);
}
