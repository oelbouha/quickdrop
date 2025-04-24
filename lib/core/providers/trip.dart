
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/features/models/trip_model.dart';
import 'package:flutter/material.dart';

class TripProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Trip> _trips = [];

  Map<String, Map<String, dynamic>> _userData = {};

  List<Trip> get trips => _trips;
  List<Trip> get activeTrips => _trips.where((item) => item.status == "active").toList();

Map<String, String> getUserData(userId) {
  var map = <String, String>{}; 
  map["displayName"] = _userData[userId]?['displayName'] ?? "Unknown user";
  map["photoUrl"] = _userData[userId]?['photoUrl'] ?? 'assets/images/profile.png';
  return map;
}

  Future<void> fetchTrips() async {
    try{
      final snapshot = await _firestore.collection('trips').get();
      _trips = snapshot.docs
          .map((doc) => Trip.fromMap(doc.data(), doc.id))
          .toList();
        
      if (_trips.isEmpty) {
        return;
      }
      final userIds = _trips.map((s) => s.userId).toSet().toList();


        final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();
      _userData = {for (var doc in userSnapshot.docs) doc.id: doc.data()};
      notifyListeners();
    } catch (e) {
      // print("Error fetching trips: $e");
      rethrow;
    }
  }

  Future<void> addTrip(Trip trip) async {
    final docRef = await _firestore.collection('trips').add(trip.toMap());
    _trips.add(trip.copyWith(id: docRef.id));
    notifyListeners();
  }
  
   Future<void> deleteTrip(String documentId) async {
    try {
      await _firestore.collection('trips').doc(documentId).delete();
      _trips.removeWhere((trip) => trip.id == documentId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatus(String id, String newStatus) async {
    await FirebaseFirestore.instance
        .collection("trips")
        .doc(id)
        .update({"status": newStatus});

      final index = _trips.indexWhere((item) => item.id == id);
      if (index != -1) {
        _trips[index] = _trips[index].copyWith(status: newStatus);
      }

    notifyListeners();
  }
  List<Trip> getActiveTrips(String userId) {
    return _trips.where((s) => s.userId == userId && s.status == 'active').toList();
  }
}

extension on Trip {
  Trip copyWith({
    String? id,
    String? from,
    String? to,
    String? weight,
    // String? description,
    String? date,
    // String? packageName,
    // String? packageQuantity,
    String? userId,
    String? status,
    String? price,
  }) {
    return Trip(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      weight: weight ?? this.weight,
      // description: description ?? this.description,
      date: date ?? this.date,
      // packageName: packageName ?? this.packageName,
      // // // packageQuantity: packageQuantity ?? this.packageQuantity,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      price: price ?? this.price,
      matchedDeliveryId: matchedDeliveryId,
      matchedDeliveryUserId: matchedDeliveryUserId 
    );
  }
}