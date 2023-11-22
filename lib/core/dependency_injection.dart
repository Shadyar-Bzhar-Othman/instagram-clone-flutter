import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagramclone/core/services/auth_service.dart';
import 'package:instagramclone/core/services/comment_service.dart';
import 'package:instagramclone/core/services/post_service.dart';
import 'package:instagramclone/core/services/story_service.dart';
import 'package:instagramclone/core/services/user_service.dart';
import 'package:instagramclone/core/services/user_story_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register the fiebase services
  // Register FirebaseAuth
  locator.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  // Register FirebaseFirestore
  locator.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Register FirebaseStorage
  locator.registerLazySingleton<FirebaseStorage>(
    () => FirebaseStorage.instance,
  );

  // Register the app services
  // Register AuthServce
  locator.registerLazySingleton<AuthService>(
    () => AuthService(
      firebaseAuth: locator<FirebaseAuth>(),
      firebaseFirestore: locator<FirebaseFirestore>(),
    ),
  );

  // Register UserService
  locator.registerLazySingleton<UserService>(
    () => UserService(
      firebaseAuth: locator<FirebaseAuth>(),
      firebaseFirestore: locator<FirebaseFirestore>(),
    ),
  );

  // Register PostService
  locator.registerLazySingleton<PostService>(
    () => PostService(
      firebaseFirestore: locator<FirebaseFirestore>(),
    ),
  );

  // Register StoryService
  locator.registerLazySingleton<StoryService>(
    () => StoryService(
      firebaseFirestore: locator<FirebaseFirestore>(),
    ),
  );

  // Register CommentService
  locator.registerLazySingleton<CommentService>(
    () => CommentService(
      firebaseFirestore: locator<FirebaseFirestore>(),
    ),
  );

  // Register UserStoryService
  locator.registerLazySingleton<UserStoryService>(
    () => UserStoryService(
      firebaseFirestore: locator<FirebaseFirestore>(),
    ),
  );
}
