import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagramclone/core/models/story_model.dart';
import 'package:instagramclone/utils/helpers.dart';
import 'package:uuid/uuid.dart';

class StoryService {
  StoryService({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  Future<List<StoryModel>> getStories(String userId) async {
    List<StoryModel> stories = [];

    try {
      final storiesSnapshot = await _firebaseFirestore
          .collection('stories')
          .where("userId", isEqualTo: userId)
          .get();

      stories = storiesSnapshot.docs
          .map((story) => StoryModel.fromJson(story.data()))
          .toList();
    } catch (ex) {
      stories = [];
      rethrow;
    }

    return stories;
  }

  Future<List<StoryModel>> addStory(String userId, String username,
      String profileURL, Uint8List? image) async {
    List<StoryModel> stories = [];

    try {
      String storyId = const Uuid().v1();

      String imageURL =
          await uploadFileToFirebaseStorage('stories', image, true);

      StoryModel story = StoryModel(
        userId: userId,
        username: username,
        profileURL: profileURL,
        storyId: storyId,
        imageURL: imageURL,
        datePublished: DateTime.now(),
        viewers: [],
        isActive: true,
      );

      await _firebaseFirestore
          .collection('stories')
          .doc(storyId)
          .set(story.toJson());

      stories = [];
    } catch (ex) {
      stories = [];
      rethrow;
    }

    return stories;
  }

  Future<List<StoryModel>> deleteStory(String storyId) async {
    List<StoryModel> stories = [];

    try {
      await _firebaseFirestore.collection('stories').doc(storyId).delete();

      stories = [];
    } catch (ex) {
      stories = [];
      rethrow;
    }

    return stories;
  }

  Future<List<StoryModel>> viewStory(
      String storyId, String userId, List viewers) async {
    List<StoryModel> stories = [];

    try {
      if (!viewers.contains(userId)) {
        await _firebaseFirestore.collection('stories').doc(storyId).update({
          'viewers': FieldValue.arrayUnion([userId]),
        });
      }

      stories = [];
    } catch (ex) {
      stories = [];
      rethrow;
    }

    return stories;
  }

  Future<List<StoryModel>> changeStoryState(String storyId) async {
    List<StoryModel> stories = [];

    try {
      await _firebaseFirestore.collection('stories').doc(storyId).update({
        'isActive': false,
      });

      stories = [];
    } catch (ex) {
      stories = [];
      rethrow;
    }

    return stories;
  }
}
