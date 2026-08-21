import '../domain/extracted_receipt.dart';
import '../domain/receipt_extraction_backend.dart';
import '../domain/receipt_extraction_validator.dart';
import '../domain/receipt_extractor.dart';
import '../domain/receipt_image.dart';

/// Turns validated backend JSON into a receipt the user can confirm.
class ValidatedReceiptExtractor implements ReceiptExtractor {
  const ValidatedReceiptExtractor(this._backend);

  final ReceiptExtractionBackend _backend;

  @override
  Future<ExtractedReceipt> extract(ReceiptImage image) async {
    final json = await _backend.extract(image);
    return ExtractedReceipt.fromPayload(ReceiptExtractionValidator.parse(json));
  }
}
