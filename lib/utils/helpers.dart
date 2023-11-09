import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  ImagePicker imagePicker = ImagePicker();

  XFile? selectedImage = await imagePicker.pickImage(source: source);

  if (selectedImage != null) {
    return selectedImage.readAsBytes();
  }
}
