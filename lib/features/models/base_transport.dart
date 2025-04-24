abstract class TransportItem {
  final String? id;
  final String? matchedDeliveryId;
  final String? matchedDeliveryUserId;
  final String? receiverId;
  final String from;
  final String to;
  final String weight;
  final String price;
  final String date;
  final String userId;
  final String status;

  String getTransportType();

  TransportItem({
    this.id,
    this.matchedDeliveryId,
    this.matchedDeliveryUserId,
    this.receiverId,
    required this.from,
    required this.to,
    required this.weight,
    required this.price,
    required this.date,
    required this.userId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receiverId': receiverId,
      'from': from,
      'to': to,
      'weight': weight,
      'price': price,
      'date': date,
      'userId': userId,
      'status': status,
      'matchedDeliveryId': matchedDeliveryId,
      'matchedDeliveryUserId': matchedDeliveryUserId,
    };
  }
}
