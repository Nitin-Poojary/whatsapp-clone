import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsappclone/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/models/status_model.dart';
import 'package:whatsappclone/models/user_model.dart';

final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  return StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  Future<List<String>> getUidWhoCanSee(List<Contact> contacts) async {
    List<String> uidWhoCanSee = [];
    for (int i = 0; i < contacts.length; i++) {
      var userData = await firestore
          .collection('users')
          .where('phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(" ", ''))
          .get();
      if (userData.docs.isNotEmpty) {
        UserModel userModel = UserModel.fromMap(userData.docs[0].data());
        uidWhoCanSee.add(userModel.uid);
      }
    }
    return uidWhoCanSee;
  }

  void uploadStatus({
    required String userName,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      String statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('/status/$statusId$uid', statusImage);

      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = await getUidWhoCanSee(contacts);

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection("status")
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firestore
            .collection("status")
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
          "whoCanSee": uidWhoCanSee,
        });
        return;
      } else {
        statusImageUrls = [imageUrl];
      }

      Status status = Status(
        uid: uid,
        userName: userName,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection("status").doc(uid).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> updateUidWhoCanSee() async {
    List<Contact> contacts = [];
    List<String> uidWhoCanSee = [];

    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
    }

    for (int i = 0; i < contacts.length; i++) {
      var userData = await firestore
          .collection('users')
          .where('phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(" ", ''))
          .get();
      if (userData.docs.isNotEmpty) {
        UserModel userModel = UserModel.fromMap(userData.docs[0].data());
        uidWhoCanSee.add(userModel.uid);
      }
    }

    await firestore.collection("status").doc(auth.currentUser!.uid).update({
      "whoCanSee": uidWhoCanSee,
    });
  }

  Stream<List<Status>> getStatus(BuildContext context) {
    updateUidWhoCanSee();

    return firestore
        .collection('status')
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .asyncMap((event) async {
      if (event.docs.isNotEmpty) {
        Status statusData = Status.fromMap(event.docs[0].data());
        List<String> uidWhoCanSee = statusData.whoCanSee;
        List<Status> displayStatus = [];
        displayStatus.add(statusData);

        for (int i = 0; i < uidWhoCanSee.length; i++) {
          var status = await firestore
              .collection('status')
              .where('uid', isEqualTo: uidWhoCanSee[i])
              .where('createdAt',
                  isGreaterThan: DateTime.now().millisecondsSinceEpoch)
              .get();

          if (status.docs.isNotEmpty) {
            displayStatus.add(Status.fromMap(status.docs[0].data()));
          }
        }
        return displayStatus;
      } else {
        return [];
      }
    });
  }
}
