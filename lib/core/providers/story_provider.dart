import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/story_controller.dart';
import 'package:instagramclone/core/dependency_injection.dart';
import 'package:instagramclone/core/models/story_model.dart';
import 'package:instagramclone/core/services/story_service.dart';

final storyProvider =
    StateNotifierProvider<StoryController, List<StoryModel>>((ref) {
  return StoryController(storyService: locator<StoryService>());
});
