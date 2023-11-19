import 'dart:typed_data';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentUserController extends StateNotifier<UserModel?> {
  CurrentUserController({required UserService userService})
      : _userService = userService,
        super(null);

  final UserService _userService;

  Future<String?> getCurrentUserDetail() async {
    String? result;

    try {
      UserModel user = await _userService.getCurrentUserDetail();

      state = user;

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

      state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}

// SpecificUserController
class SpecificUserController extends StateNotifier<UserModel?> {
  SpecificUserController({required UserService userService})
      : _userService = userService,
        super(null);

  final UserService _userService;

  Future<String?> getUserDetailById(String userId) async {
    String? result;

    try {
      UserModel user = await _userService.getUserDetailById(userId);

      state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> followUser(
      String userFollowId, String userId, List follower) async {
    String? result;

    try {
      UserModel user =
          await _userService.followUser(userFollowId, userId, follower);

      state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}

// ListUsersController
class ListUsersController extends StateNotifier<List<UserModel>> {
  ListUsersController({required UserService userService})
      : _userService = userService,
        super([]);

  final UserService _userService;

  Future<String?> searchUserByUsername(String username) async {
    String? result;

    try {
      List<UserModel> users = await _userService.searchUserByUsername(username);

      state = users;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
