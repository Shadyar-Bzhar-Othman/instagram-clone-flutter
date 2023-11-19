import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/user_service.dart';

final currentUserProvider =
    StateNotifierProvider<CurrentUserController, UserModel?>((ref) {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  UserService userService = UserService(
      firebaseAuth: firebaseAuth, firebaseFirestore: firebaseFirestore);

  return CurrentUserController(userService: userService);
});

final specificUserProvider =
    StateNotifierProvider<SpecificUserController, UserModel?>((ref) {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  UserService userService = UserService(
      firebaseAuth: firebaseAuth, firebaseFirestore: firebaseFirestore);

  return SpecificUserController(userService: userService);
});

final usersProvider =
    StateNotifierProvider<ListUsersController, List<UserModel>>((ref) {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  UserService userService = UserService(
      firebaseAuth: firebaseAuth, firebaseFirestore: firebaseFirestore);

  return ListUsersController(userService: userService);
});
