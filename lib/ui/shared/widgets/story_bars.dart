import 'package:flutter/material.dart';
import 'package:instagramclone/ui/shared/widgets/story_percent_indecator.dart';

class StoryBars extends StatelessWidget {
  const StoryBars({super.key, required this.barsPercent});

  final List barsPercent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: barsPercent
          .map(
            (percent) => Expanded(
              child: StoryPercentIndecator(percent: percent),
            ),
          )
          .toList(),
    );
  }
}
