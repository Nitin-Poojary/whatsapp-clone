import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:whatsappclone/common/enums/message_enum.dart';

import 'video_player_widget.dart';

class DisplayMessage extends StatelessWidget {
  const DisplayMessage({
    Key? key,
    required this.message,
    required this.messageType,
  }) : super(key: key);

  final String message;
  final MessageEnum messageType;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (messageType == MessageEnum.text) {
          return Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          );
        } else if (messageType == MessageEnum.image) {
          return CachedNetworkImage(imageUrl: message);
        } else if (messageType == MessageEnum.video) {
          return VideoPlayer(
            videoUrl: message,
          );
        }
        return Container();
      },
    );
  }
}
