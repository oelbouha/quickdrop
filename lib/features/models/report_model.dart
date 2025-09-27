export 'package:firebase_core/firebase_core.dart';

class ReportModel {
  final String? id;
  final String receiverId;
  final String senderId;
  final String date;
  final String message;

  ReportModel({
    this.id,
    required this.receiverId,
    required this.senderId,
    required this.date,
    required this.message,
  });
  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'senderId': senderId,
      'date': date,
      'message': message,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map, String id) {
    return ReportModel(
      id: id,
      receiverId: map['receiverId'],
      senderId: map['senderId'],
      date: map['date'],
      message : map['message'],
    );
 
 }
}