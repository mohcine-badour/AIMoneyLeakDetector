import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/scanner/data/on_device_receipt_extraction_backend.dart';
import 'package:kichta/features/scanner/domain/receipt_extraction_exception.dart';
import 'package:kichta/features/scanner/domain/receipt_extraction_validator.dart';
import 'package:kichta/features/scanner/domain/receipt_image.dart';
import 'package:kichta/features/scanner/domain/receipt_ocr.dart';
import 'package:kichta/features/scanner/domain/receipt_text_parser.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';

class _FixedOcr implements ReceiptOcr {
  const _FixedOcr(this.text);

  final String text;

  @override
  Future<String> recognize(ReceiptImage image) async => text;
}

void main() {
  final now = DateTime.utc(2026, 8, 23);

  test('parses a Spotify receipt instead of the Netflix sample', () {
    final json = ReceiptTextParser.parse(
      '''
Spotify
Premium
Total \$10.99
Billed monthly
Jan 15, 2026
''',
      now: now,
    );

    expect(json['merchant'], 'Spotify');
    expect(json['amount'], closeTo(10.99, 0.001));
    expect(json['currency'], 'USD');
    expect(json['billing_cycle'], BillingCycle.monthly.name);
    expect(json['date'], '2026-01-15');
    expect(
      () => ReceiptExtractionValidator.parse(json),
      returnsNormally,
    );
  });

  test('reads ChatGPT Plus and a yearly euro amount', () {
    final json = ReceiptTextParser.parse(
      '''
ChatGPT Plus
Amount due 22,00 EUR
Annual plan
03/04/2026
''',
      now: now,
    );

    expect(json['merchant'], 'ChatGPT Plus');
    expect(json['amount'], closeTo(22.00, 0.001));
    expect(json['currency'], 'EUR');
    expect(json['billing_cycle'], BillingCycle.yearly.name);
    expect(json['date'], '2026-03-04');
  });

  test('uses today when the receipt has no date', () {
    final json = ReceiptTextParser.parse(
      '''
Notion
\$12.00 /mo
''',
      now: now,
    );

    expect(json['merchant'], 'Notion');
    expect(json['date'], '2026-08-23');
    expect(json['billing_cycle'], BillingCycle.monthly.name);
  });

  test('rejects empty or amount-less text', () {
    expect(
      () => ReceiptTextParser.parse('   ', now: now),
      throwsA(isA<ReceiptExtractionException>()),
    );
    expect(
      () => ReceiptTextParser.parse('Netflix\nThank you', now: now),
      throwsA(isA<ReceiptExtractionException>()),
    );
  });

  test('on-device backend parses OCR text from the photo', () async {
    final backend = OnDeviceReceiptExtractionBackend(
      const _FixedOcr('Hulu\nTotal \$17.99\nMonthly\n2026-02-01'),
      now: now,
    );

    final json = await backend.extract(
      ReceiptImage(bytes: Uint8List.fromList([1, 2, 3])),
    );

    expect(json['merchant'], 'Hulu');
    expect(json['amount'], closeTo(17.99, 0.001));
    expect(json['date'], '2026-02-01');
  });
}
