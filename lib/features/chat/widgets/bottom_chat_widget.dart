import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/features/chat/controller/chat_controller.dart';

import '../../../common/utils/colors.dart';

class BottomChatWidget extends ConsumerStatefulWidget {
  const BottomChatWidget({
    required this.receiverUserId,
    Key? key,
  }) : super(key: key);

  final receiverUserId;

  @override
  ConsumerState<BottomChatWidget> createState() => _BottomChatWidgetState();
}

class _BottomChatWidgetState extends ConsumerState<BottomChatWidget> {
  bool isShowSendButton = false;
  String sendText = '';

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref
          .read(chatControllerProvider)
          .sendTextMessage(context, sendText, widget.receiverUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: TextFormField(
              onChanged: (value) {
                sendText = value.trim();
                if (value.isNotEmpty) {
                  setState(() {
                    isShowSendButton = true;
                  });
                } else {
                  setState(() {
                    isShowSendButton = false;
                  });
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                prefixIcon: IconButton(
                  color: greyColor,
                  splashRadius: 10,
                  splashColor: whiteColor,
                  onPressed: (() {}),
                  icon: const Icon(Icons.emoji_emotions),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (() {}),
                        icon: const Icon(
                          Icons.attach_file_outlined,
                          color: greyColor,
                        ),
                      ),
                      IconButton(
                        onPressed: (() {}),
                        icon: const Icon(
                          Icons.currency_rupee_outlined,
                          color: greyColor,
                        ),
                      ),
                      IconButton(
                        onPressed: (() {}),
                        icon: const Icon(
                          Icons.camera_alt,
                          color: greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                hintText: "Message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: sendTextMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: tabColor,
              ),
              child: isShowSendButton
                  ? const Icon(Icons.send)
                  : const Icon(Icons.mic),
            ),
          ),
        ),
      ],
    );
  }
}
