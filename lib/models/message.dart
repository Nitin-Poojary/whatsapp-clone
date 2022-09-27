import 'package:whatsappclone/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final bool isSeen;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'senderId': senderId});
    result.addAll({'receiverId': receiverId});
    result.addAll({'text': text});
    result.addAll({'type': type.type});
    result.addAll({'timeSent': timeSent.millisecondsSinceEpoch});
    result.addAll({'isSeen': isSeen});

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isSeen: map['isSeen'] ?? false,
    );
  }
}
