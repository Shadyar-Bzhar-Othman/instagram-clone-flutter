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
    UserModel? user;

    try {
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

  Future<UserModel> getUserDetailById(String userId) async {
    UserModel? user;

    try {
      final documentSnapshot =
          await _firebaseFirestore.collection('users').doc(userId).get();

      user =
          UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } catch (ex) {
      user = null;
      rethrow;
    }

    return user;
  }

  Future<List<UserModel>> searchUserByUsername(String username) async {
    List<UserModel> users = [];

    try {
      final querySnapshot = await _firebaseFirestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: username)
          .get();

      users = querySnapshot.docs
          .map((user) => UserModel.fromJson(user.data()))
          .toList();
    } catch (ex) {
      users = [];
      rethrow;
    }

    return users;
  }

  Future<UserModel> followUser(
      String userFollowId, String userId, List follower) async {
    UserModel? user;

    try {
      if (follower.contains(userId)) {
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

      user = await getUserDetailById(userFollowId);
    } catch (ex) {
      user = null;
      rethrow;
    }
    return user;
  }

  Future<UserModel> updateUser(
    String userId,
    String username,
    Uint8List? profileImage,
    String bio,
  ) async {
    UserModel? user;

    try {
      if (profileImage == null) {
        await _firebaseFirestore.collection('users').doc(userId).update({
          'username': username,
          'bio': bio,
        });
      } else {
        String profileImageURL = await AppHelpers.uploadFileToFirebaseStorage(
            'profilePictures', profileImage, false);

        await _firebaseFirestore.collection('users').doc(userId).update({
          'username': username,
          'profileImageURL': profileImageURL,
          'bio': bio,
        });
      }
      user = await getUserDetailById(userId);
    } catch (ex) {
      user = null;
      rethrow;
    }

    return user;
  }
}
