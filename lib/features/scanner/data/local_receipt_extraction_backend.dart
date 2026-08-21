import '../domain/receipt_extraction_backend.dart';
import '../domain/receipt_extraction_exception.dart';
import '../domain/receipt_extraction_validator.dart';
import '../domain/receipt_image.dart';

/// Local stand-in for the OCR/AI backend.
///
/// It returns structured JSON and validates it here so the Flutter app never
/// holds AI credentials. A remote HTTP client replaces this in a later step.
class LocalReceiptExtractionBackend implements ReceiptExtractionBackend {
  const LocalReceiptExtractionBackend({
    this.delay = const Duration(milliseconds: 800),
  });

  static const Map<String, dynamic> sampleJson = {
    'merchant': 'Netflix',
    'amount': 22.99,
    'currency': 'USD',
    'billing_cycle': 'monthly',
    'date': '2026-08-21',
    'confidence': 0.96,
  };

  final Duration delay;

  @override
  Future<Map<String, dynamic>> extract(ReceiptImage image) async {
    if (image.bytes.isEmpty) {
      throw const ReceiptExtractionException('image is required');
    }
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    ReceiptExtractionValidator.parse(sampleJson);
    return Map<String, dynamic>.from(sampleJson);
  }
}
