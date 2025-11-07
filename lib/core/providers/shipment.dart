import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'dart:io'; 
import 'package:firebase_storage/firebase_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShipmentProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Shipment> _shipments = [];

  List<Shipment> get shipments => _shipments;
  List<Shipment> get activeShipments =>
      _shipments.where((item) => item.status == DeliveryStatus.active).toList();

  Shipment getShipment(String id) {
    return _shipments.firstWhere((item) => item.id == id,
        orElse: () => throw ("shipment not found"));
  }


 
  Future<void> fetchShipments() async {
    try {
        final snapshot = await _firestore.collection('shipments').get();
        _shipments = snapshot.docs
            .map((doc) => Shipment.fromMap(doc.data(), doc.id))
            .toList();
        notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<Shipment?> fetchShipmentById(String id) async {
    try {
        final snapshot = await _firestore.collection('shipments').doc(id).get();
       return Shipment.fromMap(snapshot.data()!, snapshot.id);
    } catch (e) {
      return null;
    }
  }


 Future<void> deleteShipmentsByUserId(String userId) async {
    try {
        final snapshot = await _firestore.collection('shipments')
        .where('userId', isEqualTo: userId)
        .get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
       
        notifyListeners();
    } catch (e) {
      // print("Error fetching shipments: $e");
      rethrow;
    }
  }

  Future<void> fetchShipmentsByUserId(String userId) async {
    try {
        final snapshot = await _firestore.collection('shipments')
        .where('userId', isEqualTo: userId)
        .get();
        _shipments = snapshot.docs
            .map((doc) => Shipment.fromMap(doc.data(), doc.id))
            .toList();
        if (_shipments.isEmpty) {
          return;
        }
        notifyListeners();
    } catch (e) {
      // print("Error fetching shipments: $e");
      rethrow;
    }
  }


  Future<void> updateStatus(String id, String newStatus) async {
    await FirebaseFirestore.instance
        .collection("shipments")
        .doc(id)
        .update({"status": newStatus});

    final index = _shipments.indexWhere((item) => item.id == id);
    if (index != -1) {
      _shipments[index] = _shipments[index].copyWith(status: newStatus);
    }

    notifyListeners();
  }
  
  Future<void> updateShipment(String id, Shipment newShipment) async {
    await FirebaseFirestore.instance
        .collection("shipments")
        .doc(id)
        .update(newShipment.toMap());

    final index = _shipments.indexWhere((item) => item.id == id);
    if (index != -1) {
      _shipments[index] = newShipment;
    }
    notifyListeners();
  }

  Future<void> updatePrice(String id, String price) async {
    await FirebaseFirestore.instance
        .collection("shipments")
        .doc(id)
        .update({"price": price});

    notifyListeners();
  }

  Future<void> addShipment(Shipment shipment) async {
    final docRef =
        await _firestore.collection('shipments').add(shipment.toMap());
    _shipments.add(shipment.copyWith(id: docRef.id));
    notifyListeners();
  }

  Future<void> deleteShipment(String documentId) async {
    try {
      await _firestore.collection('shipments').doc(documentId).delete();
      _shipments.removeWhere((shipment) => shipment.id == documentId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }



  Future<void> fetchShipmentsByIds(List<String> ids) async {
    try {
       if (ids.isEmpty) {
        _shipments = [];
        notifyListeners();
        return; 
      }
      final snapshot = await _firestore
          .collection('shipments')
          .where(FieldPath.documentId, whereIn: ids)
          .get();
      _shipments = snapshot.docs
          .map((doc) => Shipment.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
    
  Future<void> fetchShipment(String documentId) async {
    try {
      await _firestore.collection('shipments').doc(documentId).get();
      // _shipments.removeWhere((shipment) => shipment.id == documentId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadImageToSupabase(File image) async {
  try {
    final supabase = Supabase.instance.client;
    
    // Generate unique filename
    String fileName = 'shipments/${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    // Upload file to Supabase Storage
    await supabase.storage
        .from('quickdrop-images') 
        .upload(fileName, image);
    
    // Get public URL
    final publicUrl = supabase.storage
        .from('quickdrop-images')
        .getPublicUrl(fileName);
    
    return publicUrl;
  } catch (e) {
    
    return null;
  }
}
  List<Shipment> getActiveShipments(String userId) {
    return _shipments
        .where((s) => s.userId == userId && s.status == 'active')
        .toList();
  }
}

extension on Shipment {
  Shipment copyWith({
    String? id,
    String? from,
    String? to,
    String? weight,
    String? description,
    String? date,
    String? length,
    String? width,
    String? height,
    String? packageName,
    String? packageQuantity,
    String? imageUrl,
    String? userId,
    String? status,
    String? type,
    String? price,
  }) {
    return Shipment(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      weight: weight ?? this.weight,
      description: description ?? this.description,
      date: date ?? this.date,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      packageName: packageName ?? this.packageName,
      packageQuantity: packageQuantity ?? this.packageQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      price: price ?? this.price,
      type: type ?? this.type,
      matchedDeliveryId: matchedDeliveryId,
      matchedDeliveryUserId: matchedDeliveryUserId 
    );
  }
}
