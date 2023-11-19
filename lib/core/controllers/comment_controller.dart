
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:instagramclone/core/services/comment_service.dart';

class CommentController extends StateNotifier<List<CommentModel>> {
  CommentController({required CommentService commentService})
      : _commentService = commentService,
        super([]);

  final CommentService _commentService;

  Future<String?> getPostComment(String postId) async {
    String? result;

    try {
      List<CommentModel> comments =
          await _commentService.getPostComment(postId);

      state = comments;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> addComment(String userId, String username, String profileURL,
      String postId, String text) async {
    String? result;

    try {
      List<CommentModel> comments = await _commentService.addComment(
          userId, username, profileURL, postId, text);
      state = comments;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> deleteComment(String postId, String commentId) async {
    String? result;

    try {
      List<CommentModel> comments =
          await _commentService.deleteComment(postId, commentId);
      state = comments;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> likeComment(
      String postId, String commentId, String userId, List likes) async {
    String? result;

    try {
      List<CommentModel> comments =
          await _commentService.likeComment(postId, commentId, userId, likes);
      state = comments;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
