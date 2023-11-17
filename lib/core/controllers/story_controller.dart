import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/story_model.dart';
import 'package:instagramclone/core/services/story_service.dart';

class StoryController extends StateNotifier<List<StoryModel>> {
  StoryController({required StoryService storyService})
      : _storyService = storyService,
        super([]);

  final StoryService _storyService;

  Future<String?> getStories(String userId) async {
    String? result;

    try {
      List<StoryModel> stories = await _storyService.getStories(userId);

      state = stories;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> addStory(String userId, String username, String profileURL,
      Uint8List? image) async {
    String? result;

    try {
      List<StoryModel> stories =
          await _storyService.addStory(userId, username, profileURL, image);

      // I don't update the state because this state doesn't need to change just user story must change

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> deleteStory(String storyId) async {
    String? result;

    try {
      List<StoryModel> stories = await _storyService.deleteStory(storyId);

      // I don't update the state because this state doesn't need to change just user story must change

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> viewStory(String storyId, String userId, List viewers) async {
    String? result;

    try {
      List<StoryModel> stories =
          await _storyService.viewStory(storyId, userId, viewers);

      // I don't update the state because this state doesn't need to change just user story must change

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> changeStoryState(String storyId) async {
    String? result;

    try {
      List<StoryModel> stories = await _storyService.changeStoryState(storyId);

      // I don't update the state because this state doesn't need to change just user story must change

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
