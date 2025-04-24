import 'package:flutter/material.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  UserData({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': FieldValue.serverTimestamp(), // Add timestamp for new users
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
    );
  }
}

class UserProvider with ChangeNotifier {
  UserData? _user;
  final Map<String, UserData> _users = {}; 

  UserData? get user => _user;

  UserData? getUserById(String uid) => _users[uid];

  void setUser(UserData user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> fetchUsersData(List<String> ids) async {
    for (final id in ids) {
      if (!_users.containsKey(id)) {
        final data =
            await FirebaseFirestore.instance.collection('users').doc(id).get();
        if (data.exists) {
          _users[id] = UserData.fromMap(data.data()!);
        }
      }
    }
  }

  Future<void> fetchUser(String uid) async {
     if (_users.containsKey(uid)) {
      _user = _users[uid];
      notifyListeners();
      return;
    }
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        _user = UserData.fromMap(userDoc.data()!);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

}
