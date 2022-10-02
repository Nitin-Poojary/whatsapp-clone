import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/enums/message_enum.dart';

final StateProvider<MessageReply?> messageReplyProvider =
    StateProvider<MessageReply?>((ref) {
  return null;
});

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageEnum,
  });
}
