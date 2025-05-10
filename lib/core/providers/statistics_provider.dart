import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/features/models/statictics_model.dart';
import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/delivery_status.dart';

class StatisticsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StatisticsModel? _stats ;

  StatisticsModel? get stats => _stats;

  Future<void> fetchStatictics(String userId) async {
    final snapshot =
        await _firestore.collection('statistics').doc(userId).get();

    if (snapshot.exists) {
      _stats = StatisticsModel.fromMap(snapshot.data()!, userId);
    }

    notifyListeners();
  }

  Future<void> incrementField(String userId, String field) async {
    try {
      await _firestore.collection('statistics').doc(userId).update({
        field: FieldValue.increment(1),
      });

      await fetchStatictics(userId);
    } catch (e) {
      rethrow;
    }
  }

 Future<void> decrementField(String userId, String field) async {
  try {
    final doc = await _firestore.collection('statistics').doc(userId).get();

    if (!doc.exists) return;

    final data = doc.data();
    final currentValue = (data?[field] ?? 0) as int;

    if (currentValue > 0) {
      await _firestore.collection('statistics').doc(userId).update({
        field: FieldValue.increment(-1),
      });
      await fetchStatictics(userId);
    }
  } catch (e) {
    rethrow;
  }
}



  Future<void> addStatictics(String userId, StatisticsModel stats) async {
      try {
        await _firestore
            .collection('statistics')
            .doc(userId) 
            .set(stats.toMap());
      } catch (e) {
        rethrow;
      }
      notifyListeners();
    }

}

// extension on ReviewModel {
//   ReviewModel copyWith(
//       {String? id,
//       String? receiverId,
//       String? senderId,
//       String? date,
//       String? message,
//       double? rating}) {
//     return ReviewModel(
//         id: id ?? this.id,
//         senderId: senderId ?? this.senderId,
//         receiverId: receiverId ?? this.receiverId,
//         date: date ?? this.date,
//         message: message ?? this.message,
//         rating: rating ?? this.rating);
//   }
// }
