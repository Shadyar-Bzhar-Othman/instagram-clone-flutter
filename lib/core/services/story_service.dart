import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/story_model.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/utils/helpers.dart';
import 'package:uuid/uuid.dart';

// IK Bad Code for getUserWithActiveStory, I'll fix it later

class StoryService {
  StoryService({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  Future<List<UserModel>> getUserWithActiveStory(String userId) async {
    List<UserModel> users = [];

    String result = '';
    try {
      List<UserModel> followingUsers = [];
      List<StoryModel> stories = [];
      Map<UserModel, dynamic> userCounter = {};

      QuerySnapshot usersSnapshot = await _firebaseFirestore
          .collection('users')
          .where("userId", isEqualTo: userId)
          .get();

      followingUsers = usersSnapshot.docs
          .map((user) => UserModel.fromQueryDocumentSnapshot(user))
          .toList();

      followingUsers.forEach((user) {
        userCounter[user] = 0;
      });

      QuerySnapshot activeStoriesSnapshot = await _firebaseFirestore
          .collection('stories')
          .where("isActive", isEqualTo: true)
          .get();

      stories = activeStoriesSnapshot.docs
          .map((story) => StoryModel.fromQueryDocumentSnapshot(story))
          .toList();

      followingUsers.forEach((user) {
        stories.forEach((story) {
          if (user.userId == story.storyId) {
            userCounter[user] += 1;
          }
        });
      });

      userCounter.forEach((key, value) {
        if (value > 0) {
          users.add(key);
        }
      });

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return users;
  }

  Future<List<StoryModel>> getStories(String userId) async {
    List<StoryModel> stories = [];

    String result = '';
    try {
      QuerySnapshot storiesSnapshot = await _firebaseFirestore
          .collection('stories')
          .where("userId", isEqualTo: userId)
          .get();

      stories = storiesSnapshot.docs
          .map((story) => StoryModel.fromQueryDocumentSnapshot(story))
          .toList();

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return stories;
  }

  Future<String> addStory(String userId, String username, String profileURL,
      Uint8List? image) async {
    String result = '';
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

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String> deleteStory(String storyId) async {
    String result = '';
    try {
      await _firebaseFirestore.collection('stories').doc(storyId).delete();

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String> viewStory(String storyId, String userId, List viewers) async {
    String result = '';
    try {
      if (!viewers.contains(userId)) {
        await _firebaseFirestore.collection('stories').doc(storyId).update({
          'viewers': FieldValue.arrayUnion([userId]),
        });
      }

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String> changeStoryState(String storyId) async {
    String result = '';
    try {
      await _firebaseFirestore.collection('stories').doc(storyId).update({
        'isActive': false,
      });

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
