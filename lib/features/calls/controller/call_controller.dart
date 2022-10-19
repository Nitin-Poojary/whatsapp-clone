import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsappclone/features/auth/controller/auth_controller.dart';
import 'package:whatsappclone/models/call_model.dart';

import '../repository/call_repository.dart';

final callControllerProvider = Provider<CallContoller>((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallContoller(
    callRepository: callRepository,
    ref: ref,
  );
});

class CallContoller {
  final CallRepository callRepository;
  final ProviderRef ref;

  CallContoller({
    required this.callRepository,
    required this.ref,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(
    BuildContext context,
    String receiverName,
    String receiverUid,
    String receiverProfilePic,
    bool isGroupChat,
    bool isVideoCall,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();

      CallModel senderUserData = CallModel(
        callerId: value!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialed: true,
        isVideoCall: isVideoCall,
      );

      CallModel receiverUserData = CallModel(
        callerId: value.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialed: false,
        isVideoCall: isVideoCall,
      );

      if (isGroupChat) {
        callRepository.makeGroupCall(context, senderUserData, receiverUserData);
      } else {
        callRepository.makeCall(context, senderUserData, receiverUserData);
      }
    });
  }

  void makeNormalCall(
    BuildContext context,
    String receiverName,
    String receiverUid,
    String receiverProfilePic,
    bool isGroupChat,
    bool isVideoCall,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();

      CallModel senderUserData = CallModel(
        callerId: value!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialed: true,
        isVideoCall: isVideoCall,
      );

      CallModel receiverUserData = CallModel(
        callerId: value.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialed: false,
        isVideoCall: isVideoCall,
      );

      callRepository.makeNormalCall(context, senderUserData, receiverUserData);
    });
  }

  void endCall(BuildContext context, String callerId, String receiverId) {
    callRepository.endCall(context, callerId, receiverId);
  }
}
