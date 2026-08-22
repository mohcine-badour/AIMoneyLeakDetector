import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/features/scanner/data/local_receipt_extraction_backend.dart';
import 'package:billkiller_ai/features/scanner/data/validated_receipt_extractor.dart';
import 'package:billkiller_ai/features/scanner/domain/extracted_receipt.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_extraction_backend.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_extraction_exception.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_extraction_validator.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_extractor.dart';
import 'package:billkiller_ai/features/scanner/domain/receipt_image.dart';
import 'package:billkiller_ai/features/subscriptions/domain/subscription.dart';

class _JsonBackend implements ReceiptExtractionBackend {
  const _JsonBackend(this.json);

  final Map<String, dynamic> json;

  @override
  Future<Map<String, dynamic>> extract(ReceiptImage image) async => json;
}

void main() {
  final image = ReceiptImage(bytes: Uint8List.fromList([1, 2, 3]));

  test('validator accepts the structured OCR JSON contract', () {
    final payload = ReceiptExtractionValidator.parse(
      LocalReceiptExtractionBackend.sampleJson,
    );

    expect(payload.merchant, 'Netflix');
    expect(payload.amount, closeTo(22.99, 0.001));
    expect(payload.currency, 'USD');
    expect(payload.billingCycle, BillingCycle.monthly);
    expect(payload.date, DateTime.utc(2026, 8, 21));
    expect(payload.confidence, closeTo(0.96, 0.001));
  });

  test('validator rejects incomplete or invalid backend JSON', () {
    expect(
      () => ReceiptExtractionValidator.parse({'merchant': ''}),
      throwsA(isA<ReceiptExtractionException>()),
    );
    expect(
      () => ReceiptExtractionValidator.parse({
        ...LocalReceiptExtractionBackend.sampleJson,
        'amount': 0,
      }),
      throwsA(isA<ReceiptExtractionException>()),
    );
    expect(
      () => ReceiptExtractionValidator.parse({
        ...LocalReceiptExtractionBackend.sampleJson,
        'billing_cycle': 'hourly',
      }),
      throwsA(isA<ReceiptExtractionException>()),
    );
    expect(
      () => ReceiptExtractionValidator.parse({
        ...LocalReceiptExtractionBackend.sampleJson,
        'date': '08/21/2026',
      }),
      throwsA(isA<ReceiptExtractionException>()),
    );
    expect(
      () => ReceiptExtractionValidator.parse({
        ...LocalReceiptExtractionBackend.sampleJson,
        'confidence': 1.5,
      }),
      throwsA(isA<ReceiptExtractionException>()),
    );
    expect(
      () => ReceiptExtractionValidator.parse({
        ...LocalReceiptExtractionBackend.sampleJson,
        'currency': 'XYZ',
      }),
      throwsA(isA<ReceiptExtractionException>()),
    );
  });

  test('validated extractor maps backend JSON for user confirmation', () async {
    final extracted = await const ValidatedReceiptExtractor(
      _JsonBackend(LocalReceiptExtractionBackend.sampleJson),
    ).extract(image);

    expect(extracted.merchant, 'Netflix');
    expect(extracted.amount, closeTo(22.99, 0.001));
    expect(extracted.date, DateTime.utc(2026, 8, 21));
    expect(extracted.billingCycle, BillingCycle.monthly);
    expect(extracted.category, SubscriptionCategory.entertainment);
    expect(extracted.confidence, closeTo(0.96, 0.001));
    expect(extracted.confidencePercent, '96%');
  });

  test('validated extractor rejects invalid backend JSON', () async {
    final extractor = ValidatedReceiptExtractor(
      _JsonBackend({...LocalReceiptExtractionBackend.sampleJson, 'amount': -1}),
    );

    await expectLater(
      extractor.extract(image),
      throwsA(isA<ReceiptExtractionException>()),
    );
  });

  test('local backend requires an image and returns validated JSON', () async {
    const backend = LocalReceiptExtractionBackend(delay: Duration.zero);

    await expectLater(
      backend.extract(ReceiptImage(bytes: Uint8List(0))),
      throwsA(isA<ReceiptExtractionException>()),
    );

    final json = await backend.extract(image);
    expect(json, LocalReceiptExtractionBackend.sampleJson);
    expect(() => ReceiptExtractionValidator.parse(json), returnsNormally);
  });

  test('mock extraction still matches the JSON contract', () async {
    final extracted = await const MockReceiptExtractor().extract(image);
    expect(extracted.merchant, ExtractedReceipt.mock().merchant);
    expect(extracted.confidence, closeTo(0.96, 0.001));
  });
}
