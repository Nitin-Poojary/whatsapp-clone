import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsappclone/common/enums/message_enum.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/models/chat_contact.dart';
import 'package:whatsappclone/models/message.dart';
import 'package:whatsappclone/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
  ) async {
    var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection("users")
        .doc(receiverUserId)
        .collection("chats")
        .doc(senderUserData.uid)
        .set(recieverChatContact.toMap());

    var senderChatContact = ChatContact(
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);

    await firestore
        .collection("users")
        .doc(senderUserData.uid)
        .collection("chats")
        .doc(receiverUserId)
        .set(recieverChatContact.toMap());
  }

  void _saveMessageToSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        receiverId: receiverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        isSeen: false);

    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverUserId)
        .collection("messages")
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection("users")
        .doc(receiverUserId)
        .collection("chats")
        .doc(auth.currentUser!.uid)
        .collection("messages")
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      DateTime timeSent = DateTime.now();
      UserModel receiverUserData;

      DocumentSnapshot<Map<String, dynamic>> userDataMap =
          await firestore.collection("users").doc(receiverUserId).get();

      String messageId = const Uuid().v1();

      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactsSubcollection(
          senderUser, receiverUserData, text, timeSent, receiverUserId);

      _saveMessageToSubCollection(
          receiverUserId: receiverUserId,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          userName: senderUser.name,
          receiverUserName: receiverUserData.name,
          messageType: MessageEnum.text);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
