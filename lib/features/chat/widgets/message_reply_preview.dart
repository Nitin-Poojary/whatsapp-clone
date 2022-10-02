import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/providers/message_reply_provider.dart';
import 'package:whatsappclone/features/chat/widgets/display_message.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.read(messageReplyProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                messageReply!.isMe ? 'You' : 'Other',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => cancelReply(ref),
                child: const Icon(Icons.close),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            constraints: const BoxConstraints(
              maxHeight: 120,
              maxWidth: 120,
              minHeight: 30,
              minWidth: 30,
            ),
            child: DisplayMessage(
              message: messageReply.message,
              messageType: messageReply.messageEnum,
            ),
          ),
        ],
      ),
    );
  }
}