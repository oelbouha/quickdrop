import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/features/models/delivery_request_model.dart';
import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/delivery_status.dart';
import 'package:quickdrop_app/features/models/shipment_model.dart';
import 'package:quickdrop_app/features/models/trip_model.dart';

class DeliveryRequestProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DeliveryRequest> _requests = [];
  Map<String, Map<String, dynamic>> _userData = {};

  List<DeliveryRequest> get requests => _requests;

  List<DeliveryRequest> get activeRequests =>
      _requests.where((item) => item.status == DeliveryStatus.active).toList();

  DeliveryRequest? getRequest(String id) {
      try {
          final request = _requests.firstWhere((item) => item.id == id);
          return request;
      }
      catch (e) {

          return null;
      }
      // return _requests.firstWhere((item) => item.id == id,
      //   orElse: () => throw ("DeliveryRequest not found"));
  }

  Future<DeliveryRequest?> fetchRequestById(String requestId) async {
    try {
      final snapshot = await _firestore.collection('requests').doc(requestId).get();
      if (snapshot.exists) {
        return DeliveryRequest.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

 Future<void> fetchRequests(String userId) async {
  try {
    // Fetch sender requests
    final senderSnapshot = await _firestore
        .collection('requests')
        .where('senderId', isEqualTo: userId)
        .get();

    // Fetch receiver requests
    final receiverSnapshot = await _firestore
        .collection('requests')
        .where('receiverId', isEqualTo: userId)
        .get();

    // Combine and deduplicate results
    final allDocs = [...senderSnapshot.docs, ...receiverSnapshot.docs];
    final uniqueDocs = allDocs.fold<Map<String, QueryDocumentSnapshot>>(
      {},
      (map, doc) => map..putIfAbsent(doc.id, () => doc),
    ).values;

    _requests = uniqueDocs
        .map((doc) => DeliveryRequest.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    notifyListeners();
  } catch (e) {
    // print('Error fetching requests: $e');
    _requests = [];
    notifyListeners();
    rethrow;
  }
}

  Future<void> deleteRequestsByShipmentId(String shipmentId) async {
    try {
      _requests.removeWhere((request) => request.shipmentId == shipmentId);
      final snapshot = FirebaseFirestore.instance
          .collection('requests')
          .where('shipmentId', isEqualTo: shipmentId)
          .get();
      snapshot.then((value) {
        for (var doc in value.docs) {
          FirebaseFirestore.instance
              .collection('requests')
              .doc(doc.id)
              .delete();
        }
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteActiveRequestsByShipmentId(String shipmentId, String requestId) async {
    try {
      print("removing requests from database");
      _requests.removeWhere((request) => request.shipmentId == shipmentId);
      final snapshot = FirebaseFirestore.instance
          .collection('requests')
          .where('shipmentId', isEqualTo: shipmentId)
          .where('status', isEqualTo: DeliveryStatus.active)
          .where('id', isNotEqualTo: requestId)
          .get();
      snapshot.then((value) {
        for (var doc in value.docs) {
          FirebaseFirestore.instance
              .collection('requests')
              .doc(doc.id)
              .delete();
        }
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRequestsByTripId(String tripId) async {
    try {
      _requests.removeWhere((request) => request.tripId == tripId);
      final snapshot = FirebaseFirestore.instance
          .collection('requests')
          .where('tripId', isEqualTo: tripId)
          .get();
      snapshot.then((value) {
        for (var doc in value.docs) {
          FirebaseFirestore.instance
              .collection('requests')
              .doc(doc.id)
              .delete();
        }
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void updateRequestStatus(String id, String status) async {
      await FirebaseFirestore.instance
        .collection("requests")
        .doc(id)
        .update({"status": status});
    final index = _requests.indexWhere((request) => request.id == id);
    if (index != -1) {
      _requests[index].status = status;
      notifyListeners();
    }
  }

  void markRequestAsAccepted(String id) {
    final index = _requests.indexWhere((request) => request.id == id);
    if (index != -1) {
      _requests[index].status = DeliveryStatus.accepted;
      print("request is accepted ");
      // _requests.removeWhere((r) => r.id == id);
      notifyListeners();
    }
  }



  Future<void> sendRequest(Trip trip, Shipment shipment) async {
    try {
      if (trip.userId == shipment.userId) {
        throw Exception("Trip owner cannot send request for their own shipment");
      }

      final request = DeliveryRequest(
        senderId: trip.userId,
        receiverId: shipment.userId,
        date: DateTime.now().toIso8601String(),
        status: DeliveryStatus.active,
        price: shipment.price,
        shipmentId: shipment.id!,
        tripId: trip.id!,
        id: trip.id! + shipment.id!,
      );

      // Check if a request already exists for this trip and shipment
      final doc =  await FirebaseFirestore.instance
          .collection('requests')
          .doc(request.id)
          .get();
      if (doc.exists) {
        throw ("You have already sent a request for this shipment. please wait for the owner to accept or reject it.");
      }
      await addRequest(request);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> addRequest(DeliveryRequest request) async {
    try {
          await _firestore.collection('requests').doc(request.id).set(
            request.toMap(),
            SetOptions(merge: true) // Use merge to avoid overwriting existing data
        );
      // Assign Firestore-generated ID
      final newRequest = request.copyWith(id: request.id);

      _requests.add(newRequest);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRequest(String documentId) async {
    try {
      await _firestore.collection('requests').doc(documentId).delete();
      _requests.removeWhere((request) => request.id == documentId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}

extension on DeliveryRequest {
  DeliveryRequest copyWith({
    String? id,
    String? receiverId,
    String? senderId,
    String? date,
    String? status,
    String? price,
    String? shipmentId,
    String? tripId,
  }) {
    return DeliveryRequest(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        date: date ?? this.date,
        status: status ?? this.status,
        price: price ?? this.price,
        shipmentId: shipmentId ?? this.shipmentId,
        tripId: tripId ?? this.tripId);
  }
}
