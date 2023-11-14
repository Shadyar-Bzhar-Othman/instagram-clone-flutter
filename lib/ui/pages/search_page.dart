import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/ui/pages/user_profile_page.dart';
import 'package:instagramclone/utils/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              _isSearching = true;
            });
          },
        ),
      ),
      body: _isSearching && _usernameController.text.isNotEmpty
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _usernameController.text)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<UserModel> data = snapshot.data!.docs
                    .map((user) =>
                        UserModel.fromMap(user.data() as Map<String, dynamic>))
                    .toList();

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfilePage(
                              user: data[index],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            data[index].profileImageURL,
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          data[index].username,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return Image.network(
                      snapshot.data!.docs[index]['imageURL'],
                      fit: BoxFit.cover,
                    );
                  },
                );
              },
            ),
    );
  }
}
