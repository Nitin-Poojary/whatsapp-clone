import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/widgets/loader.dart';
import 'package:whatsappclone/features/chat/controller/chat_controller.dart';

import '../models/chat_contact.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
          stream: ref.watch(chatControllerProvider).getChatContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else {
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  ChatContact chatContactData = snapshot.data![index];
                  return InkWell(
                    onTap: (() {
                      Navigator.pushNamed(context, mobileChatScreen,
                          arguments: {
                            "name": chatContactData.name,
                            "uid": chatContactData.contactId,
                            "profilePic": chatContactData.profilePic,
                          });
                    }),
                    child: ListTile(
                      leading: CircleAvatar(
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
          }),
    );
  }
}
