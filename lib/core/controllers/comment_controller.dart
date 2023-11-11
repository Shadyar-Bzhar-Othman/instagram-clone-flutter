import 'dart:typed_data';

import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/services/comment_service.dart';
import 'package:instagramclone/core/services/post_service.dart';

class CommentController {
  final CommentService _commentService;

  CommentController({required CommentService commentService})
      : _commentService = commentService;

  Future<String> addComment(String userId, String username, String profileURL,
      String postId, String text) async {
    String result = await _commentService.addComment(
        userId, username, profileURL, postId, text);

    return result;
  }

  Future<String> deleteComment(String postId, String commentId) async {
    String result = await _commentService.deleteComment(postId, commentId);

    return result;
  }

  Future<String> likeComment(
      String postId, String commentId, String userId, List likes) async {
    String result =
        await _commentService.likeComment(postId, commentId, userId, likes);

    return result;
  }
}
