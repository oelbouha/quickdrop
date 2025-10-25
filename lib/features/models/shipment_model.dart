import 'package:quickdrop_app/features/models/base_transport.dart';

class Shipment extends TransportItem {
  final String description;
  final String length;
  final String width;
  final String height;
  final String packageName;
  final String packageQuantity;
  final String? imageUrl;
  final String type;

  @override
  String getTransportType() => "shipment";
  

  
  Shipment({
    String? id,
    String? matchedDeliveryId,
    String? matchedDeliveryUserId,

    required String from,
    required String to,
    required String weight,
    required this.description,
    required String date,
    required this.length,
    required this.width,
    required this.height,
    required this.packageName,
    required this.packageQuantity,
    required String userId,
    required this.type,
    required String price,
    String status = 'active',
    this.imageUrl,

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
          // receiverId: receiverId
        );

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'description': description,
        'length': length,
        'width': width,
        'height': height,
        'packageName': packageName,
        'packageQuantity': packageQuantity,
        'imageUrl': imageUrl,
        'type': type,
        'matchedDeliveryId': matchedDeliveryId,
        'matchedDeliveryUserId': matchedDeliveryUserId,
      });
  }

  factory Shipment.fromMap(Map<String, dynamic> map, String id) {
    return Shipment(
      id: id,
      from: map['from'],
      to: map['to'],
      weight: map['weight'],
      description: map['description'],
      date: map['date'],
      length: map['length'],
      width: map['width'],
      height: map['height'],
      packageName: map['packageName'],
      packageQuantity: map['packageQuantity'],
      imageUrl: map['imageUrl'],
      userId: map['userId'],
      status: map['status'] ?? 'active',
      type: map['type'],
      price: map['price'],
      matchedDeliveryId: map['matchedDeliveryId'],
      matchedDeliveryUserId: map['matchedDeliveryUserId'],
      // receiverId: map['receiverId']
    );
  }
}
