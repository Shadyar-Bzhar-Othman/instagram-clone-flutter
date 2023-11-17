import 'dart:typed_data';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserController {
  UserController({required WidgetRef ref, required UserService userService})
      : _ref = ref,
        _userService = userService;

  final WidgetRef _ref;
  final UserService _userService;

  Future<String?> getCurrentUserDetail() async {
    String? result;

    try {
      UserModel user = await _userService.getCurrentUserDetail();

      _ref.read(currentUserProvider.notifier).state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> getUserDetailById(String userId) async {
    String? result;

    try {
      UserModel user = await _userService.getUserDetailById(userId);

      _ref.read(userProvider.notifier).state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> searchUserByUsername(String username) async {
    String? result;

    try {
      List<UserModel> users = await _userService.searchUserByUsername(username);

      _ref.read(usersProvider.notifier).state = users;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> followUser(
      String userId, String userFollowId, List following) async {
    String? result;

    try {
      UserModel user =
          await _userService.followUser(userId, userFollowId, following);

      _ref.read(userProvider.notifier).state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> updateUser(
    String userId,
    String username,
    Uint8List? profileImage,
    String bio,
  ) async {
    String? result;

    try {
      UserModel user =
          await _userService.updateUser(userId, username, profileImage, bio);

      _ref.read(currentUserProvider.notifier).state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> savePost(String userId, String postId, List savedPost) async {
    String? result;

    try {
      UserModel user = await _userService.savePost(userId, postId, savedPost);

      _ref.read(userProvider.notifier).state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
