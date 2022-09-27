import 'package:flutter/material.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/info.dart';
import 'package:whatsappclone/features/chat/screens/mobile_chat_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => InkWell(
          onTap: (() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MobileChatScreen(
                  name: "Nitin",
                  uid: "123",
                ),
              ),
            );
          }),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                contacts[index]["profilePic"].toString(),
              ),
            ),
            title: Text(
              contacts[index]["name"].toString(),
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                contacts[index]["message"].toString(),
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Text(contacts[index]["time"].toString()),
          ),
        ),
        separatorBuilder: (context, index) => const Divider(
          color: dividerColor,
          height: 8,
          thickness: 0,
        ),
        itemCount: contacts.length,
      ),
    );
  }
}
