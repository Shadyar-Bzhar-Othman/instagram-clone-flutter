import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/post_controller.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/post_service.dart';
import 'package:instagramclone/core/services/user_service.dart';
import 'package:instagramclone/ui/shared/dialogs/dialogs.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/helpers.dart';

class AddPostPage extends ConsumerStatefulWidget {
  const AddPostPage({super.key, required this.changePage});

  final Function(int index) changePage;

  @override
  ConsumerState<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends ConsumerState<AddPostPage> {
  final PostController _postController = PostController(
    postService: PostService(firebaseFirestore: FirebaseFirestore.instance),
  );

  Uint8List? _selectedImage;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  void selectImage() async {
    final selectedImage = await showImagePickerDialog(context);

    if (selectedImage != null) {
      setState(() {
        _selectedImage = selectedImage;
      });
    }
  }

  void post() async {
    setState(() {
      _isLoading = true;
    });

    final currentUserValue = ref.read(userProvider);

    currentUserValue.whenData((currentUser) async {
      final descreption = _captionController.text;

      final result = await _postController.addPost(
        currentUser.userId,
        currentUser.username,
        currentUser.profileImageURL,
        _selectedImage,
        descreption,
      );

      setState(() {
        _isLoading = false;
      });

      if (result != 'Success') {
        showSnackbar(context, result);
        return;
      }

      widget.changePage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _selectedImage != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: const Text('Add Post'),
              actions: [
                TextButton(
                  onPressed: post,
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading ? const LinearProgressIndicator() : Container(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 100,
                      child: Image.memory(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _captionController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          hintStyle: TextStyle(color: secondaryColor),
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        : Center(
            child: IconButton(
              onPressed: selectImage,
              icon: const Icon(
                Icons.upload,
              ),
            ),
          );
  }
}
