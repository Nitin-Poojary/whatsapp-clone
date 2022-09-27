import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsappclone/features/select_contacts/repository/select_contacts_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepository);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepository);
  return SelectContactsController(
      ref: ref, selectContactsRepository: selectContactRepository);
});

class SelectContactsController {
  final ProviderRef ref;
  final SelectContactsRepository selectContactsRepository;

  SelectContactsController({
    required this.ref,
    required this.selectContactsRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactsRepository.selectContact(context, selectedContact);
  }
}
