import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:uuid/uuid.dart';

class CommentService {
  CommentService({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  Future<List<CommentModel>> getPostComment(String postId) async {
    List<CommentModel> comments = [];

    try {
      final querySnapshot = await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      comments = querySnapshot.docs
          .map((user) => CommentModel.fromJson(user.data()))
          .toList();
    } catch (ex) {
      comments = [];
      rethrow;
    }

    return comments;
  }

  Future<List<CommentModel>> addComment(String userId, String username,
      String profileURL, String postId, String text) async {
    List<CommentModel> comments = [];

    try {
      String commentId = const Uuid().v1();

      CommentModel comment = CommentModel(
        userId: userId,
        username: username,
        profileURL: profileURL,
        commentId: commentId,
        text: text,
        datePublished: DateTime.now(),
        likes: [],
      );

      await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(comment.toJson());

      comments = await getPostComment(postId);
    } catch (ex) {
      comments = [];
      rethrow;
    }

    return comments;
  }

  Future<List<CommentModel>> deleteComment(
      String postId, String commentId) async {
    List<CommentModel> comments = [];

    try {
      await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      comments = await getPostComment(postId);
    } catch (ex) {
      comments = [];
      rethrow;
    }

    return comments;
  }

  Future<List<CommentModel>> likeComment(
      String postId, String commentId, String userId, List likes) async {
    List<CommentModel> comments = [];

    try {
      if (likes.contains(userId)) {
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([userId]),
        });
      }

      comments = await getPostComment(postId);
    } catch (ex) {
      comments = [];
      rethrow;
    }

    return comments;
  }
}
