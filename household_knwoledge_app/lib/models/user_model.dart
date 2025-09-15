
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String username;
  int points;
  String role; 
  List<String> preferences; 
  Map<String, int> contributions; 
  String profilepath;
  String? familyId; // link to family
  bool cameraPermissionEnabled;
  bool galleryPermissionEnabled;
  bool geolocationPermissionEnabled;
  bool notificationsEnabled;
 

  User({
    required this.uid,
    required this.username,
    this.points = 0,
    this.role = 'Member', 
    this.preferences = const [], 
    this.contributions = const {},
    this.profilepath = 'lib/assets/f.jpeg',
    this.familyId,
    this.cameraPermissionEnabled = false,
    this.galleryPermissionEnabled = false,
    this.geolocationPermissionEnabled = false,
    this.notificationsEnabled = false
  });

  // to create a User from Firestore data
  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    return User(
      uid: documentId,
      username: data['username'] ?? '',
      points: data['rankingPoints'] ?? 0,
      role: data['role'] ?? 'Member',
      preferences: List<String>.from(data['preferences'] ?? []),
      contributions: Map<String, int>.from(data['contributions'] ?? {}),
      profilepath: data['profilepath'] ?? 'lib/assets/f.jpeg',
      familyId: data['familyId'], // Link to family
      cameraPermissionEnabled: data['cameraPermissionEnabled'] ?? false,
      galleryPermissionEnabled: data['galleryPermissionEnabled'] ?? false,
      geolocationPermissionEnabled: data['geolocationPermissionEnabled'] ?? false,
      notificationsEnabled: data['notificationsEnabled'] ?? false
    );
  }

  // Method to convert User to a map for Firestore,so we can use firebase with our model
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'rankingPoints': points, 
      'role': role,
      'preferences': preferences,
      'contributions': contributions,
      'profilepath': profilepath,
      'familyId': familyId,
      'cameraPermissionEnabled' : cameraPermissionEnabled,
      'galleryPermissionEnabled' : galleryPermissionEnabled,
      'geolocationPermissionEnabled' : geolocationPermissionEnabled,
      'notificationsEnabled' : notificationsEnabled
    };
  }

//functions for permissions

  // Toggles camera permission for the user
  Future<void> toggleCameraPermissionForUser() async {
    cameraPermissionEnabled = !cameraPermissionEnabled;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'cameraPermissionEnabled': cameraPermissionEnabled,
    });
  }

  // Toggles gallery permission for the user
  Future<void> toggleGalleryPermissionForUser() async{
    galleryPermissionEnabled = !galleryPermissionEnabled;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'galleryPermissionEnabled': galleryPermissionEnabled,
    });
  }

  // Toggles geolocation permission for the user
  Future<void> toggleGeolocationPermissionForUser() async{
    geolocationPermissionEnabled = !geolocationPermissionEnabled;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'geolocationPermissionEnabled': geolocationPermissionEnabled,
    });
  }

  // Toggles notifications permission for the user
  Future<void> toggleNotificationsEnabledForUser() async{
    notificationsEnabled = !notificationsEnabled;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'notificationsEnabled': notificationsEnabled,
    });
  }  

//functions to change fields in a User locally and on firebase as well

  //adds points to a user
  Future<void> addPoints (int pointsToAdd) async {
    points += pointsToAdd;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'rankingPoints': points,
    });
  }

  //updates role of a user
  Future<void> updateRole(String newRole) async {
    role = newRole;
     await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'role': newRole,
    });
  }

  //updates profile pic of a user
  Future<void> updateProfilePic(String newPicPath) async {
    profilepath = newPicPath;
     await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'profilepath': newPicPath,
    });
  }

  //sets user preferences or updates them
  Future<void> setPreferences(List<String> newPreferences) async {
    preferences = newPreferences;
     await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'preferences': newPreferences,
    });
  }

  //updates the contributions of a user
  Future<void> updateContributions(Map<String, int> newContributions) async {
    contributions = newContributions;
     await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'contributions': newContributions,
    });
  }
}
