import 'dart:typed_data';

import 'package:instagramclone/core/services/user_service.dart';

class UserController {
  UserController(UserService userService) : _userService = userService;

  UserService _userService;

  Future<String> login(String email, String password) async {
    return await _userService.login(email, password);
  }

  Future<String> signup(String email, String password, String username,
      Uint8List? profileImage) async {
    return _userService.signup(email, password, username, profileImage);
  }
}
