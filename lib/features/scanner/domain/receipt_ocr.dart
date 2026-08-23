import 'receipt_image.dart';

/// On-device text recognition. Implementations must not call an AI provider.
abstract class ReceiptOcr {
  Future<String> recognize(ReceiptImage image);
}
