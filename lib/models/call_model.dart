class CallModel {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialed;
  final bool isVideoCall;

  CallModel({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.callId,
    required this.hasDialed,
    required this.isVideoCall,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'callerId': callerId});
    result.addAll({'callerName': callerName});
    result.addAll({'callerPic': callerPic});
    result.addAll({'receiverId': receiverId});
    result.addAll({'receiverName': receiverName});
    result.addAll({'receiverPic': receiverPic});
    result.addAll({'callId': callId});
    result.addAll({'hasDialed': hasDialed});
    result.addAll({'isVideoCall': isVideoCall});

    return result;
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerPic: map['callerPic'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPic: map['receiverPic'] ?? '',
      callId: map['callId'] ?? '',
      hasDialed: map['hasDialed'] ?? false,
      isVideoCall: map['isVideoCall'] ?? false,
    );
  }
}
