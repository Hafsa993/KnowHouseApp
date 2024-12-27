
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

  User({
    required this.uid,
    required this.username,
    this.points = 0,
    this.role = 'Member', 
    this.preferences = const [], 
    this.contributions = const {},
    this.profilepath = 'lib/assets/f.jpeg',
    this.familyId,
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
    };
  }
//needs to be saved to firestore , maybe include uid in user obj always
  Future<void> addPoints (int pointsToAdd) async {
     points += pointsToAdd;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'rankingPoints': points,
    });
  }

  Future<void> updateRole(String newRole) async {
     await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'role': newRole,
    });
  }

  Future<void> setPreferences(List<String> newPreferences) async {
     await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'preferences': newPreferences,
    });
  }

  Future<void> updateContributions(Map<String, int> newContributions) async {
     await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'contributions': newContributions,
    });
  }
}
