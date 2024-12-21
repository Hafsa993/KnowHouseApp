
class User {
  String username;
  int points;
  String role; 
  List<String> preferences; 
  Map<String, int> contributions; 
  String profilepath;
  String? familyId; // Added to link to the family

  User({
    required this.username,
    this.points = 0,
    this.role = 'Member', 
    this.preferences = const [], 
    this.contributions = const {},
    this.profilepath = 'lib/assets/f.jpeg',
    this.familyId,
  });

  // constructor to create a User from Firestore data
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      username: data['username'] ?? '',
      points: data['rankingPoints'] ?? data['points'] ?? 0,
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

  void addPoints(int pointsToAdd) {
    points += pointsToAdd;
  }

  void updateRole(String newRole) {
    role = newRole;
  }

  void setPreferences(List<String> newPreferences) {
    preferences = newPreferences;
  }

  void updateContributions(Map<String, int> newContributions) {
    contributions = newContributions;
  }
}
