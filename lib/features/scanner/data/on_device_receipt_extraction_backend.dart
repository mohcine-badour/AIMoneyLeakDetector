import '../domain/receipt_extraction_backend.dart';
import '../domain/receipt_extraction_exception.dart';
import '../domain/receipt_image.dart';
import '../domain/receipt_ocr.dart';
import '../domain/receipt_text_parser.dart';

/// OCR on this phone, then deterministic parsing. No AI credentials.
class OnDeviceReceiptExtractionBackend implements ReceiptExtractionBackend {
  const OnDeviceReceiptExtractionBackend(this._ocr, {this.now});

  final ReceiptOcr _ocr;
  final DateTime? now;

  @override
  Future<Map<String, dynamic>> extract(ReceiptImage image) async {
    if (image.bytes.isEmpty && (image.path == null || image.path!.isEmpty)) {
      throw const ReceiptExtractionException('image is required');
    }
    final text = await _ocr.recognize(image);
    return ReceiptTextParser.parse(text, now: now);
  }
}
