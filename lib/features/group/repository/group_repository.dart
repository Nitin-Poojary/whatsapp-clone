import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsappclone/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/models/group.dart' as m;

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContacts) async {
    try {
      List<String> uids = [];

      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firestore
            .collection("users")
            .where(
              'phoneNumber',
              isEqualTo:
                  selectedContacts[i].phones[0].number.replaceAll(" ", ''),
            )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();

      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('group$groupId', profilePic);

      m.Group group = m.Group(
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        senderId: auth.currentUser!.uid,
        memberUid: [auth.currentUser!.uid, ...uids],
      );

      await firestore.collection("groups").doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
