import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/providers/message_reply_provider.dart';
import 'package:whatsappclone/features/auth/controller/auth_controller.dart';
import 'package:whatsappclone/features/chat/repository/chat_repository.dart';
import 'package:whatsappclone/models/chat_contact.dart';
import 'package:whatsappclone/models/group.dart';
import 'package:whatsappclone/models/message.dart';

import '../../../common/enums/message_enum.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatContoller(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatContoller {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatContoller({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              receiverUserId: receiverUserId,
              senderUser: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat,
            ));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> getChatGroupsList() {
    return chatRepository.getChatGroupsList();
  }

  Stream<List<Message>> getChatLists(String receiverId) {
    return chatRepository.getChats(receiverId);
  }

  Stream<List<Message>> getGroupChat(String groupId) {
    return chatRepository.getGroupChats(groupId);
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
  }

  void setChatMessageSeen(
      BuildContext context, String receiverUserId, String messageId) async {
    chatRepository.setChatMessageSeen(context, receiverUserId, messageId);
  }
}
