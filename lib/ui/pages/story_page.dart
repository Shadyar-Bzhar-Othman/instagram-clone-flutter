import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:instagramclone/core/models/story_model.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/ui/shared/widgets/story_bars.dart';
import 'package:instagramclone/ui/shared/widgets/story_percent_indecator.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key, required this.user});

  final UserModel user;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late Timer _storyTimer;
  int currentStory = 0;
  List<String> _stories = [
    's',
    's',
    's',
    's',
    's',
    's',
  ];
  List<double> _percents = [];

  @override
  void initState() {
    super.initState();

    _stories.forEach((story) {
      _percents.add(0);
    });

    // startWatching();
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
          print(1);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _storyTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdxqCRBVi8V3xiVudx-MoDjmGZ0mj-L2WqjV985Zktex1AfQ761TAf47OLnjDRb-L7NMg&usqp=CAU',
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
                          radius: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Shadyar Bzhar Othman',
                          style: TextStyle(
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
                        GestureDetector(
                          onTap: () {},
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
    );
  }
}
