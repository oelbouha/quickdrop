
export  'package:firebase_core/firebase_core.dart';

class ChatModel {
  final String? id;
  final String receiverId;
  final String senderId;
  final String timestamp;
  final bool seen;
  final String text;
  final String type;

  ChatModel({
    this.id,
    required this.receiverId,
    required this.senderId,
    required this.timestamp,
    this.seen = false,
    required this.text,
    required this.type,
  });
  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'senderId': senderId,
      'timestamp': timestamp,
      'seen': seen,
      'type': type,
      'text': text
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      id: id,
      receiverId: map['receiverId'],
      senderId: map['senderId'],
      timestamp: map['timestamp'],
      seen: map['seen'],
      type : map['type'],
      text : map['text']
    );
  }
}