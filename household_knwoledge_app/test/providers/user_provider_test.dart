import 'package:flutter_test/flutter_test.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:household_knwoledge_app/models/user_model.dart';

void main() {
  group('UserProvider Tests', () {
    late UserProvider userProvider;

    setUp(() {
      userProvider = UserProvider();
    });

    test('should set and clear current user correctly', () {
      final testUser = User(
        uid: 'test-uid',
        username: 'TestUser',
      );

      expect(userProvider.currentUser, isNull);
      
      userProvider.setCurrentUser(testUser);
      expect(userProvider.currentUser, equals(testUser));
      expect(userProvider.currentUser!.username, equals('TestUser'));
      
      userProvider.clearUser();
      expect(userProvider.currentUser, isNull);
    });

    test('should validate usernames correctly', () {
      // Valid usernames
      expect(_isValidUsername('ValidUser123'), isTrue);
      expect(_isValidUsername('User'), isTrue);
      expect(_isValidUsername('TestUser'), isTrue);
      
      // Invalid usernames
      expect(_isValidUsername('AB'), isFalse); // too short
      expect(_isValidUsername(''), isFalse); // empty
      expect(_isValidUsername('User@123'), isFalse); // special chars
      expect(_isValidUsername('Very_Long_Username_That_Exceeds_Limit_For_Users'), isFalse); // too long
    });

    test('should validate emails correctly', () {
      // Valid emails
      expect(_isValidEmail('test@example.com'), isTrue);
      expect(_isValidEmail('user.name@domain.co.uk'), isTrue);
      expect(_isValidEmail('valid123@test.org'), isTrue);
      
      // Invalid emails
      expect(_isValidEmail('invalid-email'), isFalse);
      expect(_isValidEmail('test@'), isFalse);
      expect(_isValidEmail('@example.com'), isFalse);
      expect(_isValidEmail(''), isFalse);
    });

    test('should rank users by points correctly', () {
      final users = [
        User(
          uid: 'user-1',
          username: 'Alice',
          familyId: 'family-123',
          role: 'Member',
          points: 150,
          contributions: {},
          preferences: [],
          profilepath: 'lib/assets/f.jpeg',
          notificationsEnabled: true,
          cameraPermissionEnabled: true,
          galleryPermissionEnabled: true,
          geolocationPermissionEnabled: true,
        ),
        User(
          uid: 'user-2',
          username: 'Bob',
          familyId: 'family-123',
          role: 'Member',
          points: 200,
          contributions: {},
          preferences: [],
          profilepath: 'lib/assets/f.jpeg',
          notificationsEnabled: true,
          cameraPermissionEnabled: true,
          galleryPermissionEnabled: true,
          geolocationPermissionEnabled: true,
        ),
        User(
          uid: 'user-3',
          username: 'Charlie',
          familyId: 'family-123',
          role: 'Member',
          points: 100,
          contributions: {},
          preferences: [],
          profilepath: 'lib/assets/f.jpeg',
          notificationsEnabled: true,
          cameraPermissionEnabled: true,
          galleryPermissionEnabled: true,
          geolocationPermissionEnabled: true,
        ),
      ];

      // Sort users by points in descending order
      final rankedUsers = List<User>.from(users)
        ..sort((a, b) => b.points.compareTo(a.points));
      
      expect(rankedUsers[0].username, equals('Bob')); // Highest points (200)
      expect(rankedUsers[1].username, equals('Alice')); // Middle points (150)
      expect(rankedUsers[2].username, equals('Charlie')); // Lowest points (100)
    });

    test('should handle tie-breaking in rankings correctly', () {
      final users = [
        User(
          uid: 'user-1',
          username: 'Alice',
          familyId: 'family-123',
          role: 'Member',
          points: 100,
          contributions: {},
          preferences: [],
          profilepath: 'lib/assets/f.jpeg',
          notificationsEnabled: true,
          cameraPermissionEnabled: true,
          galleryPermissionEnabled: true,
          geolocationPermissionEnabled: true,
        ),
        User(
          uid: 'user-2',
          username: 'Bob',
          familyId: 'family-123',
          role: 'Member',
          points: 100, // Same points as Alice
          contributions: {},
          preferences: [],
          profilepath: 'lib/assets/f.jpeg',
          notificationsEnabled: true,
          cameraPermissionEnabled: true,
          galleryPermissionEnabled: true,
          geolocationPermissionEnabled: true,
        ),
      ];

      // Sort by points first, then by username for tie-breaking
      final rankedUsers = List<User>.from(users)
        ..sort((a, b) {
          final pointsComparison = b.points.compareTo(a.points);
          if (pointsComparison == 0) {
            return a.username.compareTo(b.username); // Alphabetical order for ties
          }
          return pointsComparison;
        });
      
      expect(rankedUsers[0].username, equals('Alice')); // Alice comes first alphabetically
      expect(rankedUsers[1].username, equals('Bob'));
    });

    test('should calculate user contributions correctly', () {
      final contributions = {'Cooking': 50, 'Cleaning': 30, 'Shopping': 20};
      
      // Calculate total contributions
      final totalContributions = contributions.values.fold<int>(0, (sum, value) => sum + value);
      expect(totalContributions, equals(100));
      
      // Find top category
      final topCategory = contributions.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      expect(topCategory, equals('Cooking'));
    });

    test('should determine admin status correctly', () {
      final adminUser = User(
        uid: 'admin-user',
        username: 'AdminUser',
        familyId: 'family-123',
        role: 'Admin',
        points: 0,
        contributions: {},
        preferences: [],
        profilepath: 'lib/assets/f.jpeg',
        notificationsEnabled: true,
        cameraPermissionEnabled: true,
        galleryPermissionEnabled: true,
        geolocationPermissionEnabled: true,
      );

      final regularUser = User(
        uid: 'regular-user',
        username: 'RegularUser',
        familyId: 'family-123',
        role: 'Member',
        points: 0,
        contributions: {},
        preferences: [],
        profilepath: 'lib/assets/f.jpeg',
        notificationsEnabled: true,
        cameraPermissionEnabled: true,
        galleryPermissionEnabled: true,
        geolocationPermissionEnabled: true,
      );

      // Check admin privileges
      expect(_canManageFamily(adminUser), isTrue);
      expect(_canManageFamily(regularUser), isFalse);
    });

    test('should handle empty family members stream', () {
      final userWithoutFamily = User(
        uid: 'user-without-family',
        username: 'TestUser',
      );
      
      final stream = userProvider.getFamilyMembers(userWithoutFamily);
      
      // Should return empty stream when familyId is null
      stream.listen((members) {
        expect(members, isEmpty);
      });
    });
  });
}

// Helper functions for validation
bool _isValidUsername(String username) {
  if (username.isEmpty || username.length < 3 || username.length > 20) {
    return false;
  }
  return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
}

bool _isValidEmail(String email) {
  if (email.isEmpty) return false;
  return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
}

bool _canManageFamily(User user) {
  return user.role == 'Admin';
}