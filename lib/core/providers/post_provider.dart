import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/post_controller.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/services/post_service.dart';

final postProvider =
    StateNotifierProvider<PostController, List<PostModel>>((ref) {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  PostService postService = PostService(firebaseFirestore: firebaseFirestore);

  return PostController(postService: postService);
});
