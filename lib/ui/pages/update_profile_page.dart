import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/ui/shared/dialogs/dialogs.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/shared_button.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/consts.dart';
import 'package:instagramclone/utils/validators.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = '';
  String _bio = '';
  String _ImageURL = '';
  Uint8List? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _ImageURL = widget.user.profileImageURL;
    _username = widget.user.username;
    _bio = widget.user.bio;
  }

  void updateProfile() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    String? result = await ref
        .read(currentUserProvider.notifier)
        .updateUser(widget.user.userId, _username, _profileImage, _bio);

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      showSnackbar(context, result);
      return;
    }

    Navigator.pop(context);
  }

  Future<void> pickProfileImage() async {
    Uint8List? selectedImage = await showImagePickerDialog(context);

    setState(() {
      _profileImage = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Update Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Stack(
              children: [
                _profileImage != null
                    ? CircleAvatar(
                        radius: 45,
                        backgroundColor: secondaryColor,
                        backgroundImage: MemoryImage(_profileImage!),
                      )
                    : CircleAvatar(
                        radius: 45,
                        backgroundColor: secondaryColor,
                        backgroundImage: NetworkImage(_ImageURL),
                      ),
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: IconButton(
                    onPressed: pickProfileImage,
                    icon: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _username,
                    decoration: customFormTextFieldStyle(context, 'Username'),
                    validator: (value) {
                      return validateUsername(value!);
                    },
                    onSaved: (newValue) {
                      _username = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    initialValue: _bio,
                    decoration: customFormTextFieldStyle(context, 'Bio'),
                    validator: (value) {
                      return validateBio(value!);
                    },
                    onSaved: (newValue) {
                      _bio = newValue!;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: SharedButton(
                label: 'Update Profile',
                onPress: updateProfile,
                isLoading: _isLoading,
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
