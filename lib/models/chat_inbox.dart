class ChatInboxModel {
  final String? id;
  final String message;
  final String senderId;
  final String recievrId;
  final DateTime time;
  final String? url;
  final bool isMe;
  final String? senderName;
  final String? senderRole;
  final String? status;
  final String? bookingId;

  ChatInboxModel({
    this.id,
    required this.message,
    required this.senderId,
    required this.recievrId,
    required this.time,
    this.url,
    required this.isMe,
    this.senderName,
    this.senderRole,
    this.status,
    this.bookingId,
  });

  factory ChatInboxModel.fromMap(Map<String, dynamic> map) {
    return ChatInboxModel(
      id: map["_id"],
      message: map["message"] ?? "",
      senderId: map["userId"] ?? map["senderId"] ?? "",
      recievrId: map["recievrId"] ?? "",
      time: map["timestamp"] != null
          ? DateTime.parse(map["timestamp"])
          : map["time"] != null
              ? DateTime.parse(map["time"])
              : DateTime.now(),
      url: map['url'],
      isMe: map["isMe"] ?? false,
      senderName: map["senderName"],
      senderRole: map["senderRole"],
      status: map["status"],
      bookingId: map["bookingId"],
    );
  }

  factory ChatInboxModel.fromSocketData(
      Map<String, dynamic> data, String currentUserId) {
    return ChatInboxModel(
      id: data["_id"],
      message: data["message"] ?? "",
      senderId: data["userId"] ?? "",
      recievrId: "", // Will be set based on logic
      time: data["timestamp"] != null
          ? DateTime.parse(data["timestamp"])
          : DateTime.now(),
      url: null,
      isMe: data["userId"] == currentUserId,
      senderName: data["senderName"],
      senderRole: data["senderRole"],
      status: data["status"],
      bookingId: data["bookingId"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": id,
      "message": message,
      "senderId": senderId,
      "recievrId": recievrId,
      "time": time.toIso8601String(),
      "url": url,
      "isMe": isMe,
      "senderName": senderName,
      "senderRole": senderRole,
      "status": status,
      "bookingId": bookingId,
    };
  }
}
