import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('add subscription does not offer receipt scan', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.addSubscription);

    expect(find.text(AppStrings.entryScanReceipt), findsNothing);
    expect(find.byKey(const Key('scan-receipt')), findsNothing);
  });

  testWidgets('scan route is not shipped', (tester) async {
    await pumpKichtaApp(tester, location: AppRoutes.scanReceipt);

    expect(find.text(AppStrings.scanReceiptTitle), findsNothing);
    expect(find.text(AppStrings.scanUseCamera), findsNothing);
    expect(find.text(AppStrings.subscriptionNotFound), findsOneWidget);
  });
}
