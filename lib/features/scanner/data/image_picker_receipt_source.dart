import 'package:image_picker/image_picker.dart';

import '../domain/receipt_image.dart';

class ImagePickerReceiptSource implements ReceiptImagePicker {
  ImagePickerReceiptSource([ImagePicker? picker])
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<ReceiptImage?> pickFromCamera() => _pick(ImageSource.camera);

  @override
  Future<ReceiptImage?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<ReceiptImage?> _pick(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 85);
    if (file == null) {
      return null;
    }
    return ReceiptImage(bytes: await file.readAsBytes(), path: file.path);
  }
}
