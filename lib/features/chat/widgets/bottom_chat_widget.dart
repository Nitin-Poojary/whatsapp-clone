import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsappclone/common/enums/message_enum.dart';
import 'package:whatsappclone/common/providers/message_reply_provider.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/features/chat/controller/chat_controller.dart';
import 'package:whatsappclone/features/chat/widgets/message_reply_preview.dart';

import '../../../common/utils/colors.dart';

class BottomChatWidget extends ConsumerStatefulWidget {
  const BottomChatWidget({
    required this.receiverUserId,
    required this.isGroupChat,
    required this.chatRoomId,
    Key? key,
  }) : super(key: key);

  final String receiverUserId;
  final bool isGroupChat;
  final String chatRoomId;

  @override
  ConsumerState<BottomChatWidget> createState() => _BottomChatWidgetState();
}

class _BottomChatWidgetState extends ConsumerState<BottomChatWidget> {
  bool _isShowSendButton = false,
      _isShowEmojiContainer = false,
      _isRecording = false;
  late TextEditingController _messageController;
  final FocusNode _focusNode = FocusNode();
  FlutterSoundRecorder? _soundRecorder;

  @override
  void initState() {
    _messageController = TextEditingController()..addListener(() {});
    _soundRecorder = FlutterSoundRecorder();
    super.initState();
    openAudio();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isShowEmojiContainer = false;
        });
      }
    });
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Doesn't have Microphone Permission");
    }
    await _soundRecorder!.openRecorder();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    _isRecording = false;
    super.dispose();
  }

  void sendTextMessage() async {
    if (_isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text,
            widget.receiverUserId,
            widget.isGroupChat,
            widget.chatRoomId,
          );
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
          widget.isGroupChat,
          widget.chatRoomId,
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

  void toggleEmojiContainer() {
    _isShowEmojiContainer = !_isShowEmojiContainer;
    setState(() {});
  }

  void changeKeyboardContainer() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  void toggelEmojiKeyboardContainer() {
    changeKeyboardContainer();
    toggleEmojiContainer();
  }

  void sendAudioMessage() async {
    Directory tempDirPath = await getTemporaryDirectory();
    String path = '${tempDirPath.path}/flutter_sound.aac';
    if (_isRecording) {
      _soundRecorder!.stopRecorder();
      sendFileMessage(File(path), MessageEnum.audio);
    } else {
      _soundRecorder!.startRecorder(toFile: path);
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    bool isShowMessageReply = messageReply != null;

    if (isShowMessageReply) {
      _focusNode.requestFocus();
    }

    return WillPopScope(
      onWillPop: () async {
        if (_isShowEmojiContainer) {
          setState(() {
            _isShowEmojiContainer = false;
          });
          return false;
        }
        return true;
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    children: [
                      isShowMessageReply
                          ? const MessageReplyPreview()
                          : const SizedBox(),
                      TextFormField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _isShowSendButton = true;
                            });
                          } else {
                            setState(() {
                              _isShowSendButton = false;
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
                            onPressed: toggelEmojiKeyboardContainer,
                            icon: _isShowEmojiContainer
                                ? const Icon(Icons.keyboard)
                                : const Icon(Icons.emoji_emotions),
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
                                  onPressed: () {},
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
                            borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(20),
                              bottomRight: const Radius.circular(20),
                              topLeft: isShowMessageReply
                                  ? const Radius.circular(0)
                                  : const Radius.circular(20),
                              topRight: isShowMessageReply
                                  ? const Radius.circular(0)
                                  : const Radius.circular(20),
                            ),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      sendTextMessage();
                      _messageController.text = '';
                      setState(() {
                        _isShowSendButton = false;
                      });
                    }
                    if (_isRecording) {
                      sendAudioMessage();
                    }
                  },
                  onLongPress: sendAudioMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: tabColor,
                    ),
                    child: _isShowSendButton
                        ? const Icon(Icons.send)
                        : _isRecording
                            ? const Icon(Icons.cancel)
                            : const Icon(Icons.mic),
                  ),
                ),
              ),
            ],
          ),
          Offstage(
            offstage: !_isShowEmojiContainer,
            child: SizedBox(
              height: 255,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _messageController.text += emoji.emoji;
                  if (!_isShowSendButton &&
                      _messageController.text.isNotEmpty) {
                    setState(() {
                      _isShowSendButton = true;
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
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
                      onPressed: () {
                        selectImage();
                        Navigator.pop(context);
                      },
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
                      onPressed: () {
                        selecVideo();
                        Navigator.pop(context);
                      },
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
