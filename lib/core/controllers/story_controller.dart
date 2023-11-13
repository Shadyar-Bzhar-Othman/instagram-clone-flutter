import 'dart:typed_data';

import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/story_model.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/post_service.dart';
import 'package:instagramclone/core/services/story_service.dart';

class StoryController {
  final StoryService _storyService;

  StoryController({required StoryService storyService})
      : _storyService = storyService;

  Future<List<UserModel>> getUserWithActiveStory(String userId) async {
    List<UserModel> users = await _storyService.getUserWithActiveStory(userId);

    return users;
  }

  Future<List<StoryModel>> getStories(String userId) async {
    List<StoryModel> stories = await _storyService.getStories(userId);

    return stories;
  }

  Future<String> addStory(String userId, String username, String profileURL,
      Uint8List? image) async {
    String result =
        await _storyService.addStory(userId, username, profileURL, image);

    return result;
  }

  Future<String> deleteStory(String storyId) async {
    String result = await _storyService.deleteStory(storyId);

    return result;
  }

  Future<String> viewStory(String storyId, String userId, List viewers) async {
    String result = await _storyService.viewStory(storyId, userId, viewers);

    return result;
  }
}
