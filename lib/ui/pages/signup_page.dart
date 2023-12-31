import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/core/controllers/auth_controller.dart';
import 'package:instagramclone/core/providers/auth_provider.dart';
import 'package:instagramclone/core/services/auth_service.dart';
import 'package:instagramclone/ui/shared/dialogs/image_picker_dialog.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/shared_button.dart';
import 'package:instagramclone/utils/assets.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/consts.dart';
import 'package:instagramclone/utils/styles.dart';
import 'package:instagramclone/utils/validators.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = '';
  String _email = '';
  String _password = '';
  Uint8List? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void signup() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    String? result = await ref
        .read(authProvider.notifier)
        .signup(_email, _password, _username, _profileImage);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: Container()),
            Flexible(
              child: SvgPicture.asset(
                AppAssets.instagramLogo,
                color: Colors.white,
                height: 64,
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Stack(
              children: [
                _profileImage != null
                    ? CircleAvatar(
                        radius: 45,
                        backgroundColor: AppColors.secondaryColor,
                        backgroundImage: MemoryImage(_profileImage!),
                      )
                    : const CircleAvatar(
                        radius: 45,
                        backgroundColor: AppColors.secondaryColor,
                        backgroundImage: NetworkImage(
                          AppConstants.userProfileImage,
                        ),
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
                    decoration:
                        AppStyles.customFormTextFieldStyle(context, 'Username'),
                    validator: (value) {
                      return AppValidators.validateUsername(value!);
                    },
                    onSaved: (newValue) {
                      _username = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: AppStyles.customFormTextFieldStyle(
                        context, 'Email address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return AppValidators.validateEmail(value!);
                    },
                    onSaved: (newValue) {
                      _email = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration:
                        AppStyles.customFormTextFieldStyle(context, 'Password'),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      return AppValidators.validatePassword(value!);
                    },
                    onSaved: (newValue) {
                      _password = newValue!;
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
                label: 'Signup',
                onPress: signup,
                isLoading: _isLoading,
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: AppColors.blueColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
