
export  'package:firebase_core/firebase_core.dart';

class DeliveryRequest {
  final String? id;
  final String receiverId;
  final String senderId;
  final String date;
  String status;
  final String shipmentId;
  final String tripId;
  final String price;

  DeliveryRequest({
    this.id,
    required this.receiverId,
    required this.senderId,
    required this.date,
    required this.shipmentId,
    required this.tripId,
    required this.price,
    this.status = "active" 
  });
  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'senderId': senderId,
      'date': date,
      'status': status,
      'shipmentId': shipmentId,
      'price': price,
      'tripId': tripId
    };
  }

  factory DeliveryRequest.fromMap(Map<String, dynamic> map, String id) {
    return DeliveryRequest(
      id: id,
      receiverId: map['receiverId'],
      senderId: map['senderId'],
      date: map['date'],
      status: map['status'],
      shipmentId : map['shipmentId'],
      price : map['price'],
      tripId : map['tripId']
    );
  }
}