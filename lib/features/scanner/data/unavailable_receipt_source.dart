import '../domain/receipt_image.dart';

/// Camera and photo library are not offered in this version.
class UnavailableReceiptPicker implements ReceiptImagePicker {
  const UnavailableReceiptPicker();

  @override
  Future<ReceiptImage?> pickFromCamera() async => null;

  @override
  Future<ReceiptImage?> pickFromGallery() async => null;
}
