export 'package:firebase_core/firebase_core.dart';

class StatisticsModel {
  final String? id;
  final String? userId;
  final int pendingShipments;
  final int ongoingShipments;
  final int completedShipments;
  final int reviewCount;

  final int pendingTrips;
  final int ongoingTrips;
  final int completedTrips;

  StatisticsModel(
      {this.id,
      required this.pendingShipments,
      required this.ongoingShipments,
      required this.completedShipments,
      required this.reviewCount,
      this.pendingTrips = 0,
      this.ongoingTrips = 0,
      this.completedTrips = 0,
      required this.userId});
  Map<String, dynamic> toMap() {
    return {
      'pendingShipments': pendingShipments,
      'ongoingShipments': ongoingShipments,
      'completedShipments': completedShipments,
      'reviewCount': reviewCount,
      'pendingTrips' : pendingTrips,
      'ongoingTrips' : ongoingTrips,
      'completedTrips': completedTrips,
      'userId': userId
    };
  }

  factory StatisticsModel.fromMap(Map<String, dynamic> map, String id) {
    return StatisticsModel(
      id: id,
      pendingShipments: map['pendingShipments'],
      ongoingShipments: map['ongoingShipments'],
      completedShipments: map['completedShipments'],
      reviewCount: map['reviewCount'],
      userId: map['userId'],
      completedTrips: map['completedTrips'],
      ongoingTrips: map['ongoingTrips'],
      pendingTrips: map["pendingTrips"],
    );
  }
}
