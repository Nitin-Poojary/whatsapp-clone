import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/colors.dart';
import 'package:whatsappclone/features/status/controller/status_controller.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  const ConfirmStatusScreen({Key? key, required this.file}) : super(key: key);

  final File file;

  void addStatus(WidgetRef ref, BuildContext context) {
    ref.read(statusControllerProvider).addStatus(file, context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        onPressed: () => addStatus(ref, context),
        child: const Icon(
          Icons.done,
          color: whiteColor,
        ),
      ),
    );
  }
}
