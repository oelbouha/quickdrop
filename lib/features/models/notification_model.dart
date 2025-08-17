import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime date;
   bool read;

  NotificationModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.date,
    required this.read,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data, String docId) {
    return NotificationModel(
      id: docId,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      message: data['message'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: data['read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'date': date,
      'read': read,
    };
  }
}
