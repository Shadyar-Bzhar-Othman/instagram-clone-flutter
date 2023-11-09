import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/utils/helpers.dart';

class UserService {
  UserService(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  Future<String> login(String email, String password) async {
    String result = '';
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }
    return result;
  }

  Future<String> signup(String email, String password, String username,
      Uint8List? profileImage) async {
    String result = '';
    try {
      if (profileImage == null) {
        throw Exception('Please provide an image');
      }

      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      String profileImageURL = await uploadFileToFirebaseStorage(
          'profilePictures', profileImage, false);

      String userId = authResult.user!.uid;

      UserModel user = UserModel(
        userId: userId,
        username: username,
        profileImageURL: profileImageURL,
        email: email,
        bio: '',
        follower: [],
        following: [],
      );

      await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .set(user.toJson());

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }
    return result;
  }
}
