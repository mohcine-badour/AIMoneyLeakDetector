import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:billkiller_ai/app/app.dart';
import 'package:billkiller_ai/app/router/app_router.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = AppRouter.create();
  });

  tearDown(() {
    router.dispose();
  });

  testWidgets('launch screen shows brand, tagline, and CTA', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: BillKillerApp(router: router)),
    );

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);
  });

  testWidgets('app wires Material 3 light and dark themes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: BillKillerApp(router: router)),
    );

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.theme, isNotNull);
    expect(app.darkTheme, isNotNull);
    expect(app.theme!.useMaterial3, isTrue);
    expect(app.darkTheme!.useMaterial3, isTrue);
    expect(app.themeMode, ThemeMode.system);
  });
}
