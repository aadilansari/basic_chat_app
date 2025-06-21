class MessageModel {
  final int? id;
  final String sender;
  final String receiver;
  final String message;
  final DateTime timestamp;

  MessageModel({
    this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'sender': sender,
        'receiver': receiver,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        id: map['id'],
        sender: map['sender'],
        receiver: map['receiver'],
        message: map['message'],
        timestamp: DateTime.parse(map['timestamp']),
      );
}
