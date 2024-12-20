class User {
  String username;
  int points;
  String role; // e.g., 'child', 'parent'
  List<String> preferences; 
  Map<String, int> contributions; 
  String profilepath;

  User({
    required this.username,
    this.points = 0,
    this.role = 'Member', 
    this.preferences = const [], 
    this.contributions = const {},
    this.profilepath = 'lib/assets/f.jpeg',
  });

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

// Create user instances outside the class


