import 'package:flutter/material.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/widgets/chat_list.dart';
import 'package:whatsappclone/widgets/contacts_list.dart';
import 'package:whatsappclone/widgets/web_chat_appbar.dart';
import 'package:whatsappclone/widgets/web_search_bar.dart';

import '../widgets/web_profilebar.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: const [
                WebProfileBar(),
                WebSearchBar(),
                Flexible(
                  child: ContactsList(),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.70,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/whatsappbackgroundImage.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const WebChatAppbarr(),
                const Expanded(
                  child: ChatsList(),
                ),
                Container(
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: dividerColor,
                      ),
                    ),
                    color: chatBarMessage,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: greyColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.attach_file_outlined,
                          color: greyColor,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: searchBarColor,
                            filled: true,
                            hintText: "Type a message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 20,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.mic,
                          color: greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
