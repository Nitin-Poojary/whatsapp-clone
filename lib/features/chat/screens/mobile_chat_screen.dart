import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/features/calls/controller/call_controller.dart';
import 'package:whatsappclone/features/calls/screens/call_pickup_screen.dart';

import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/bottom_chat_widget.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isGroupChat,
    required this.chatRoomId,
  });

  final String name;
  final String uid;
  final String profilePic;
  final bool isGroupChat;
  final String chatRoomId;

  void makeCall(WidgetRef ref, BuildContext context) {
    ref
        .read(callControllerProvider)
        .makeCall(context, name, uid, profilePic, isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            color: appBarColor,
            child: SafeArea(
              child: Row(
                children: [
                  const SizedBox(
                    width: 3,
                  ),
                  Material(
                    color: appBarColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context),
                      child: Ink(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: appBarColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_back,
                              color: whiteColor,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(profilePic),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  isGroupChat
                      ? Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : StreamBuilder<UserModel>(
                          stream:
                              ref.read(authContollerProvider).userDataById(uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Text(
                                      'Offline',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.isOnline
                                          ? 'Online'
                                          : 'Offline',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                  IconButton(
                    onPressed: () => makeCall(ref, context),
                    icon: const Icon(
                      Icons.videocam,
                      color: whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => makeCall(ref, context),
                    icon: const Icon(
                      Icons.call,
                      color: whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => makeCall(ref, context),
                    icon: const Icon(
                      Icons.more_vert,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatsList(
                receiverUserId: uid,
                isGroupChat: isGroupChat,
                chatRoomId: chatRoomId,
              ),
            ),
            BottomChatWidget(
              receiverUserId: uid,
              isGroupChat: isGroupChat,
              chatRoomId: chatRoomId,
            ),
          ],
        ),
      ),
    );
  }
}
