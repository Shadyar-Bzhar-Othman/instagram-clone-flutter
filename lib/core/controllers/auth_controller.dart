import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/services/auth_service.dart';

class AuthController extends StateNotifier<UserModel?> {
  AuthController({required AuthService authService})
      : _authService = authService,
        super(null);

  final AuthService _authService;

  Future<String?> login(String email, String password) async {
    String? result;

    try {
      UserModel user = await _authService.login(email, password);

      state = user;

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

      state = user;

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

      state = user;

      result = null;
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
