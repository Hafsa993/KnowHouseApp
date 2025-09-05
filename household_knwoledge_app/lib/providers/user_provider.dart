
import 'dart:io';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser; // Your custom User model

  User? get currentUser => _currentUser;

  
  List<User> familyMembers = [];
  //TODO: names of functions should more sense ..forUser when 
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

  Future<void> addPointsToUser(int pointsToAdd) async {
    if (_currentUser == null) return;
    await _currentUser!.addPoints(pointsToAdd);

    //also update in fireabase
    await FirebaseFirestore.instance
      .collection('users')
      .doc(_currentUser!.uid)
      .update({'rankingPoints': _currentUser!.points});
      
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

  Future<String?> uploadProfilePicture(String localImagePath) async {
    try {
      final user = auth.FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final file = File(localImagePath);
      if (!await file.exists()) return null;

      // Read and decode image
    final imageBytes = await file.readAsBytes();
    final image = img.decodeImage(imageBytes);
    
    if (image != null) {
      // Resize to 128x128
      final resized = img.copyResize(image, width: 128, height: 128);
      
      // Compress
      final compressedBytes = img.encodeJpg(resized, quality: 85);
      
      // Convert to base64
      final base64String = base64Encode(compressedBytes);
      final dataUrl = 'data:image/jpeg;base64,$base64String';
      
      print('Image processed. Size: ${compressedBytes.length} bytes');
      
      // Save to Firestore (same database you're already using!)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilepath': dataUrl});

      // Update local user
      if (_currentUser != null) {
        _currentUser!.profilepath = dataUrl;
        notifyListeners();
      }

      return dataUrl;
    }
      return null;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  ImageProvider? getProfileOfCurrUser() {
  if (_currentUser?.profilepath == null || _currentUser!.profilepath.isEmpty) {
    return AssetImage('lib/assets/f.jpeg'); // Default picture
  }

  final profilePath = _currentUser!.profilepath;
  
  if (profilePath.startsWith('data:image/jpeg;base64,')) {
    // Base64 image stored in Firestore
    try {
      final base64String = profilePath.split(',')[1];
      final bytes = base64Decode(base64String);
      return MemoryImage(bytes);
    } catch (e) {
      print('Error decoding base64 image: $e');
      return AssetImage('assets/f.jpeg');
    }
  } else if (profilePath.startsWith('http')) {
    return NetworkImage(profilePath); // Firebase URL
  } else {
    return AssetImage('lib/assets/f.jpeg'); // Default picture
  }
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
}
