import 'package:flutter/material.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/statictics_model.dart';

class UserData {
  final String uid;
  final String? email;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;
  String? phoneNumber;
  String? createdAt;
  String? fcmToken;
  String? idNumber;
  String? carPlateNumber;
  String? carModel;
  String? driverNumber;
  String status;

  UserData(
      {required this.uid,
      this.email,
      this.displayName,
      this.firstName,
      this.lastName,
      this.photoUrl,
      this.phoneNumber,
      this.createdAt,
      this.fcmToken,
      this.idNumber,
      this.carPlateNumber,
      this.carModel,
      this.driverNumber,
      this.status = "Customer"});
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'status': status,
      'phoneNumber': phoneNumber,
      'idNumber': idNumber,
      'carPlateNumber': carPlateNumber,
      'carModel': carModel,
      'driverNumber': driverNumber,
      'fcmToken': fcmToken
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
        uid: map['uid'],
        email: map['email'],
        displayName: map['displayName'],
        photoUrl: map['photoUrl'],
        phoneNumber: map['phoneNumber'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        status: map['status'] ?? "Customer",
        fcmToken: map['fcmToken'],
        idNumber: map['idNumber'],
        carPlateNumber: map['carPlateNumber'],
        carModel: map['carModel'],
        driverNumber: map['driverNumber'],
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

  void updateUserFcmToken(String token, String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }

  Future<bool> doesUserRequestDriverMode(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('driverRequests')
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e) {
      // print("Error checking driver request: $e");
      return false;
    }
  }

  Future<void> requestDriverMode(UserData user) async {
    try {
      FirebaseFirestore.instance.collection('driverRequests').doc(user.uid).set(
            user.toMap(),
            SetOptions(merge: true),
          );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      await snapshot.reference.delete();
      // for (var doc in snapshot.docs) {
      // }

      notifyListeners();
    } catch (e) {
      // print("Error fetching shipments: $e");
      rethrow;
    }
  }

  Future<void> updateUserInfo(UserData updatedUser) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(updatedUser.uid);

    // final docSnapshot = await userDocRef.get();

    final updateMap = {
      if (updatedUser.email != null) 'email': updatedUser.email,
      if (updatedUser.displayName != null)
        'displayName': updatedUser.displayName,
      if (updatedUser.firstName != null) 'firstName': updatedUser.firstName,
      if (updatedUser.lastName != null) 'lastName': updatedUser.lastName,
      if (updatedUser.phoneNumber != null)
        'phoneNumber': updatedUser.phoneNumber,
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

  Future<UserData> fetchUserData(String uid) async {
    if (_users.containsKey(uid)) {
      return _users[uid]!;
    }
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      // print("userDoc: ${userDoc.data()}");
      if (userDoc.exists) {
        final user = UserData.fromMap(userDoc.data()!);
        _users[uid] = user;
        // print("User fetched: ${user.displayName}");
        return user;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }


  Future<void> singOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      _user = null;
      _users.clear();
      notifyListeners();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }
  
  Future<void> signInWithGoogle(BuildContext context) async {
    try {

       final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
       await googleSignIn.signOut();

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

       final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw Exception('User credential is null');
      }
      UserData user = UserData(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        firstName: userCredential.user!.displayName?.split(' ').first,
        lastName: userCredential.user!.displayName?.split(' ').last,
        phoneNumber: userCredential.user!.phoneNumber,
        displayName: userCredential.user!.displayName,
        photoUrl: userCredential.user!.photoURL,
        createdAt: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
      );
      StatisticsModel stats = StatisticsModel(
        pendingShipments: 0,
        ongoingShipments: 0,
        completedShipments: 0,
        pendingTrips: 0,
        ongoingTrips: 0,
        completedTrips: 0,
        reviewCount: 0,
        id: user.uid,
        userId: user.uid,
      );
      await Provider.of<StatisticsProvider>(context, listen: false)
          .addStatictics(user.uid, stats);
      _user = user;
      await saveUserToFirestore(user);
      
          context.go('/home');
        
      notifyListeners();
    }  on FirebaseAuthException catch (e) {
      throw Exception('Error signing in with Google: $e');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> singUpUserWithEmail(
      String email,
      String password,
      String firstName,
      String lastName,
      String phoneNumber,
      BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserData user = UserData(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        firstName: firstName,
        lastName: lastName,
        displayName: "${firstName} ${lastName}",
        phoneNumber: phoneNumber,
        photoUrl: null,
        createdAt: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
      );

      StatisticsModel stats = StatisticsModel(
        pendingShipments: 0,
        ongoingShipments: 0,
        completedShipments: 0,
        pendingTrips: 0,
        ongoingTrips: 0,
        completedTrips: 0,
        reviewCount: 0,
        id: user.uid,
        userId: user.uid,
      );
      await Provider.of<StatisticsProvider>(context, listen: false)
          .addStatictics(user.uid, stats);
      _user = user;
      await saveUserToFirestore(user);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        default:
          errorMessage = e.message ?? 'An error occurred during sign-up.';
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> signInUserWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await fetchUser(userCredential.user!.uid);
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = AppTheme.loginErrorMessage;
          break;
        case 'wrong-password':
          errorMessage = AppTheme.loginErrorMessage;
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'invalid-credential':
          errorMessage = AppTheme.loginErrorMessage;
          break;
        default:
          errorMessage = e.message ?? 'An error occurred during login.';
      }
      throw Exception(errorMessage);
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
