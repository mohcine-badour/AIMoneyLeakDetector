import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/theme/app_theme.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/utils/money_format.dart';
import 'package:kichta/core/widgets/app_button.dart';
import 'package:kichta/core/widgets/app_card.dart';
import 'package:kichta/core/widgets/app_scaffold.dart';
import 'package:kichta/core/widgets/app_text_field.dart';
import 'package:kichta/core/widgets/empty_state.dart';
import 'package:kichta/core/widgets/error_state.dart';
import 'package:kichta/core/widgets/loading_state.dart';
import 'package:kichta/core/widgets/money_text.dart';
import 'package:kichta/core/widgets/section_header.dart';

Widget _wrap(Widget child) {
  return MaterialApp(theme: AppTheme.light(), home: child);
}

void main() {
  test('MoneyFormat formats amounts deterministically', () {
    expect(MoneyFormat.format(22.99), r'$22.99');
    expect(MoneyFormat.format(22.9, currencyCode: 'GBP'), '£22.90');
    expect(MoneyFormat.format(-5, currencyCode: 'EUR'), '-€5.00');
    expect(MoneyFormat.format(2249.16), r'$2,249.16');
    expect(MoneyFormat.short(82.98), r'$83');
    expect(MoneyFormat.short(22.99), r'$23');
  });

  testWidgets('AppButton invokes onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        Scaffold(
          body: AppButton(label: 'Continue', onPressed: () => tapped = true),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    expect(tapped, isTrue);
  });

  testWidgets('AppTextField shows its label', (tester) async {
    await tester.pumpWidget(
      _wrap(const Scaffold(body: AppTextField(label: 'Name'))),
    );

    expect(find.text('Name'), findsOneWidget);
  });

  testWidgets('AppScaffold shows a title and body', (tester) async {
    await tester.pumpWidget(
      _wrap(const AppScaffold(title: 'Subscriptions', body: Text('List'))),
    );

    expect(find.text('Subscriptions'), findsOneWidget);
    expect(find.text('List'), findsOneWidget);
  });

  testWidgets('AppCard and SectionHeader render content', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Scaffold(
          body: Column(
            children: [
              SectionHeader(title: 'Upcoming'),
              AppCard(child: Text('Netflix')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Netflix'), findsOneWidget);
  });

  testWidgets('MoneyText shows a formatted amount', (tester) async {
    await tester.pumpWidget(
      _wrap(const Scaffold(body: MoneyText(amount: 22.99, suffix: '/month'))),
    );

    expect(find.text(r'$22.99 /month'), findsOneWidget);
  });

  testWidgets('EmptyState, LoadingState, and ErrorState render', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Scaffold(
          body: EmptyState(
            title: 'No subscriptions',
            message: 'Add your first recurring payment.',
          ),
        ),
      ),
    );
    expect(find.text('No subscriptions'), findsOneWidget);

    await tester.pumpWidget(_wrap(const Scaffold(body: LoadingState())));
    expect(find.text(AppStrings.loading), findsOneWidget);

    var retried = false;
    await tester.pumpWidget(
      _wrap(
        Scaffold(
          body: ErrorState(
            message: 'Could not load data.',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );
    expect(find.text('Could not load data.'), findsOneWidget);
    await tester.tap(find.text(AppStrings.retry));
    expect(retried, isTrue);
  });
}
