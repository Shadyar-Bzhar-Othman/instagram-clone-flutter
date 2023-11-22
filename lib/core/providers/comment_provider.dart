import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/comment_controller.dart';
import 'package:instagramclone/core/dependency_injection.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:instagramclone/core/services/comment_service.dart';

final commentProvider =
    StateNotifierProvider<CommentController, List<CommentModel>>((ref) {
  return CommentController(commentService: locator<CommentService>());
});
