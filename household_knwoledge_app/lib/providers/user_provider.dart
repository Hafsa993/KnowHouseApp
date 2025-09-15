
import 'dart:io';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  
  List<User> familyMembers = [];

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
 
  Future<void> loadCurrentUser() async {
    
   
     // Not signed in then..
     if (auth.FirebaseAuth.instance.currentUser == null) {
       return;
    }
  
    // Fetch user's document from Firestore
    try {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(auth.FirebaseAuth.instance.currentUser!.uid).get();
    
    if (userDoc.exists) {
      _currentUser = User.fromMap(userDoc.data()!, userDoc.id);
    } else {
      // User document does not exist; handle accordingly
      _currentUser = null;
    }
    
    } catch (e) {
      debugPrint('Error loading current user: $e');
      return;
    }
  }

  Future<void> addPointsToUser(int pointsToAdd) async {
    if (_currentUser == null) return;
    await _currentUser!.addPoints(pointsToAdd);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .update({'rankingPoints': _currentUser!.points});
    } catch (e) {
      debugPrint('Error updating user points: $e');
    }

  }

  //sets user preferences or updates them
  Future<void> setPreferencesForUser(List<String> newPreferences) async {
    if (_currentUser == null) return;
    try {
      await _currentUser!.setPreferences(newPreferences);
    } catch (e) {
      debugPrint('Error setting user preferences: $e');
    }
    notifyListeners();
  }
  //updates user contributions or adds new ones
  Future<void> updateContributionsForUser(Map<String, int> newContributions) async {
    if (_currentUser == null) return;
    try {
      await _currentUser!.updateContributions(newContributions);
    } catch (e) {
      debugPrint('Error updating user contributions: $e');
    }
  }
  // Upload and process profile picture
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
      
      debugPrint('Image processed. Size: ${compressedBytes.length} bytes');
      
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
      debugPrint('Error uploading profile picture: $e');
      return null;
    }
  }
  // Get profile picture as ImageProvider
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
        debugPrint('Error decoding base64 image: $e');
        return AssetImage('lib/assets/f.jpeg');
      }
    } else if (profilePath.startsWith('http')) {
      return NetworkImage(profilePath); // Firebase URL
    } else {
      return AssetImage('lib/assets/f.jpeg'); // Default picture
    }
  }
  
  Future<void> toggleCameraPermission() async {
    if (_currentUser == null) return;
    try {
      await _currentUser!.toggleCameraPermissionForUser();
    } catch (e) {
      debugPrint('Error toggling camera permission: $e');
    }
    notifyListeners();
  }

  Future<void> toggleGalleryPermission() async {
    if (_currentUser == null) return;
    try {
      await _currentUser!.toggleGalleryPermissionForUser();
    } catch (e) {
      debugPrint('Error toggling gallery permission: $e');
    }
    notifyListeners();
  }
  Future<void> toggleGeolocationPermission() async {
    if (_currentUser == null) return;
    try {
      await _currentUser!.toggleGeolocationPermissionForUser();
    } catch (e) {
      debugPrint('Error toggling geolocation permission: $e');
    }
    notifyListeners();
  }
  Future<void> toggleNotificationsEnabled() async {
    if (_currentUser == null) return;
    try {
      await _currentUser!.toggleNotificationsEnabledForUser();
    } catch (e) {
      debugPrint('Error toggling notifications enabled: $e');
    }
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
  
}
