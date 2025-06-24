import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/features/models/delivery_request_model.dart';
import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/delivery_status.dart';

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

  void markRequestAsAccepted(String id) {
    final index = _requests.indexWhere((request) => request.id == id);
    if (index != -1) {
      _requests[index].status = DeliveryStatus.accepted;
      print("request is accepted ");
      // _requests.removeWhere((r) => r.id == id);
      notifyListeners();
    }
  }

  Future<void> addRequest(DeliveryRequest request) async {
    if (request.senderId == request.receiverId) {
      throw Exception("Sender and receiver cannot be the same");
    }
    try {
      final docRef =
          await _firestore.collection('requests').add(request.toMap());
      // Assign Firestore-generated ID
      final newRequest = request.copyWith(id: docRef.id);

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
