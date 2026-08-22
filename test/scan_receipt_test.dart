import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/router/app_routes.dart';
import 'package:billkiller_ai/core/constants/app_strings.dart';
import 'package:billkiller_ai/features/scanner/domain/extracted_receipt.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_extractor.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_image.dart';
import 'package:billkiller_ai/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

import 'helpers/pump_app.dart';

final _png = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

class _FakePicker implements ReceiptImagePicker {
  _FakePicker(this.image);

  final ReceiptImage image;

  @override
  Future<ReceiptImage?> pickFromCamera() async => image;

  @override
  Future<ReceiptImage?> pickFromGallery() async => image;
}

class _HeldExtractor implements ReceiptExtractor {
  final completer = Completer<ExtractedReceipt>();

  @override
  Future<ExtractedReceipt> extract(ReceiptImage image) => completer.future;
}

void main() {
  final image = ReceiptImage(bytes: _png);

  testWidgets('scan source offers camera and gallery', (tester) async {
    await pumpBillKillerApp(tester, location: AppRoutes.scanReceipt);

    expect(find.text(AppStrings.scanReceiptTitle), findsOneWidget);
    expect(find.text(AppStrings.scanUseCamera), findsOneWidget);
    expect(find.text(AppStrings.scanUseGallery), findsOneWidget);
  });

  testWidgets('add subscription opens the paywall for the scanner', (
    tester,
  ) async {
    await pumpBillKillerApp(tester, location: AppRoutes.addSubscription);

    await tester.ensureVisible(find.text(AppStrings.entryScanReceipt));
    await tester.tap(find.text(AppStrings.entryScanReceipt));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
    expect(find.text(AppStrings.perkReceiptScanner), findsOneWidget);
  });

  testWidgets('preview then processing then extracted mock data', (
    tester,
  ) async {
    final extractor = _HeldExtractor();
    await pumpBillKillerApp(
      tester,
      location: AppRoutes.scanReceipt,
      imagePicker: _FakePicker(image),
      extractor: extractor,
    );

    await tester.tap(find.byKey(const Key('scan-camera')));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(find.text(AppStrings.scanUseThisPhoto), findsOneWidget);

    await tester.tap(find.text(AppStrings.scanUseThisPhoto));
    await tester.pump();

    expect(find.text(AppStrings.scanProcessing), findsOneWidget);
    expect(find.text('Netflix'), findsNothing);

    extractor.completer.complete(ExtractedReceipt.mock());
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.scanExtractedTitle), findsOneWidget);
    expect(find.text(AppStrings.fieldMerchant), findsOneWidget);
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text(AppStrings.fieldAmount), findsOneWidget);
    expect(find.text(r'$22.99'), findsOneWidget);
    expect(find.text(AppStrings.scanFieldDate), findsOneWidget);
    expect(find.text('Aug 21, 2026'), findsOneWidget);
    expect(find.text(AppStrings.scanFieldBilling), findsOneWidget);
    expect(find.text(AppStrings.billingMonthly), findsOneWidget);
    expect(find.text(AppStrings.scanConfidence), findsOneWidget);
    expect(find.text('96%'), findsOneWidget);
  });

  testWidgets('confirm is required before a scanned subscription is saved', (
    tester,
  ) async {
    final harness = await pumpBillKillerApp(
      tester,
      location: AppRoutes.scanReceipt,
      imagePicker: _FakePicker(image),
      extractor: const MockReceiptExtractor(),
    );

    await tester.tap(find.byKey(const Key('scan-gallery')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.scanUseThisPhoto));
    await tester.pumpAndSettle();

    expect(await DriftSubscriptionRepository(harness.$3).getAll(), isEmpty);

    await tester.tap(find.text(AppStrings.scanConfirm));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.beforeYouSubscribeTitle), findsOneWidget);
    expect(await DriftSubscriptionRepository(harness.$3).getAll(), isEmpty);

    await tester.ensureVisible(find.text(AppStrings.addThisSubscription));
    await tester.tap(find.text(AppStrings.addThisSubscription));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.subscriptionsTitle), findsWidgets);
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text(r'$22.99'), findsWidgets);

    final stored = await DriftSubscriptionRepository(harness.$3).getAll();
    expect(stored, hasLength(1));
    expect(stored.first.merchant, 'Netflix');
    expect(stored.first.amount, closeTo(22.99, 0.001));
    expect(stored.first.billingCycle, BillingCycle.monthly);
    expect(stored.first.nextBillingDate, DateTime.utc(2026, 8, 21));
    expect(stored.first.source, SubscriptionSource.scan);
  });
}
