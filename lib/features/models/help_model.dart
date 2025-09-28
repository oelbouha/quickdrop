export 'package:firebase_core/firebase_core.dart';

class HelpModel {
  final String? id;
  final String senderId;
  final String date;
  final String message;

  HelpModel({
    this.id,
    required this.senderId,
    required this.date,
    required this.message,
  });
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'date': date,
      'message': message,
    };
  }

  factory HelpModel.fromMap(Map<String, dynamic> map, String id) {
    return HelpModel(
      id: id,
      senderId: map['senderId'],
      date: map['date'],
      message : map['message'],
    );
 
 }
}