import 'dart:typed_data';

class ReceiptImage {
  const ReceiptImage({required this.bytes, this.path});

  final Uint8List bytes;
  final String? path;
}

abstract class ReceiptImagePicker {
  Future<ReceiptImage?> pickFromCamera();

  Future<ReceiptImage?> pickFromGallery();
}
