import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/providers/post_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/ui/pages/post_page.dart';
import 'package:instagramclone/ui/pages/user_profile_page.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/helpers.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void searchUser() async {
    if (_usernameController.text.isNotEmpty) {
      final String? result = await ref
          .read(usersProvider.notifier)
          .searchUserByUsername(_usernameController.text);

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
        backgroundColor: AppColors.backgroundColor,
        title: TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Search for users...',
            contentPadding: const EdgeInsets.all(0),
            hintStyle: const TextStyle(
              color: AppColors.secondaryColor,
            ),
            filled: true,
            fillColor: Colors.grey[900],
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.secondaryColor,
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
                  return AppHelpers.buildLoadingIndicator();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PostPage.feed(),
                          ),
                        );
                      },
                      child: Image.network(
                        posts[index].imageURL,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
