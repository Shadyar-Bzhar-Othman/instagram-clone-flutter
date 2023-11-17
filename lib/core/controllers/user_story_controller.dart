import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/post_service.dart';
import 'package:instagramclone/core/services/user_story_service.dart';

class UserStoryController extends StateNotifier<List<UserModel>> {
  UserStoryController({required UserStoryService userStoryService})
      : _userStoryService = userStoryService,
        super([]);

  final UserStoryService _userStoryService;

  Future<String?> getUserWithActiveStory(String userId) async {
    String? result;

    try {
      List<UserModel> users =
          await _userStoryService.getUserWithActiveStory(userId);

      state = users;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
