import 'package:flutter/material.dart';
import 'package:whatsappclone/info.dart';
import 'package:whatsappclone/widgets/my_messages_card.dart';
import 'package:whatsappclone/widgets/sender_message_card.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (messages[index]['isMe'] == true) {
          return MyMessageCard(
            message: messages[index]["text"].toString(),
            date: messages[index]["time"].toString(),
          );
        }
        return SendersMessageCard(
          message: messages[index]["text"].toString(),
          date: messages[index]["time"].toString(),
        );
      },
    );
  }
}
