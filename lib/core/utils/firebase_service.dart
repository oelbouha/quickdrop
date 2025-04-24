import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickdrop_app/features/models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserToFirestore(User user) async {
    try {
      final userData = UserData(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName ?? 'User_${user.uid.substring(0, 6)}', // Default displayName if null
        photoUrl: user.photoURL,
      );

      // Check if user already exists in Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        // Only save if the user doesn't exist
        await _firestore.collection('users').doc(user.uid).set(userData.toMap());
      }
    } catch (e) {
      print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
           print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
            print('Error saving user to Firestore: $e');
       
    }
  }
}