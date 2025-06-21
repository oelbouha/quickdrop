import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/features/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/delivery_status.dart';

class ReviewProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ReviewModel> _reviews = [];
  List<ReviewModel> get reviews => _reviews;

 Future<double> getUserAverageRating(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('reviews') 
          .where('receiverId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 0.0; 
      }

      double totalRating = 0.0;
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        totalRating += (doc.data() as Map<String, dynamic>)['rating'] ?? 0.0;
      }

      return totalRating / querySnapshot.docs.length;
    } catch (e) {
      print('Error fetching user rating: $e');
      return 0.0;
    }
  }
  
  Future<void> fetchReviews(String userId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('receiverId', isEqualTo: userId)
        .get();
    _reviews = snapshot.docs
        .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
        .toList();
    // print("reviews $snapshot");
    notifyListeners();
  }

  Future<void> deleteReviewById(String id) async {
    try {
      _reviews.removeWhere((request) => request.id == id);
      final snapshot = FirebaseFirestore.instance
          .collection('reviews')
          .where('id', isEqualTo: id)
          .get();
      snapshot.then((value) {
        for (var doc in value.docs) {
          FirebaseFirestore.instance.collection('reviews').doc(doc.id).delete();
        }
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReview(ReviewModel review) async {
    try {
      final docRef = await _firestore.collection('reviews').add(review.toMap());
      // Assign Firestore-generated ID
      final newRequest = review.copyWith(id: docRef.id);

      _reviews.add(newRequest);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRequest(String documentId) async {
    try {
      await _firestore.collection('reviews').doc(documentId).delete();
      _reviews.removeWhere((request) => request.id == documentId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}

extension on ReviewModel {
  ReviewModel copyWith(
      {String? id,
      String? receiverId,
      String? senderId,
      String? date,
      String? message,
      double? rating}) {
    return ReviewModel(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        date: date ?? this.date,
        message: message ?? this.message,
        rating: rating ?? this.rating);
  }
}
