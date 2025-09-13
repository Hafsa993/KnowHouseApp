// test/models/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:household_knwoledge_app/models/user_model.dart';

void main() {
  group('User Model Tests', () {
    late User testUser;

    setUp(() {
      testUser = User(
        uid: 'test-uid-123',
        username: 'TestUser',
        familyId: 'family-123',
        role: 'Member',
        points: 100,
        contributions: {'Cooking': 50, 'Cleaning': 30},
        preferences: ['Cooking', 'Shopping'],
        profilepath: 'lib/assets/f.jpeg',
        notificationsEnabled: true,
        cameraPermissionEnabled: true,
        galleryPermissionEnabled: true,
        geolocationPermissionEnabled: false,
      );
    });

    test('should create user with correct properties', () {
      expect(testUser.uid, equals('test-uid-123'));
      expect(testUser.username, equals('TestUser'));
      expect(testUser.familyId, equals('family-123'));
      expect(testUser.points, equals(100));
      expect(testUser.role, equals('Member'));
      expect(testUser.profilepath, equals('lib/assets/f.jpeg'));
    });

    test('should add points correctly', () async {
      
      final initialPoints = testUser.points;
      
      // Test the local logic (you'd mock Firebase for real tests)
      testUser.points += 25; // Simulate the addPoints logic
      
      expect(testUser.points, equals(initialPoints + 25));
      expect(testUser.points, equals(125));
    });

    test('should update contributions correctly', () {
      final newContributions = {'Cooking': 75, 'Cleaning': 30, 'Shopping': 20};
      
      // Test the local logic
      testUser.contributions = newContributions;
      
      expect(testUser.contributions['Cooking'], equals(75));
      expect(testUser.contributions['Shopping'], equals(20));
      expect(testUser.contributions.keys.length, equals(3));
    });

    test('should convert to map correctly', () {
      final userMap = testUser.toMap();
      
      expect(userMap['username'], equals('TestUser'));
      expect(userMap['rankingPoints'], equals(100));
      expect(userMap['familyId'], equals('family-123'));
      expect(userMap['role'], equals('Member'));
      expect(userMap['profilepath'], equals('lib/assets/f.jpeg'));
      expect(userMap['contributions'], isA<Map<String, int>>());
      expect(userMap['preferences'], isA<List<String>>());
      expect(userMap['notificationsEnabled'], isTrue);
      expect(userMap['cameraPermissionEnabled'], isTrue);
      expect(userMap['galleryPermissionEnabled'], isTrue);
      expect(userMap['geolocationPermissionEnabled'], isFalse);
    });

    test('should create user from map correctly', () {
      final userMap = {
        'username': 'NewUser',
        'rankingPoints': 200,
        'role': 'Admin',
        'familyId': 'family-456',
        'contributions': {'Gardening': 100},
        'preferences': ['Gardening'],
        'profilepath': 'custom/path.jpg',
        'notificationsEnabled': false,
        'cameraPermissionEnabled': true,
        'galleryPermissionEnabled': false,
        'geolocationPermissionEnabled': true,
      };

      final user = User.fromMap(userMap, 'test-uid-456');
      
      expect(user.uid, equals('test-uid-456'));
      expect(user.username, equals('NewUser'));
      expect(user.role, equals('Admin'));
      expect(user.points, equals(200));
      expect(user.contributions['Gardening'], equals(100));
      expect(user.preferences.first, equals('Gardening'));
      expect(user.profilepath, equals('custom/path.jpg'));
      expect(user.notificationsEnabled, isFalse);
      expect(user.cameraPermissionEnabled, isTrue);
      expect(user.galleryPermissionEnabled, isFalse);
      expect(user.geolocationPermissionEnabled, isTrue);
    });

    test('should handle empty contributions map', () {
      final userWithEmptyContributions = User(
        uid: 'test-uid',
        username: 'TestUser',
        role: 'Member',
        familyId: 'family-123',
        points: 0,
        contributions: {},
        preferences: [],
        profilepath: 'lib/assets/f.jpeg',
        notificationsEnabled: true,
        cameraPermissionEnabled: true,
        galleryPermissionEnabled: true,
        geolocationPermissionEnabled: true,
      );

      expect(userWithEmptyContributions.contributions.isEmpty, isTrue);
      
      // Test local point addition logic
      userWithEmptyContributions.points += 10;
      expect(userWithEmptyContributions.points, equals(10));
    });

    test('should handle default values correctly', () {
      final minimalUser = User(
        uid: 'minimal-uid',
        username: 'MinimalUser',
      );

      expect(minimalUser.uid, equals('minimal-uid'));
      expect(minimalUser.username, equals('MinimalUser'));
      expect(minimalUser.points, equals(0)); 
      expect(minimalUser.role, equals('Member')); 
      expect(minimalUser.preferences, isEmpty); 
      expect(minimalUser.contributions, isEmpty);
      expect(minimalUser.profilepath, equals('lib/assets/f.jpeg')); 
      expect(minimalUser.familyId, isNull);
      expect(minimalUser.cameraPermissionEnabled, isFalse); 
      expect(minimalUser.galleryPermissionEnabled, isFalse); 
      expect(minimalUser.geolocationPermissionEnabled, isFalse); 
      expect(minimalUser.notificationsEnabled, isFalse); 
    });

    test('should handle permission toggles locally', () {
      // Test the permission toggle logic (without Firebase)
      expect(testUser.notificationsEnabled, isTrue);
      
      // Simulate toggle logic
      testUser.notificationsEnabled = !testUser.notificationsEnabled;
      expect(testUser.notificationsEnabled, isFalse);
      
      // Test camera permission
      expect(testUser.cameraPermissionEnabled, isTrue);
      testUser.cameraPermissionEnabled = !testUser.cameraPermissionEnabled;
      expect(testUser.cameraPermissionEnabled, isFalse);
    });

    test('should validate role assignment', () {
      expect(testUser.role, equals('Member'));
      
      // Test role update logic
      testUser.role = 'Admin';
      expect(testUser.role, equals('Admin'));
      
      testUser.role = 'Member';
      expect(testUser.role, equals('Member'));
    });

    test('should handle preferences correctly', () {
      expect(testUser.preferences, contains('Cooking'));
      expect(testUser.preferences, contains('Shopping'));
      expect(testUser.preferences.length, equals(2));
      
      // Test preference updates
      final newPreferences = ['Gardening', 'Maintenance', 'Planning'];
      testUser.preferences = newPreferences;
      
      expect(testUser.preferences.length, equals(3));
      expect(testUser.preferences, contains('Gardening'));
      expect(testUser.preferences, contains('Maintenance'));
      expect(testUser.preferences, contains('Planning'));
    });
    test('should validate contribution totals', () {
      final totalContributions = testUser.contributions.values
          .fold<int>(0, (sum, value) => sum + value);
      expect(totalContributions, equals(80)); // 50 + 30
    });
    test('should handle contributions updates', () {
      expect(testUser.contributions['Cooking'], equals(50));
      expect(testUser.contributions['Cleaning'], equals(30));
      
      // Test adding new contribution
      testUser.contributions['Shopping'] = 25;
      expect(testUser.contributions['Shopping'], equals(25));
      expect(testUser.contributions.keys.length, equals(3));
      
      // Test updating existing contribution
      testUser.contributions['Cooking'] = 75;
      expect(testUser.contributions['Cooking'], equals(75));
    });

    test('should handle profile path updates', () {
      expect(testUser.profilepath, equals('lib/assets/f.jpeg'));
      
      testUser.profilepath = 'custom/profile/image.jpg';
      expect(testUser.profilepath, equals('custom/profile/image.jpg'));
    });
  });
}