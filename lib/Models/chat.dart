class Chat {
  final int id;
  final String messageId;
  final int sender_id;
  final int receiver_id;
  final String sender_type;
  final String receiver_type;
  final String message;
  final DateTime timestamp;
  final String? fileUrl; // Nullable, bisa null jika tidak ada file

  Chat({
    required this.id,
    required this.messageId,
    required this.sender_id,
    required this.receiver_id,
    required this.sender_type,
    required this.receiver_type,
    required this.message,
    required this.timestamp,
    this.fileUrl, // Bisa null jika tidak ada file
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? 0,
      messageId: json['message_id'] ?? '',
      sender_id: json['sender_id'] ?? 0,
      receiver_id: json['receiver_id'] ?? 0,
      sender_type: json['sender_type'] ?? '',
      receiver_type: json['receiver_type'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toString()),
      fileUrl: json['file_url'], // Bisa null, tidak perlu default value
    );
  }
}
