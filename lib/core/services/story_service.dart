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
    List<UserModel> allActiveUsersWithStories = [];
    List<DocumentSnapshot> activeUsersWithStories = [];

    String result = '';
    try {
      DocumentSnapshot currentUserSnapshot =
          await _firebaseFirestore.collection('users').doc(userId).get();

      UserModel currentUser = UserModel.fromJson(currentUserSnapshot);

      allActiveUsersWithStories.add(currentUser);

      List following = [currentUser.userId, ...currentUser.following];

      for (String userId in following) {
        QuerySnapshot userStories = await _firebaseFirestore
            .collection('stories')
            .where('userId', isEqualTo: userId)
            .get();

        List<DocumentSnapshot> activeStories = userStories.docs
            .where((story) => story['isActive'] == true)
            .toList();

        if (activeStories.length > 0) {
          activeUsersWithStories.add(
              await _firebaseFirestore.collection('users').doc(userId).get());
        }
      }

      allActiveUsersWithStories.addAll(activeUsersWithStories
          .map(
            (user) => UserModel.fromJson(user),
          )
          .toList());

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return allActiveUsersWithStories;
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
