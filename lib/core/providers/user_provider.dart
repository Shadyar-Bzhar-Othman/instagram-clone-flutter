import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/user_model.dart';

final currentUserProvider = StateProvider<UserModel?>((ref) => null);
final userProvider = StateProvider<UserModel?>((ref) => null);
final usersProvider = StateProvider<List<UserModel>>((ref) => []);
