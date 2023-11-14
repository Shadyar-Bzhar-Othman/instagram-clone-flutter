import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/user_service.dart';

class UserController {
  UserController(UserService userService) : _userService = userService;

  UserService _userService;

  Future<UserModel> getCurrentUserDetail() async {
    return await _userService.getCurrentUserDetail();
  }

  Future<String> login(String email, String password) async {
    return await _userService.login(email, password);
  }

  Future<String> signup(String email, String password, String username,
      Uint8List? profileImage) async {
    return _userService.signup(email, password, username, profileImage);
  }

  Future<String> savePost(String userId, String postId, List savedPost) async {
    String result = await _userService.savePost(userId, postId, savedPost);

    return result;
  }

  Future<String> followUser(
      String userId, String userFollowId, List following) async {
    String result =
        await _userService.followUser(userId, userFollowId, following);

    return result;
  }
}

final userProvider = FutureProvider((ref) async {
  final UserController _userController = UserController(
    UserService(
      firebaseAuth: FirebaseAuth.instance,
      firebaseFirestore: FirebaseFirestore.instance,
    ),
  );

  final UserModel user = await _userController.getCurrentUserDetail();
  return user;
});
