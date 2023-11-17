import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/services/auth_service.dart';

class AuthController {
  AuthController({
    required WidgetRef ref,
    required AuthService authService,
  })  : _ref = ref,
        _authService = authService;

  final WidgetRef _ref;
  final AuthService _authService;

  Future<String?> login(String email, String password) async {
    String? result;

    try {
      UserModel user = await _authService.login(email, password);

      _ref.read(currentUserProvider.notifier).state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> signup(String email, String password, String username,
      Uint8List? profileImage) async {
    String? result;

    try {
      UserModel user =
          await _authService.signup(email, password, username, profileImage);

      _ref.read(currentUserProvider.notifier).state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String?> signOut() async {
    String? result;

    try {
      UserModel? user = await _authService.signOut();

      _ref.read(currentUserProvider.notifier).state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
