// test/models/task_descriptor_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';

void main() {
  group('TaskDescriptor Model Tests', () {
    late TaskDescriptor testDescriptor;

    setUp(() {
      testDescriptor = TaskDescriptor(
        id: 'descriptor-123',
        title: 'Kitchen Deep Clean',
        instructions: 'Clean all surfaces, appliances, and organize cabinets',
        category: 'Cleaning',
        icon: Icons.cleaning_services,
        familyId: 'family-789',
      );
    });

    test('should create task descriptor with correct properties', () {
      expect(testDescriptor.id, equals('descriptor-123'));
      expect(testDescriptor.title, equals('Kitchen Deep Clean'));
      expect(testDescriptor.instructions, equals('Clean all surfaces, appliances, and organize cabinets'));
      expect(testDescriptor.category, equals('Cleaning'));
      expect(testDescriptor.icon, equals(Icons.cleaning_services));
      expect(testDescriptor.familyId, equals('family-789'));
    });

    test('should create task descriptor with default values', () {
      final minimalDescriptor = TaskDescriptor(
        id: 'minimal-id',
        title: 'Simple Task',
      );

      expect(minimalDescriptor.id, equals('minimal-id'));
      expect(minimalDescriptor.title, equals('Simple Task'));
      expect(minimalDescriptor.instructions, equals(''));
      expect(minimalDescriptor.category, equals(''));
      expect(minimalDescriptor.icon, equals(Icons.favorite));
      expect(minimalDescriptor.familyId, isNull);
    });

    test('should convert to map correctly', () {
      final descriptorMap = testDescriptor.toMap();

      expect(descriptorMap['title'], equals('Kitchen Deep Clean'));
      expect(descriptorMap['instructions'], equals('Clean all surfaces, appliances, and organize cabinets'));
      expect(descriptorMap['category'], equals('Cleaning'));
      expect(descriptorMap['iconName'], equals('cleaning'));
      expect(descriptorMap['familyId'], equals('family-789'));
    });

    test('should create from map correctly', () {
      final descriptorMap = {
        'title': 'Garden Maintenance',
        'instructions': 'Water plants, trim hedges, and weed garden beds',
        'category': 'Gardening',
        'iconName': 'gardening',
        'familyId': 'family-456',
      };

      final descriptor = TaskDescriptor.fromMap(descriptorMap, 'new-descriptor-id');

      expect(descriptor.id, equals('new-descriptor-id'));
      expect(descriptor.title, equals('Garden Maintenance'));
      expect(descriptor.instructions, equals('Water plants, trim hedges, and weed garden beds'));
      expect(descriptor.category, equals('Gardening'));
      expect(descriptor.icon, equals(Icons.grass));
      expect(descriptor.familyId, equals('family-456'));
    });

    test('should handle missing fields in fromMap', () {
      final incompleteMap = {
        'title': 'Incomplete Task',
      };

      final descriptor = TaskDescriptor.fromMap(incompleteMap, 'incomplete-id');

      expect(descriptor.id, equals('incomplete-id'));
      expect(descriptor.title, equals('Incomplete Task'));
      expect(descriptor.instructions, equals(''));
      expect(descriptor.category, equals(''));
      expect(descriptor.icon, equals(Icons.favorite)); // Default fallback
      expect(descriptor.familyId, isNull);
    });
  });

  group('Category Functions Tests', () {
    test('should return correct colors for categories', () {
      expect(categoryColor('Cooking'), equals(Colors.red));
      expect(categoryColor('Gardening'), equals(Colors.green));
      expect(categoryColor('Shopping'), equals(Colors.amber[600]));
      expect(categoryColor('Planning'), equals(const Color.fromARGB(255, 145, 74, 189)));
      expect(categoryColor('Care'), equals(const Color.fromARGB(255, 255, 93, 212)));
      expect(categoryColor('Maintenance'), equals(const Color.fromARGB(255, 100, 155, 159)));
      expect(categoryColor('Other'), equals(const Color.fromARGB(255, 155, 144, 173)));
    });

    test('should return default blue color for unknown category', () {
      expect(categoryColor('Unknown'), equals(Colors.blue));
      expect(categoryColor(''), equals(Colors.blue));
    });

    test('should provide complete list of categories', () {
      expect(categories.length, equals(8));
      expect(categories, contains('Cooking'));
      expect(categories, contains('Cleaning'));
      expect(categories, contains('Gardening'));
      expect(categories, contains('Shopping'));
      expect(categories, contains('Planning'));
      expect(categories, contains('Care'));
      expect(categories, contains('Maintenance'));
      expect(categories, contains('Other'));
    });

    test('should provide selectable categories with all option', () {
      expect(selectableCategories.length, equals(9));
      expect(selectableCategories, contains('All Categories'));
      
      // Should contain all regular categories plus "All Categories"
      for (String category in categories) {
        expect(selectableCategories, contains(category));
      }
    });

    test('should maintain category consistency', () {
      // All regular categories should be present in selectable categories
      for (String category in categories) {
        expect(selectableCategories, contains(category));
      }
      
      // Selectable categories should have exactly one more item (All Categories)
      expect(selectableCategories.length, equals(categories.length + 1));
    });
  });
}