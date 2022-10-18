import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsappclone/features/group/repository/group_repository.dart';

final groupControllerProvider = Provider<GroupContoller>((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupContoller(
    groupRepository: groupRepository,
    ref: ref,
  );
});

class GroupContoller {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupContoller({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File? profilePic,
      List<Contact> selectedContacts) {
    groupRepository.createGroup(context, name, profilePic, selectedContacts);
  }
}
