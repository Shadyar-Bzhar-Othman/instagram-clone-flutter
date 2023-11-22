import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/post_controller.dart';
import 'package:instagramclone/core/dependency_injection.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/services/post_service.dart';

final postProvider =
    StateNotifierProvider<PostController, List<PostModel>>((ref) {
  return PostController(postService: locator<PostService>());
});
