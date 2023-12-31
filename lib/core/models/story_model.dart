
class StoryModel {
  final String userId;
  final String username;
  final String profileURL;
  final String storyId;
  final String imageURL;
  final datePublished;
  final List viewers;
  final bool isActive;

  StoryModel({
    required this.userId,
    required this.username,
    required this.profileURL,
    required this.storyId,
    required this.imageURL,
    required this.datePublished,
    required this.viewers,
    required this.isActive,
  });

  factory StoryModel.fromJson(Map<String, dynamic> snapshotData) {
    return StoryModel(
      userId: snapshotData['userId'],
      username: snapshotData['username'],
      profileURL: snapshotData['profileURL'],
      storyId: snapshotData['storyId'],
      imageURL: snapshotData['imageURL'],
      datePublished: snapshotData['datePublished'],
      viewers: snapshotData['viewers'],
      isActive: snapshotData['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'profileURL': profileURL,
      'storyId': storyId,
      'imageURL': imageURL,
      'datePublished': datePublished,
      'viewers': viewers,
      'isActive': isActive,
    };
  }
}
