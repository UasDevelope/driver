class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String message;
  final DateTime timestamp;
  final String status;
  final String bookingId;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.timestamp,
    required this.status,
    required this.bookingId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderRole: json['senderRole'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'sent',
      bookingId: json['bookingId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderRole': senderRole,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'bookingId': bookingId,
    };
  }

  // Check if message is from current user (driver)
  bool get isFromMe => senderRole == 'serviceProvider';
  
  // Alias for isFromMe to match existing code
  bool get isMe => isFromMe;

  // Get display name
  String get displayName => senderName.isNotEmpty ? senderName : 'Unknown User';
}
