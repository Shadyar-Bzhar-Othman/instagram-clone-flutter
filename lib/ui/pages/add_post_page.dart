import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/providers/post_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/ui/shared/dialogs/image_picker_dialog.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/utils/colors.dart';

class AddPostPage extends ConsumerStatefulWidget {
  const AddPostPage({super.key, required this.changePage});

  final Function(int index) changePage;

  @override
  ConsumerState<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends ConsumerState<AddPostPage> {
  Uint8List? _selectedImage;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  void selectImage() async {
    final selectedImage = await showImagePickerDialog(context);

    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void postAndNavigateToFeed() async {
    setState(() {
      _isLoading = true;
    });

    final currentUserData = ref.read(currentUserProvider)!;

    final descreption = _captionController.text;

    final result = await ref.read(postProvider.notifier).addPost(
          currentUserData.userId,
          currentUserData.username,
          currentUserData.profileImageURL,
          _selectedImage,
          descreption,
        );

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      showSnackbar(context, result);
      return;
    }

    widget.changePage(0);
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _selectedImage != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              title: const Text('Add Post'),
              actions: [
                TextButton(
                  onPressed: _isLoading ? null : postAndNavigateToFeed,
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: _isLoading ? Colors.grey : AppColors.blueColor,
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
                    SizedBox(
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
                          hintStyle: TextStyle(color: AppColors.secondaryColor),
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
