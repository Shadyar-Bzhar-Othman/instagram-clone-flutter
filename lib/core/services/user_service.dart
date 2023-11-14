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

  Future<UserModel> getCurrentUserDetail() async {
    User currentUser = _firebaseAuth.currentUser!;

    final documentSnapshot =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromJson(documentSnapshot);
  }

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
        savedPost: [],
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

  Future<String> savePost(String userId, String postId, List savedPost) async {
    String result = '';
    try {
      if (savedPost.contains(postId)) {
        await _firebaseFirestore.collection('users').doc(userId).update({
          'savedPost': FieldValue.arrayRemove([postId]),
        });
      } else {
        await _firebaseFirestore.collection('users').doc(userId).update({
          'savedPost': FieldValue.arrayUnion([postId]),
        });
      }

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String> followUser(
      String userId, String userFollowId, List following) async {
    String result = '';
    try {
      if (following.contains(userFollowId)) {
        await _firebaseFirestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayRemove([userFollowId]),
        });
        await _firebaseFirestore.collection('users').doc(userFollowId).update({
          'follower': FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firebaseFirestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayUnion([userFollowId]),
        });
        await _firebaseFirestore.collection('users').doc(userFollowId).update({
          'follower': FieldValue.arrayUnion([userId]),
        });
      }

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
