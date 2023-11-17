import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/services/post_service.dart';

class PostController extends StateNotifier<List<PostModel>> {
  PostController({required PostService postService})
      : _postService = postService,
        super([]);

  final PostService _postService;

  Future<String?> getAllPost() async {
    String? result;

    try {
      List<PostModel> posts = await _postService.getAllPost();

      // Update the state to get all posts
      state = posts;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> getUserPost(String userId) async {
    String? result;

    try {
      List<PostModel> posts = await _postService.getUserPost(userId);

      // Update the state to get user posts, because It'll be complex if I separate it
      state = posts;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> addPost(String userId, String username, String profileURL,
      Uint8List? image, String description) async {
    String? result;

    try {
      List<PostModel> posts = await _postService.addPost(
          userId, username, profileURL, image, description);
      state = posts;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> deletePost(String postId) async {
    String? result;

    try {
      List<PostModel> posts = await _postService.deletePost(postId);
      state = posts;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> likePost(String postId, String userId, List likes) async {
    String? result;

    try {
      List<PostModel> posts =
          await _postService.likePost(postId, userId, likes);
      state = posts;
      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
