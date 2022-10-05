import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/features/auth/controller/auth_controller.dart';

import 'package:whatsappclone/features/status/repository/status_repository.dart';

import '../../../models/status_model.dart';

final statusControllerProvider = Provider<StatusContoller>((ref) {
  final StatusRepository statusRepository = ref.read(statusRepositoryProvider);
  return StatusContoller(statusRepository: statusRepository, ref: ref);
});

class StatusContoller {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusContoller({
    required this.statusRepository,
    required this.ref,
  });

  void addStatus(File file, BuildContext context) async {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
          userName: value!.name,
          profilePic: value.profilePic,
          phoneNumber: value.phoneNumber,
          statusImage: file,
          context: context);
    });
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statuses = await statusRepository.getStatus(context);
    return statuses;
  }
}
