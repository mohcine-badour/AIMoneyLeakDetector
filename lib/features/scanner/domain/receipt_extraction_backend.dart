import 'receipt_image.dart';

/// Backend OCR/AI port. Flutter must never send AI API keys through this.
abstract class ReceiptExtractionBackend {
  Future<Map<String, dynamic>> extract(ReceiptImage image);
}
