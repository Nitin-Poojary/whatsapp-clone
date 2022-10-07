class Group {
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final String senderId;
  final List<String> memberUid;
  final DateTime timeSent;

  Group({
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.senderId,
    required this.memberUid,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'groupId': groupId});
    result.addAll({'lastMessage': lastMessage});
    result.addAll({'groupPic': groupPic});
    result.addAll({'senderId': senderId});
    result.addAll({'memberUid': memberUid});
    result.addAll({'timeSent': timeSent.millisecondsSinceEpoch});

    return result;
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      senderId: map['senderId'] ?? '',
      memberUid: List<String>.from(map['memberUid']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }
}
