import 'package:flutter/services.dart';

import '../domain/receipt_extraction_exception.dart';
import '../domain/receipt_image.dart';
import '../domain/receipt_ocr.dart';

/// Reads receipt text on this phone. Does not send the image off-device.
class VisionReceiptOcr implements ReceiptOcr {
  const VisionReceiptOcr();

  static const _channel = MethodChannel('kichta/receipt_ocr');

  @override
  Future<String> recognize(ReceiptImage image) async {
    try {
      final text = await _channel.invokeMethod<String>('recognize', {
        if (image.path != null && image.path!.isNotEmpty) 'path': image.path,
        if (image.path == null || image.path!.isEmpty) 'bytes': image.bytes,
      });
      if (text == null || text.trim().isEmpty) {
        throw const ReceiptExtractionException('no text found');
      }
      return text;
    } on ReceiptExtractionException {
      rethrow;
    } on PlatformException catch (error) {
      throw ReceiptExtractionException(error.message ?? 'no text found');
    }
  }
}
