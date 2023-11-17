import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/comment_controller.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:instagramclone/core/services/comment_service.dart';

final commentProvider =
    StateNotifierProvider<CommentController, List<CommentModel>>((ref) {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  CommentService commentService =
      CommentService(firebaseFirestore: firebaseFirestore);

  return CommentController(commentService: commentService);
});
