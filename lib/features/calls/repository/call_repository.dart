import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/page_routes.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/models/group.dart';

import '../../../models/call_model.dart';

final callRepositoryProvider = Provider<CallRepository>((ref) {
  return CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  CallRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection("calls").doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    BuildContext context,
    CallModel senderCallData,
    CallModel receiverCallData,
  ) async {
    try {
      await firestore
          .collection("calls")
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      await firestore
          .collection("calls")
          .doc(receiverCallData.receiverId)
          .set(receiverCallData.toMap());

      Navigator.pushNamed(context, callScreen, arguments: {
        'channelId': senderCallData.callId,
        'call': senderCallData,
        'isGroupChat': false,
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void makeGroupCall(
    BuildContext context,
    CallModel senderCallData,
    CallModel receiverCallData,
  ) async {
    try {
      await firestore
          .collection("calls")
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapShot = await firestore
          .collection("groups")
          .doc(senderCallData.receiverId)
          .get();

      Group group = Group.fromMap(groupSnapShot.data()!);

      for (var id in group.memberUid) {
        await firestore
            .collection("calls")
            .doc(id)
            .set(receiverCallData.toMap());
      }

      Navigator.pushNamed(context, callScreen, arguments: {
        'channelId': senderCallData.callId,
        'call': senderCallData,
        'isGroupChat': true,
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall(
    BuildContext context,
    String callerId,
    String receiverId,
  ) async {
    try {
      await firestore.collection("calls").doc(callerId).delete();

      await firestore.collection("calls").doc(receiverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall(
    BuildContext context,
    String callerId,
    String receiverId,
  ) async {
    try {
      await firestore.collection("calls").doc(callerId).delete();

      var groupSnapShot =
          await firestore.collection("groups").doc(receiverId).get();

      Group group = Group.fromMap(groupSnapShot.data()!);
      for (var id in group.memberUid) {
        await firestore.collection("calls").doc(id).delete();
      }

      await firestore.collection("calls").doc(receiverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
