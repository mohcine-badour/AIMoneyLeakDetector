import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/theme/app_theme.dart';
import 'package:billkiller_ai/core/brand/brand_icon.dart';
import 'package:billkiller_ai/core/brand/brand_registry.dart';

Finder _tile(Color color) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color == color,
  );
}

void main() {
  testWidgets('known brand uses authentic tile color, not a gray initial', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: BrandIcon(slug: 'netflix')),
      ),
    );

    expect(_tile(BrandRegistry.bySlug['netflix']!.tileBg), findsOneWidget);
    expect(find.text('N'), findsNothing);
  });

  testWidgets('unknown brand falls back to a gray initial without crashing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: BrandIcon(slug: 'randomapp')),
      ),
    );

    expect(find.text('R'), findsOneWidget);
    expect(_tile(BrandRegistry.bySlug['netflix']!.tileBg), findsNothing);
  });

  testWidgets('brand tile color stays the same in dark mode', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(body: BrandIcon(slug: 'netflix')),
      ),
    );

    expect(_tile(const Color(0xFFE50914)), findsOneWidget);
  });
}
