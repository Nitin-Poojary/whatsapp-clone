import 'package:flutter/material.dart';
import 'package:whatsappclone/common/enums/message_enum.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/features/chat/widgets/display_message.dart';

class SendersMessageCard extends StatelessWidget {
  const SendersMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.messageType,
  });

  final String message, date;
  final MessageEnum messageType;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
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
          color: senderMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: messageType == MessageEnum.text
                    ? const EdgeInsets.fromLTRB(10, 8, 30, 26)
                    : const EdgeInsets.fromLTRB(5, 5, 5, 26),
                child: DisplayMessage(
                  message: message,
                  messageType: messageType,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
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
                      width: 5,
                    ),
                    const Icon(
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
    );
  }
}
