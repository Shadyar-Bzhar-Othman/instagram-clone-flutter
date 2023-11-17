import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/utils/helpers.dart';

class AuthService {
  AuthService(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firebaseFirestore})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  Future<UserModel> login(String email, String password) async {
    UserModel? user;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User currentUser = _firebaseAuth.currentUser!;

      final documentSnapshot = await _firebaseFirestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      user =
          UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } catch (ex) {
      user = null;
      rethrow;
    }

    return user;
  }

  Future<UserModel> signup(String email, String password, String username,
      Uint8List? profileImage) async {
    UserModel? user;

    try {
      if (profileImage == null) {
        throw Exception('Please provide an image');
      }

      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      String profileImageURL = await uploadFileToFirebaseStorage(
          'profilePictures', profileImage, false);

      String userId = authResult.user!.uid;

      UserModel userModel = UserModel(
        userId: userId,
        username: username,
        profileImageURL: profileImageURL,
        email: email,
        bio: '',
        follower: [],
        following: [],
        savedPost: [],
      );

      await _firebaseFirestore.collection('users').doc(userId).set(
            userModel.toJson(),
          );

      user = userModel;
    } catch (ex) {
      user = null;
      rethrow;
    }

    return user;
  }

  Future<UserModel?> signOut() async {
    UserModel? user;

    try {
      await _firebaseAuth.signOut();

      user = null;
    } catch (ex) {
      user = null;
      rethrow;
    }

    return user;
  }
}
