import 'package:whatsappclone/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final List<String> receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;
  final String messageId;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
    required this.messageId,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'senderId': senderId});
    result.addAll({'receiverId': receiverId});
    result.addAll({'text': text});
    result.addAll({'type': type.type});
    result.addAll({'timeSent': timeSent.millisecondsSinceEpoch});
    result.addAll({'isSeen': isSeen});
    result.addAll({'messageId': messageId});
    result.addAll({'repliedMessage': repliedMessage});
    result.addAll({'repliedTo': repliedTo});
    result.addAll({'repliedMessageType': repliedMessageType.type});

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: List<String>.from(map['receiverId']),
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isSeen: map['isSeen'] ?? false,
      messageId: map['messageId'] ?? '',
      repliedMessage: map['repliedMessage'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }
}
