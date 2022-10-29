import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/providers/message_reply_provider.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/features/chat/widgets/display_message.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: mobileChatBoxColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  messageReply!.isMe ? 'You' : 'mummy',
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
      ),
    );
  }
}
