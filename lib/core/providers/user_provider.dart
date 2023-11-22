import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/dependency_injection.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/user_service.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserController, UserModel?>((ref) {
  return CurrentUserController(userService: locator<UserService>());
});

final specificUserProvider =
    StateNotifierProvider<SpecificUserController, UserModel?>((ref) {
  return SpecificUserController(userService: locator<UserService>());
});

final usersProvider =
    StateNotifierProvider<ListUsersController, List<UserModel>>((ref) {
  return ListUsersController(userService: locator<UserService>());
});
