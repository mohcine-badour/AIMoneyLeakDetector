import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('welcome screen shows brand, tagline, and CTA', (tester) async {
    await pumpBillKillerApp(tester);

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);
  });

  testWidgets('app wires Material 3 light and dark themes', (tester) async {
    await pumpBillKillerApp(tester, location: AppRoutes.launch);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.theme, isNotNull);
    expect(app.darkTheme, isNotNull);
    expect(app.theme!.useMaterial3, isTrue);
    expect(app.darkTheme!.useMaterial3, isTrue);
    expect(app.themeMode, ThemeMode.dark);
  });
}
