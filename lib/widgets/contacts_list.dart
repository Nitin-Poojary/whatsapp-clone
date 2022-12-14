import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/widgets/loader.dart';
import 'package:whatsappclone/features/chat/controller/chat_controller.dart';
import 'package:whatsappclone/models/group.dart';

import '../models/chat_contact.dart';

class ContactsList extends ConsumerStatefulWidget {
  const ContactsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactsListState();
}

class _ContactsListState extends ConsumerState<ContactsList>
    with AutomaticKeepAliveClientMixin<ContactsList> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: ref.read(chatControllerProvider).getChatGroupsList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Group group = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, mobileChatScreen,
                              arguments: {
                                "name": group.name,
                                "uid": group.groupId,
                                "profilePic": group.groupPic,
                                "isGroupChat": true,
                                'chatRoomId': group.chatRoomId,
                                'groupMembers': group.memberUid.length,
                              });
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(
                              group.groupPic,
                            ),
                          ),
                          title: Text(
                            group.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              group.lastMessage.toString(),
                              style: const TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Text(
                            DateFormat.Hm().format(group.timeSent),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      color: dividerColor,
                      height: 8,
                      thickness: 0,
                    ),
                    itemCount: snapshot.data!.length,
                  );
                }
              },
            ),
            StreamBuilder(
              stream: ref.read(chatControllerProvider).getChatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ChatContact chatContactData = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, mobileChatScreen,
                              arguments: {
                                "name": chatContactData.name,
                                "uid": chatContactData.contactId,
                                "profilePic": chatContactData.profilePic,
                                "isGroupChat": false,
                                'chatRoomId': chatContactData.chatRoomId,
                                'groupMembers': 0,
                              });
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(
                              chatContactData.profilePic,
                            ),
                          ),
                          title: Text(
                            chatContactData.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              chatContactData.lastMessage.toString(),
                              style: const TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: Text(
                            DateFormat.Hm().format(chatContactData.timeSent),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      color: dividerColor,
                      height: 8,
                      thickness: 0,
                    ),
                    itemCount: snapshot.data!.length,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
