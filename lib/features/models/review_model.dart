export 'package:firebase_core/firebase_core.dart';

class ReviewModel {
  final String? id;
  final String receiverId;
  final String senderId;
  final String date;
  final String message;
  final double rating;

  ReviewModel({
    this.id,
    required this.receiverId,
    required this.senderId,
    required this.date,
    required this.message,
    required this.rating,
  });
  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'senderId': senderId,
      'date': date,
      'message': message,
      'rating': rating
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewModel(
      id: id,
      receiverId: map['receiverId'],
      senderId: map['senderId'],
      date: map['date'],
      message : map['message'],
      rating: map['rating'],
    );
 
 }
}