import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/story_model.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/story_provider.dart';
import 'package:instagramclone/ui/shared/widgets/story_bars.dart';

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
  List<double> _percents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    getStories();
  }

  void getStories() async {
    await ref
        .read(storyProvider.notifier)
        .getStories(widget.user.userId)
        .whenComplete(() {
      _stories = ref.read(storyProvider);

      _stories.forEach((story) {
        _percents.add(0);
      });
    });

    setState(() {
      _isLoading = false;
    });

    startWatching();
  }

  void startWatching() {
    _storyTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
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

  @override
  void dispose() {
    super.dispose();
    _storyTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTapDown: onTap,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      _stories[currentStory].imageURL,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  Positioned(
                    top: 20,
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
                                  backgroundColor: Colors.white,
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
                                GestureDetector(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.more_horiz,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                // Separating all pop and navigating in a different file so I just use them || Refactor all the code
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
