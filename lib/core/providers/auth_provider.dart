import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/auth_controller.dart';
import 'package:instagramclone/core/dependency_injection.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthController, UserModel?>((ref) {
  return AuthController(authService: locator<AuthService>());
});
