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

Future<(GoRouter, SharedPreferences, AppDatabase)> pumpBillKillerApp(
  WidgetTester tester, {
  String location = AppRoutes.launch,
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(Map<String, Object>.from(prefs));
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = AppDatabase(NativeDatabase.memory());
  final router = AppRouter.create(initialLocation: location);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: BillKillerApp(router: router),
    ),
  );
  await tester.pumpAndSettle();
  addTearDown(router.dispose);
  addTearDown(database.close);
  return (router, sharedPreferences, database);
}
