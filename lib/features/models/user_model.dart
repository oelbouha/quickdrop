import 'package:flutter/material.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  String? phoneNumber;
  String? createdAt;
  String status = "normal";

  UserData(
      {required this.uid,
      this.email,
      this.displayName,
      this.photoUrl,
      this.phoneNumber,
      this.createdAt});
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'status': status,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
        uid: map['uid'],
        email: map['email'],
        displayName: map['displayName'],
        photoUrl: map['photoUrl'],
        phoneNumber: map['phoneNumber'],
        createdAt: map["createdAt"]);
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

  Future<void> updateUserInfo(UserData updatedUser) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(updatedUser.uid);
    // final docSnapshot = await userDocRef.get();

    final updateMap = {
      if (updatedUser.email != null) 'email': updatedUser.email,
      if (updatedUser.displayName != null)
        'displayName': updatedUser.displayName,
      if (updatedUser.photoUrl != null) 'photoUrl': updatedUser.photoUrl,
    };
    userDocRef.update(updateMap);
    await fetchUser(updatedUser.uid);
    _users[updatedUser.uid] = _user!;
    notifyListeners();
  }

  Future<void> saveUserToFirestore(UserData user) async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await userDocRef.get();

      final userMap = user.toMap();

      if (!docSnapshot.exists) {
        await userDocRef.set(userMap);
        _users[user.uid] = user;
        _user = user;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
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
    // if (_users.containsKey(uid)) {
    //   _user = _users[uid];
    //   notifyListeners();
    //   return;
    // }
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        // print("user exist ");
        _user = UserData.fromMap(userDoc.data()!);
        // print(_user!.displayName);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}

extension on UserData {
  UserData copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? createdAt,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
