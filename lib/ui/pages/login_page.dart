import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/core/controllers/auth_controller.dart';
import 'package:instagramclone/core/providers/auth_provider.dart';
import 'package:instagramclone/core/services/auth_service.dart';
import 'package:instagramclone/ui/pages/signup_page.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/shared_button.dart';
import 'package:instagramclone/utils/assets.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/consts.dart';
import 'package:instagramclone/utils/styles.dart';
import 'package:instagramclone/utils/validators.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  String _email = '';
  String _password = '';
  bool _isLoading = false;

  void login() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    String? result =
        await ref.read(authProvider.notifier).login(_email, _password);

    if (result != null) {
      showSnackbar(context, result);
    }

    setState(() {
      _isLoading = false;
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
            Form(
              key: _formKey,
              child: Column(
                children: [
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
              height: 14,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Forgot password?',
                  style: TextStyle(color: AppColors.blueColor),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: SharedButton(
                label: 'Login',
                onPress: login,
                isLoading: _isLoading,
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  child: const Text('Signup',
                      style: TextStyle(color: AppColors.blueColor)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
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
