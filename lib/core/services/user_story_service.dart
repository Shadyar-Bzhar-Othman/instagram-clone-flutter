import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramclone/core/models/user_model.dart';

class UserStoryService {
  UserStoryService({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  Future<List<UserModel>> getUserWithActiveStory(String userId) async {
    List<UserModel> users = [];
    List<DocumentSnapshot> activeUsersWithStories = [];

    try {
      DocumentSnapshot currentUserSnapshot =
          await _firebaseFirestore.collection('users').doc(userId).get();

      UserModel currentUser = UserModel.fromJson(
          currentUserSnapshot.data() as Map<String, dynamic>);

      users.add(currentUser);

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

      users.addAll(activeUsersWithStories
          .map(
            (user) => UserModel.fromJson(user.data() as Map<String, dynamic>),
          )
          .toList());
    } catch (ex) {
      users = [];
      rethrow;
    }

    return users;
  }
}
