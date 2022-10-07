import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:whatsappclone/common/widgets/error_widget.dart';
import 'package:whatsappclone/common/widgets/loader.dart';
import 'package:whatsappclone/features/select_contacts/controller/select_contacts_controller.dart';

final selectedGroupContactsProvider = StateProvider<List<Contact>>((ref) {
  return [];
});

class SelectContactsForGroup extends ConsumerStatefulWidget {
  const SelectContactsForGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsForGroupState();
}

class _SelectContactsForGroupState
    extends ConsumerState<SelectContactsForGroup> {
  List<int> selectContactsIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectContactsIndex.contains(index)) {
      selectContactsIndex.remove(index);
      ref.read(selectedGroupContactsProvider).remove(index);
    } else {
      selectContactsIndex.add(index);
      ref
          .read(selectedGroupContactsProvider.state)
          .update((state) => [...state, contact]);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
        data: (contactList) {
          return Expanded(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];

                return InkWell(
                  onTap: () => selectContact(index, contact),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: ListTile(
                      leading: selectContactsIndex.contains(index)
                          ? IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.done),
                            )
                          : null,
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        error: (error, trace) => ErrorScreen(error: error.toString()),
        loading: () => const Loader());
  }
}
