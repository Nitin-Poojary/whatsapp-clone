import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/features/auth/controller/auth_controller.dart';
import 'package:whatsappclone/features/calls/screens/call_history_screen.dart';
import 'package:whatsappclone/features/status/screens/status_contact_screen.dart';
import 'package:whatsappclone/widgets/contacts_list.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ref.read(authContollerProvider).setUserState(true);
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          _tabIndex = _tabController.index;
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.read(authContollerProvider).setUserState(true);
    } else {
      ref.read(authContollerProvider).setUserState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "WhatsApp",
            style: TextStyle(
              color: greyColor,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: greyColor,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: greyColor,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    Future(
                        () => Navigator.pushNamed(context, createGroupScreen));
                  },
                  child: const Text("Create Group"),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: greyColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "CHATS"),
              Tab(text: "STATUS"),
              Tab(text: "CALLS"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ContactsList(),
            StatusContactScreen(),
            CallHistoryScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_tabController.index == 0) {
              Navigator.pushNamed(context, selectContactsScreen);
            } else {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(context, confirmStatusScreen,
                    arguments: pickedImage);
              }
            }
          },
          backgroundColor: tabColor,
          child: _tabIndex == 0
              ? const Icon(Icons.comment, color: Colors.white)
              : const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
