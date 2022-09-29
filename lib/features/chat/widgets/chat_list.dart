import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/common/widgets/loader.dart';
import 'package:whatsappclone/features/chat/controller/chat_controller.dart';
import 'package:whatsappclone/models/message.dart';

import 'my_messages_card.dart';
import 'sender_message_card.dart';

class ChatsList extends ConsumerStatefulWidget {
  const ChatsList({required this.receiverUserId, super.key});

  final String receiverUserId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatsListState();
}

class _ChatsListState extends ConsumerState<ChatsList> {
  late ScrollController _chatScrollController;

  @override
  void initState() {
    _chatScrollController = ScrollController()..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          ref.read(chatControllerProvider).getChatLists(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          _chatScrollController
              .jumpTo(_chatScrollController.position.maxScrollExtent + 20);
        });

        return ListView.builder(
          controller: _chatScrollController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final Message messageData = snapshot.data![index];
            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: DateFormat.Hm().format(messageData.timeSent),
                messageType: messageData.type,
              );
            }
            return SendersMessageCard(
              message: messageData.text,
              date: DateFormat.Hm().format(messageData.timeSent),
              messageType: messageData.type,
            );
          },
        );
      },
    );
  }
}
