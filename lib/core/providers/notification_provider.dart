import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/features/models/notification_model.dart';
import 'package:flutter/material.dart';


class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  Future<void> fetchNotifications(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          // .where('receiverId', isEqualTo: userId)
          .get();
      _notifications = snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print("failed to get notifications");
      rethrow;
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      final docRef = await _firestore.collection('notifications').add(notification.toMap());
      // Assign Firestore-generated ID
      final newRequest = notification.copyWith(id: docRef.id);

      _notifications.add(newRequest);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

}

extension on NotificationModel {
  NotificationModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    DateTime? date,
    String? message,
    bool read = false ,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      date: date ?? this.date,
      message: message ?? this.message,
      read: read 
    );
  }
}
