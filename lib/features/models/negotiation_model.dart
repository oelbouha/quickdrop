


export  'package:firebase_core/firebase_core.dart';

class NegotiationModel {
  final String? id;
  final String receiverId;
  final String senderId;
  final String timestamp;
  final bool seen;
  final String message;
  final String price;
  final String? shipmentId;
  final String? requestId;

  NegotiationModel({
    this.id,
    required this.receiverId,
    required this.senderId,
    required this.timestamp,
    this.seen = false,
    required this.message,
    required this.price,
    required this.shipmentId,
    required this.requestId
  });
  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'senderId': senderId,
      'timestamp': timestamp,
      'seen': seen,
      'price': price,
      'message': message,
      'shipmentId': shipmentId,
      'requestId': requestId
    };
  }

  factory NegotiationModel.fromMap(Map<String, dynamic> map, String id) {
    return NegotiationModel(
      id: id,
      receiverId: map['receiverId'],
      senderId: map['senderId'],
      timestamp: map['timestamp'],
      seen: map['seen'],
      price : map['price'],
      message : map['message'],
      shipmentId : map['shipmentId'],
      requestId : map['requestId'],
    );
  }
}