import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/post_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/services/user_service.dart';
import 'package:instagramclone/ui/pages/user_profile_page.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/utils/colors.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late final UserController _userController;

  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userController = UserController(
      ref: ref,
      userService: UserService(
        firebaseAuth: FirebaseAuth.instance,
        firebaseFirestore: FirebaseFirestore.instance,
      ),
    );
  }

  void searchUser() async {
    if (_usernameController.text.isNotEmpty) {
      final String? result =
          await _userController.searchUserByUsername(_usernameController.text);

      if (result != null) {
        showSnackbar(context, result);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allUserData = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Search for users...',
            contentPadding: const EdgeInsets.all(0),
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[900],
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onEditingComplete: () {
            setState(() {
              searchUser();
            });
          },
        ),
      ),
      body: _usernameController.text.isNotEmpty
          ? ListView.builder(
              itemCount: allUserData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfilePage(
                          user: allUserData[index],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        allUserData[index].profileImageURL,
                      ),
                      radius: 16,
                    ),
                    title: Text(
                      allUserData[index].username,
                    ),
                  ),
                );
              },
            )
          : FutureBuilder(
              future: ref.read(postProvider.notifier).getAllPost(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<PostModel> posts = ref.watch(postProvider);

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  itemCount: posts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return Image.network(
                      posts[index].imageURL,
                      fit: BoxFit.cover,
                    );
                  },
                );
              },
            ),
    );
  }
}
