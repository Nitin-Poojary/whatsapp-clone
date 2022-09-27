import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/features/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  late TextEditingController _nameController;
  File? image;

  @override
  void initState() {
    _nameController = TextEditingController()..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authContollerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Stack(
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
              Row(
                children: [
                  Container(
                    width: size.width * 0.8,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserData,
                    icon: const Icon(Icons.done),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
