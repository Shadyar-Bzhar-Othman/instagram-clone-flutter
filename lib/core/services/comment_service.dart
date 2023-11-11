import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:uuid/uuid.dart';

class CommentService {
  CommentService({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  Future<String> addComment(String userId, String username, String profileURL,
      String postId, String text) async {
    String result = '';
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

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String> deleteComment(String postId, String commentId) async {
    String result = '';
    try {
      await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String> likeComment(
      String postId, String commentId, String userId, List likes) async {
    String result = '';
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

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
