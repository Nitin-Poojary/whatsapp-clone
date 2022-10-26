import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsappclone/common/enums/message_enum.dart';
import 'package:whatsappclone/common/providers/message_reply_provider.dart';
import 'package:whatsappclone/common/utils/utils.dart';
import 'package:whatsappclone/models/chat_contact.dart';
import 'package:whatsappclone/models/group.dart' as model;
import 'package:whatsappclone/models/message.dart';
import 'package:whatsappclone/models/user_model.dart';

import '../../../common/repository/common_firebase_storage_repository.dart';

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

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());

        contacts.add(chatContact);
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChats(String chatRoomId) {
    return firestore
        .collection("chatMessages")
        .doc("personalChats")
        .collection(chatRoomId)
        .orderBy("timeSent")
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      if (event.docs.isNotEmpty) {
        for (var document in event.docs) {
          messages.add(Message.fromMap(document.data()));
        }
      }
      return messages;
    });
  }

  Stream<List<model.Group>> getChatGroupsList() {
    return firestore.collection("groups").snapshots().map((event) {
      List<model.Group> groups = [];
      for (var document in event.docs) {
        var group = model.Group.fromMap(document.data());

        if (group.memberUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<Message>> getGroupChats(String chatRoomId) {
    return firestore
        .collection("chatMessages")
        .doc("groupChats")
        .collection(chatRoomId)
        .orderBy("timeSent")
        .snapshots()
        .map((event) {
      List<Message> messages = [];

      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Future<void> _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel? receiverUserData,
    String text,
    DateTime timeSent,
    String receiverUserId,
    bool isGroupChat,
    String chatRoomId,
  ) async {
    if (isGroupChat) {
      await firestore.collection("groups").doc(receiverUserId).update(
        {
          "lastMessage": text,
          "timeSent": DateTime.now().millisecondsSinceEpoch,
        },
      );
    } else {
      var chatContactData = await firestore
          .collection("users")
          .doc(senderUserData.uid)
          .collection("chats")
          .doc(receiverUserId)
          .get();

      if (chatContactData.exists) {
        await firestore
            .collection("users")
            .doc(receiverUserId)
            .collection("chats")
            .doc(senderUserData.uid)
            .update({
          'lastMessage': text,
          'timeSent': timeSent.millisecondsSinceEpoch
        });

        await firestore
            .collection("users")
            .doc(senderUserData.uid)
            .collection("chats")
            .doc(receiverUserId)
            .update({
          'lastMessage': text,
          'timeSent': timeSent.millisecondsSinceEpoch
        });
      } else {
        var recieverChatContact = ChatContact(
          name: senderUserData.name,
          profilePic: senderUserData.profilePic,
          contactId: senderUserData.uid,
          timeSent: timeSent,
          lastMessage: text,
          chatRoomId: chatRoomId,
        );

        await firestore
            .collection("users")
            .doc(receiverUserId)
            .collection("chats")
            .doc(senderUserData.uid)
            .set(recieverChatContact.toMap());

        var senderChatContact = ChatContact(
          name: receiverUserData!.name,
          profilePic: receiverUserData.profilePic,
          contactId: receiverUserData.uid,
          timeSent: timeSent,
          lastMessage: text,
          chatRoomId: chatRoomId,
        );

        await firestore
            .collection("users")
            .doc(senderUserData.uid)
            .collection("chats")
            .doc(receiverUserId)
            .set(senderChatContact.toMap());
      }
    }
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String? receiverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUserName,
    required MessageEnum repliedMessageType,
    required bool isGroupChat,
    required String chatRoomId,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: [receiverUserId],
      text: text,
      type: messageType,
      messageId: messageId,
      timeSent: timeSent,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? "You"
              : receiverUserName ?? '',
      repliedMessageType: repliedMessageType,
    );

    if (isGroupChat) {
      await firestore
          .collection("chatMessages")
          .doc("groupChats")
          .collection(chatRoomId)
          .doc(messageId)
          .set(message.toMap());
    } else {
      await firestore
          .collection("chatMessages")
          .doc("personalChats")
          .collection(chatRoomId)
          .doc(messageId)
          .set(message.toMap());
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
    required String chatRoomId,
  }) async {
    try {
      DateTime timeSent = DateTime.now();
      UserModel? receiverUserData;
      if (!isGroupChat) {
        DocumentSnapshot<Map<String, dynamic>> userDataMap =
            await firestore.collection("users").doc(receiverUserId).get();

        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      String messageId = const Uuid().v1();

      await _saveDataToContactsSubcollection(senderUser, receiverUserData, text,
          timeSent, receiverUserId, isGroupChat, chatRoomId);

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        receiverUserName: receiverUserData?.name,
        messageType: MessageEnum.text,
        messageReply: messageReply,
        senderUserName: senderUser.name,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
        isGroupChat: isGroupChat,
        chatRoomId: chatRoomId,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
    required String chatRoomId,
  }) async {
    try {
      DateTime timeSent = DateTime.now();
      String messageId = const Uuid().v1();

      String fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${senderUserData.uid}/$receiverUserId/${messageEnum.type}/$messageId',
              file);

      UserModel? receiverUserData;

      if (!isGroupChat) {
        DocumentSnapshot<Map<String, dynamic>> userDataMap =
            await firestore.collection("users").doc(receiverUserId).get();
        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = "📷 Photo";
          break;
        case MessageEnum.video:
          contactMsg = "📸 Video";
          break;
        case MessageEnum.audio:
          contactMsg = "🔉 Audio";
          break;
        case MessageEnum.gif:
          contactMsg = "GIF";
          break;
        default:
          contactMsg = '';
      }

      _saveDataToContactsSubcollection(senderUserData, receiverUserData,
          contactMsg, timeSent, receiverUserId, isGroupChat, chatRoomId);

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: fileUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        receiverUserName: receiverUserData?.name,
        messageType: messageEnum,
        messageReply: messageReply,
        senderUserName: senderUserData.name,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
        isGroupChat: isGroupChat,
        chatRoomId: chatRoomId,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required List<String> receiverUserId,
    required int membersLength,
    required String viewerId,
    required String messageId,
    required String chatRoomId,
    required bool isGroupChat,
  }) async {
    try {
      if (!isGroupChat) {
        await firestore
            .collection("chatMessages")
            .doc("personalChats")
            .collection(chatRoomId)
            .doc(messageId)
            .update({'isSeen': true});
      } else {
        if (!receiverUserId.contains(viewerId)) {
          receiverUserId.add(viewerId);
          if (membersLength == receiverUserId.length) {
            await firestore
                .collection("chatMessages")
                .doc('groupChats')
                .collection(chatRoomId)
                .doc(messageId)
                .update({
              'isSeen': true,
              'receiverId': receiverUserId,
            });
          } else {
            await firestore
                .collection("chatMessages")
                .doc('groupChats')
                .collection(chatRoomId)
                .doc(messageId)
                .update({
              'receiverId': receiverUserId,
            });
          }
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
