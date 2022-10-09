import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappclone/common/utils/utils.dart';

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
          .doc(receiverCallData.callerId)
          .set(receiverCallData.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
