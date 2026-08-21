import 'extracted_receipt.dart';
import 'receipt_image.dart';

/// Port for receipt extraction. Implementations must not embed AI API keys.
abstract class ReceiptExtractor {
  Future<ExtractedReceipt> extract(ReceiptImage image);
}

class MockReceiptExtractor implements ReceiptExtractor {
  const MockReceiptExtractor({this.delay = Duration.zero});

  final Duration delay;

  @override
  Future<ExtractedReceipt> extract(ReceiptImage image) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return ExtractedReceipt.mock();
  }
}
