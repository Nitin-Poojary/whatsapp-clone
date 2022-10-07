import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/features/group/controller/group_controller.dart';
import 'package:whatsappclone/features/group/widgets/select_contacts_group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  late TextEditingController _groupNameContoller;

  @override
  void initState() {
    _groupNameContoller = TextEditingController()..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _groupNameContoller.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    if (_groupNameContoller.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
            context,
            _groupNameContoller.text.trim(),
            image!,
            ref.read(selectedGroupContactsProvider),
          );
    }
    ref.read(selectedGroupContactsProvider.state).update((state) => []);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(defaultPhotoURL),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _groupNameContoller,
              decoration: const InputDecoration(
                hintText: "Enter Group Name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Select Contacts",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const SelectContactsForGroup(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: whiteColor,
        ),
      ),
    );
  }
}
