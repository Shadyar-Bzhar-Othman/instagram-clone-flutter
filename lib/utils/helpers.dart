import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

Future<String> uploadFileToFirebaseStorage(
    String folderName, Uint8List? file, bool isPost) async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Reference ref = firebaseStorage
      .ref()
      .child(folderName)
      .child(firebaseAuth.currentUser!.uid);

  if (isPost) {
    String postId = const Uuid().v1();
    ref = ref.child(postId);
  }

  final uploadedFile = await ref.putData(file!);

  String imageURL = await uploadedFile.ref.getDownloadURL();

  return imageURL;
}

Future<Uint8List?> pickImage(ImageSource source) async {
  ImagePicker imagePicker = ImagePicker();

  XFile? selectedImage = await imagePicker.pickImage(source: source);

  if (selectedImage != null) {
    return selectedImage.readAsBytes();
  }
  return null;
}
