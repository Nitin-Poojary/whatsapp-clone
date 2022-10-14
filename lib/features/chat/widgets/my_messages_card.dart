import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsappclone/common/enums/message_enum.dart';
import 'package:whatsappclone/common/utils/colors.dart';

import 'display_message.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.onRightSwipe,
    required this.repliedText,
    required this.userName,
    required this.repliedMessageType,
    required this.isSeen,
  });

  final String message, date, repliedText, userName;
  final MessageEnum messageType, repliedMessageType;
  final VoidCallback onRightSwipe;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    final bool isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            minWidth: 120,
            minHeight: 40,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: messageType == MessageEnum.text
                      ? const EdgeInsets.fromLTRB(10, 8, 30, 26)
                      : const EdgeInsets.fromLTRB(5, 5, 5, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isReplying) ...[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              DisplayMessage(
                                message: repliedText,
                                messageType: repliedMessageType,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(
                        height: 5,
                      ),
                      DisplayMessage(
                        message: message,
                        messageType: messageType,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 5,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      isSeen
                          ? const Icon(
                              Icons.done_all,
                              size: 20,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.done_all,
                              size: 20,
                              color: Colors.white60,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
