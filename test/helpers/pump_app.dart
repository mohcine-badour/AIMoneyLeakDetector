import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:billkiller_ai/app/app.dart';
import 'package:billkiller_ai/app/router/app_router.dart';
import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/database/app_database.dart';
import 'package:billkiller_ai/core/providers/app_database_provider.dart';
import 'package:billkiller_ai/core/providers/shared_preferences_provider.dart';
import 'package:billkiller_ai/core/providers/clock_provider.dart';
import 'package:billkiller_ai/features/cancellation/cancellation_providers.dart';
import 'package:billkiller_ai/features/cancellation/domain/cancellation_link_opener.dart';
import 'package:billkiller_ai/features/notifications/domain/reminder_scheduler.dart';
import 'package:billkiller_ai/features/notifications/notifications_providers.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_extractor.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_image.dart';
import 'package:billkiller_ai/features/scanner/scan_flow_controller.dart';

Future<(GoRouter, SharedPreferences, AppDatabase)> pumpBillKillerApp(
  WidgetTester tester, {
  String location = AppRoutes.launch,
  Map<String, Object> prefs = const {},
  Future<void> Function(AppDatabase database)? seed,
  DateTime? now,
  ReminderScheduler? reminderScheduler,
  ReceiptImagePicker? imagePicker,
  ReceiptExtractor? extractor,
  CancellationLinkOpener? cancellationLinkOpener,
}) async {
  SharedPreferences.setMockInitialValues(Map<String, Object>.from(prefs));
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = AppDatabase(NativeDatabase.memory());
  if (seed != null) {
    await seed(database);
  }
  final router = AppRouter.create(initialLocation: location);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
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
      ],
      child: BillKillerApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
  addTearDown(router.dispose);
  addTearDown(database.close);
  return (router, sharedPreferences, database);
}
