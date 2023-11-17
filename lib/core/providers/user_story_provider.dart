import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/user_story_controller.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/user_story_service.dart';

final userStoryProvider =
    StateNotifierProvider<UserStoryController, List<UserModel>>((ref) {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  UserStoryService userStoryService =
      UserStoryService(firebaseFirestore: firebaseFirestore);

  return UserStoryController(userStoryService: userStoryService);
});
