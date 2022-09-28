import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/features/auth/controller/auth_controller.dart';
import 'package:whatsappclone/features/chat/repository/chat_repository.dart';
import 'package:whatsappclone/models/chat_contact.dart';

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
  ) {
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!));
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }
}
