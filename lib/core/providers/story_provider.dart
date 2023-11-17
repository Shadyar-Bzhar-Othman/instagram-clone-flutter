import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/story_controller.dart';
import 'package:instagramclone/core/models/story_model.dart';
import 'package:instagramclone/core/services/story_service.dart';

final storyProvider =
    StateNotifierProvider<StoryController, List<StoryModel>>((ref) {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  StoryService storyService =
      StoryService(firebaseFirestore: firebaseFirestore);

  return StoryController(storyService: storyService);
});
