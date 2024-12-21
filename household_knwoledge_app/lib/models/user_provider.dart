
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser; // Your custom User model

  User? get currentUser => _currentUser;

  
  List<User> familyMembers = [];

  // Call this after user logs in or registers
  Future<void> loadCurrentUser() async {
    final auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      // Not signed in then..
      return;
    }

    // Fetch user's document from Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
    if (userDoc.exists) {
      _currentUser = User.fromMap(userDoc.data()!);
      notifyListeners();
    }
  }

  // Update current user in Firestore and in local state
  Future<void> updateUserData(User updatedUser) async {
    final auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).update(updatedUser.toMap());
    _currentUser = updatedUser;
    notifyListeners();
  }

  // Example method to add points to a user
  Future<void> addPointsToUser(int pointsToAdd) async {
    if (_currentUser == null) return;
    _currentUser!.addPoints(pointsToAdd);
    await updateUserData(_currentUser!);
  }
  Stream<List<User>> getFamilyMembers(User currUser) {
    if (currUser.familyId == null) {
      // Return an empty stream or handle as needed
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .where('familyId', isEqualTo: currUser.familyId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => User.fromMap(doc.data()))
            .toList());
  }
void fetchFamilyMembers(User currUser) {
    if (currUser.familyId == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .where('familyId', isEqualTo: currUser.familyId)
        .snapshots()
        .listen((snapshot) {
      familyMembers = snapshot.docs
          .map((doc) => User.fromMap(doc.data()))
          .toList();
      notifyListeners();
    });
  }

  ImageProvider<Object> getProfileOfCurrUser() {
    if (_currentUser == null) {
      return AssetImage('lib/assets/f.jpeg');
    }
    String p = _currentUser!.profilepath;
    return p.startsWith('lib/assets/') ? AssetImage(p) : FileImage(File(p));
  }
}
