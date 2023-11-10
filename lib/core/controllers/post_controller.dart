import 'dart:typed_data';

import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/services/post_service.dart';

class PostController {
  final PostService _postService;

  PostController({required PostService postService})
      : _postService = postService;

  // Future<List<Post>> getPosts() async {
  //   List<Post> posts = await _postService.getPosts();

  //   return posts;
  // }

  Future<String> addPost(String userId, String username, String profileURL,
      Uint8List? image, String description) async {
    String result = await _postService.addPost(
        userId, username, profileURL, image, description);

    return result;
  }

  Future<String> deletePost(String postId) async {
    String result = await _postService.deletePost(postId);

    return result;
  }

  Future<String> likePost(String postId, String userId, List likes) async {
    String result = await _postService.likePost(postId, userId, likes);

    return result;
  }
}
