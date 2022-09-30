import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/enums/message_enum.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/features/chat/controller/chat_controller.dart';

import '../../../common/utils/colors.dart';

class BottomChatWidget extends ConsumerStatefulWidget {
  const BottomChatWidget({
    required this.receiverUserId,
    Key? key,
  }) : super(key: key);

  final String receiverUserId;

  @override
  ConsumerState<BottomChatWidget> createState() => _BottomChatWidgetState();
}

class _BottomChatWidgetState extends ConsumerState<BottomChatWidget> {
  bool isShowSendButton = false, isShowEmojiContainer = false;
  late TextEditingController messageController;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    messageController = TextEditingController()..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, messageController.text, widget.receiverUserId);
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);

    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectImageFromCamera() async {
    File? image = await pickImageFromCamera(context);

    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selecVideo() async {
    File? video = await pickVideoFromGallery(context);

    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void changeEmojiContainer() {
    isShowEmojiContainer = !isShowEmojiContainer;
  }

  void changeKeyboardContainer() {
    if (!isShowEmojiContainer) {
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
    }
  }

  void toggelEmojiKeyboardContainer() {
    changeEmojiContainer();
    changeKeyboardContainer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: TextFormField(
                  controller: messageController,
                  focusNode: focusNode,
                  onChanged: (value) {
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
                  onTap: () {
                    isShowEmojiContainer = false;
                    focusNode.requestFocus();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mobileChatBoxColor,
                    prefixIcon: IconButton(
                      color: greyColor,
                      splashRadius: 10,
                      splashColor: whiteColor,
                      onPressed: toggelEmojiKeyboardContainer,
                      icon: const Icon(Icons.emoji_emotions),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              bottomSheet(context);
                            },
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
                            onPressed: selectImageFromCamera,
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
                onTap: () {
                  if (messageController.text.trim().isNotEmpty) {
                    sendTextMessage();
                    messageController.text = '';
                  }
                },
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
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    messageController.text += emoji.emoji;
                    if (!isShowSendButton &&
                        messageController.text.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Future<void> bottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.image,
                        color: blackColor,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const Text(
                      "Photo",
                      style: TextStyle(
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: selecVideo,
                      icon: const Icon(
                        Icons.videocam,
                        color: blackColor,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const Text(
                      "Video",
                      style: TextStyle(
                        color: blackColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
