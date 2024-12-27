
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
   
     // Not signed in then..
     if (auth.FirebaseAuth.instance.currentUser == null) {
       return;
    }
  
    // Fetch user's document from Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(auth.FirebaseAuth.instance.currentUser!.uid).get();
    if (userDoc.exists) {
      _currentUser = User.fromMap(userDoc.data()!, userDoc.id);

      notifyListeners();
    } else {
      // User document does not exist; handle accordingly
      _currentUser = null;
      notifyListeners();
    }
  }

  // Update current user in Firestore and in local state
  // Future<void> updateUserData(User updatedUser) async {
  //   final auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
  //   if (firebaseUser == null) return;

  //   await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).update(updatedUser.toMap());
  //   _currentUser = updatedUser;
  //   notifyListeners();
  // }

  // Example method to add points to a user
  Future<void> addPointsToUser(int pointsToAdd) async {
    if (_currentUser == null) return;
    await _currentUser!.addPoints(pointsToAdd);
    notifyListeners();
  }

  Future<void> setPreferencesForUser(List<String> newPreferences) async {
    if (_currentUser == null) return;
    await _currentUser!.setPreferences(newPreferences);
    notifyListeners();
  }
  Future<void> updateContributionsForUser(Map<String, int> newContributions) async {
    if (_currentUser == null) return;
    await _currentUser!.updateContributions(newContributions);
    notifyListeners();
  }
  
  Future<void> updateProfilePath(String newPath) async {
    if (_currentUser == null) return;
    await _currentUser!.updateProfilePic(newPath);
    notifyListeners();
  }
  Future<void> toggleCameraPermission() async {
    if (_currentUser == null) return;
    await _currentUser!.toggleCameraPermissionForUser();
    notifyListeners();
  }
  Future<void> toggleGalleryPermission() async {
    if (_currentUser == null) return;
    //try{
      await _currentUser!.toggleGalleryPermissionForUser();
    //}catch(e){print(e);}
    notifyListeners();
  }
  Future<void> toggleGeolocationPermission() async {
    if (_currentUser == null) return;
    await _currentUser!.toggleGeolocationPermissionForUser();
    notifyListeners();
  }
  Future<void> toggleNotificationsEnabled() async {
    if (_currentUser == null) return;
    await _currentUser!.toggleNotificationsEnabledForUser();
    notifyListeners();
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
            .map((doc) => User.fromMap(doc.data(), doc.id ))
            .toList());
  }
  
Future<void> fetchFamilyMembers(User currUser) async {
    if (currUser.familyId == null) {
      familyMembers = [];
      notifyListeners();
      return;
    }

    notifyListeners();

    try {
      // Listen to real-time updates
      FirebaseFirestore.instance
          .collection('users')
          .where('familyId', isEqualTo: currUser.familyId)
          .snapshots()
          .listen((snapshot) {
        familyMembers = snapshot.docs
            .map((doc) => User.fromMap(doc.data(), doc.id))
            .toList();
        notifyListeners();
      }, onError: (error) {
        notifyListeners();
      });
    } catch (e) {
      notifyListeners();
    }
  }

  ImageProvider<Object> getProfileOfCurrUser() {
    if (_currentUser == null) {
      return AssetImage('lib/assets/f.jpeg');
    }
    String p = _currentUser!.profilepath;
    return p.startsWith('lib/assets/') ? AssetImage(p) : FileImage(File(p));
  }
}
