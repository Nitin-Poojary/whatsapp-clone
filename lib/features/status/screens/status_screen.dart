import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsappclone/common/widgets/loader.dart';

import 'package:whatsappclone/models/status_model.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  final Status status;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final StoryController _storyController = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    initStoryPageItems();
    super.initState();
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
          url: widget.status.photoUrl[i],
          controller: _storyController,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: _storyController,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
              onComplete: () => Navigator.pop(context),
            ),
    );
  }
}
