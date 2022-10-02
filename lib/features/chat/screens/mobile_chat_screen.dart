import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/features/auth/controller/auth_controller.dart';
import 'package:whatsappclone/models/user_model.dart';
import 'package:whatsappclone/features/chat/widgets/chat_list.dart';

import '../widgets/bottom_chat_widget.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.profilePic,
  });

  final String name;
  final String uid;
  final String profilePic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 5,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                maxRadius: 16,
                backgroundImage: NetworkImage(profilePic),
              ),
            ),
            Expanded(
              child: StreamBuilder<UserModel>(
                stream: ref.read(authContollerProvider).userDataById(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
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
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          snapshot.data!.isOnline ? 'Online' : 'Offline',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatsList(receiverUserId: uid),
          ),
          BottomChatWidget(
            receiverUserId: uid,
          ),
        ],
      ),
    );
  }
}
