class Chat {
  final int id;
  final int sender_id;
  final int receiver_id;
  final String sender_type;
  final String receiver_type;
  final String message;
  final DateTime timestamp;

  Chat({
    required this.id,
    required this.sender_id,
    required this.receiver_id,
    required this.sender_type,
    required this.receiver_type,
    required this.message,
    required this.timestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      sender_id: json['sender_id'],
      receiver_id: json['receiver_id'],
      sender_type: json['sender_type'],
      receiver_type: json['receiver_type'],
      message: json['message'],
      timestamp: DateTime.parse(json['created_at']),
    );
  }
}
