import 'package:quickdrop_app/features/models/base_transport.dart';

class Trip extends TransportItem {
  Trip({
    String? id,
    String? matchedDeliveryId,
    String? matchedDeliveryUserId,
    String status = 'active',
    required String from,
    required String to,
    required String weight,
    required String price,
    required String date,
    required String userId,
  }) : super(
          id: id,
          from: from,
          to: to,
          weight: weight,
          date: date,
          userId: userId,
          price: price,
          status: status,
          matchedDeliveryId: matchedDeliveryId,
          matchedDeliveryUserId: matchedDeliveryUserId,
        );

  @override
  String getTransportType() => "trip";

  @override
  Map<String, dynamic> toMap() {
    return super.toMap();
  }

  factory Trip.fromMap(Map<String, dynamic> map, String id) {
    return Trip(
      id: id,
      from: map['from'],
      to: map['to'],
      weight: map['weight'],
      price: map['price'],
      date: map['date'],
      userId: map['userId'],
      matchedDeliveryId: map['matchedDeliveryId'],
      matchedDeliveryUserId: map['matchedDeliveryUserId'],
      status: map['status'] ?? 'active',
    );
  }
}
