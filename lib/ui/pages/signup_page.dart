import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/services/user_service.dart';
import 'package:instagramclone/ui/shared/dialogs/dialogs.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/shared_button.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/consts.dart';
import 'package:instagramclone/utils/helpers.dart';
import 'package:instagramclone/utils/validators.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final UserController _userController = UserController(
    UserService(
      firebaseAuth: FirebaseAuth.instance,
      firebaseFirestore: FirebaseFirestore.instance,
    ),
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = '';
  String _email = '';
  String _password = '';
  Uint8List? _profileImage;
  bool _isLoading = false;

  void signup() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    String result = await _userController.signup(
        _email, _password, _username, _profileImage);

    setState(() {
      _isLoading = false;
    });

    if (result != 'Success') {
      showSnackbar(context, result);
      return;
    }

    Navigator.pop(context);
  }

  Future<void> pickProfileImage() async {
    Uint8List? selectedImage = await showImagePickerDialog(context);

    if (selectedImage != null) {
      setState(() {
        _profileImage = selectedImage;
      });
    }
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
                'assets/images/ic_instagram.svg',
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
                        backgroundColor: secondaryColor,
                        backgroundImage: MemoryImage(_profileImage!),
                      )
                    : const CircleAvatar(
                        radius: 45,
                        backgroundColor: secondaryColor,
                        backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
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
                    decoration:
                        customFormTextFieldStyle(context, 'Email address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return validateEmail(value!);
                    },
                    onSaved: (newValue) {
                      _email = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: customFormTextFieldStyle(context, 'Password'),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: (value) {
                      return validatePassword(value!);
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
            Container(
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
                  child:
                      const Text('Login', style: TextStyle(color: blueColor)),
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
