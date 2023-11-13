import 'package:flutter/material.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/utils/colors.dart';

class StoryCircle extends StatelessWidget {
  const StoryCircle({
    super.key,
    required this.isMine,
    required this.user,
    required this.isActive,
    required this.onPress,
  });

  final bool isMine;
  final UserModel user;
  final bool isActive;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: 98,
        margin: const EdgeInsets.only(left: 8),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: isActive ? pinkColor : secondaryColor,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    radius: 35,
                    backgroundImage: NetworkImage(user.profileImageURL),
                  ),
                ),
                isMine
                    ? Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: blueColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 20,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                isMine ? 'Your story' : user.username,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
