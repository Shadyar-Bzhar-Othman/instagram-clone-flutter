import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/ui/shared/dialogs/dialogs.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/helpers.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  Uint8List? _selectedImage;
  TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  void selectImage() async {
    final selectedImage = await showImagePickerDialog(context);

    if (selectedImage != null) {
      setState(() {
        _selectedImage = selectedImage;
      });
    }
  }

  void post() {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
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
                        controller: _controller,
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
