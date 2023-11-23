import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/story_model.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/story_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/ui/shared/dialogs/custom_dialog.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/story_bars.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/helpers.dart';

class StoryPage extends ConsumerStatefulWidget {
  const StoryPage({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends ConsumerState<StoryPage> {
  late Timer _storyTimer;
  int currentStory = 0;
  List<StoryModel> _stories = [];
  // List<String> _imageURL = [];
  final List<double> _percents = [];
  bool _isLoading = true;

  late UserModel currentUser;

  @override
  void initState() {
    super.initState();

    getStories();
  }

  void getStories() async {
    await ref.read(currentUserProvider.notifier).getCurrentUserDetail();

    final user = ref.read(currentUserProvider);
    currentUser = user!;

    await ref
        .read(storyProvider.notifier)
        .getStories(widget.user.userId)
        .whenComplete(() {
      _stories = ref.read(storyProvider);

      for (var story in _stories) {
        _percents.add(0);
      }
    });

    setState(() {
      _isLoading = false;
    });

    startWatching();
  }

  void startWatching() {
    _storyTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_storyTimer.isActive) {
        setState(() {
          if (currentStory < _stories.length) {
            if (_percents[currentStory] <= 1) {
              _percents[currentStory] += 0.01;
            } else {
              _storyTimer.cancel();

              _percents[currentStory] = 1;
              currentStory += 1;

              startWatching();
            }
          } else {
            _storyTimer.cancel();
            Navigator.pop(context);
          }
        });
      }
    });
  }

  void onTap(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 2) {
      setState(() {
        if (currentStory != 0) {
          _percents[currentStory - 1] = 0;
          _percents[currentStory] = 0;

          currentStory--;
        } else {
          _percents[currentStory] = 0;
        }
      });
    } else {
      setState(() {
        if (currentStory != _stories.length - 1) {
          _percents[currentStory] = 1;

          currentStory++;
        } else {
          _percents[currentStory] = 1;
        }
      });
    }
  }

  void deleteStory() async {
    final result = await ref
        .read(storyProvider.notifier)
        .deleteStory(_stories[currentStory].storyId);

    if (result != null) {
      showSnackbar(context, result);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _storyTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? AppHelpers.buildLoadingIndicator()
          : GestureDetector(
              onTapDown: onTap,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      _stories[currentStory].imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 5,
                    left: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StoryBars(barsPercent: _percents),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  backgroundImage:
                                      NetworkImage(widget.user.profileImageURL),
                                  radius: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.user.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                widget.user.userId == currentUser.userId
                                    ? GestureDetector(
                                        onTap: () {
                                          customDialog(
                                            context,
                                            'Story Settings',
                                            [
                                              {
                                                'icon': Icons.delete,
                                                'label': 'Delete',
                                                'function': () {
                                                  deleteStory();
                                                },
                                              },
                                            ],
                                          );
                                        },
                                        child: const Icon(
                                          Icons.more_horiz,
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 35,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
