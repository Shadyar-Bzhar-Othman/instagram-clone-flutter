import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/auth_controller.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthController, UserModel?>((ref) {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  AuthService authService = AuthService(
      firebaseAuth: firebaseAuth, firebaseFirestore: firebaseFirestore);

  return AuthController(authService: authService);
});
