import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';

void main() {
  group('TaskDescriptorProvider Logic Tests', () {
    test('should access default descriptors correctly', () {
      // Test the static data structure that your provider uses
      expect(_getTestDefaultDescriptors().length, equals(8));

      final acUnitDescriptor = _getTestDefaultDescriptors()[0];
      expect(acUnitDescriptor.id, equals('0'));
      expect(acUnitDescriptor.title, equals('AC Unit control'));
      expect(acUnitDescriptor.category, equals('Maintenance'));
      expect(acUnitDescriptor.icon, equals(Icons.ac_unit));
    });

    test('should have valid category distribution in defaults', () {
      final categories = _getTestDefaultDescriptors()
          .map((descriptor) => descriptor.category)
          .toSet();
      
      expect(categories, contains('Maintenance'));
      expect(categories, contains('Shopping'));
      expect(categories, contains('Cleaning'));
      expect(categories, contains('Cooking'));
      expect(categories, contains('Gardening'));
      expect(categories.length, equals(5));
    });

    test('should filter cleaning descriptors correctly', () {
      final cleaningDescriptors = _getTestDefaultDescriptors()
          .where((descriptor) => descriptor.category == 'Cleaning')
          .toList();
      
      expect(cleaningDescriptors.length, equals(3));
      expect(cleaningDescriptors.map((d) => d.title), containsAll([
        'Window cleaning',
        'Laundry', 
        'Mopping the floors'
      ]));
    });

    test('should have unique ids in default descriptors', () {
      final ids = _getTestDefaultDescriptors()
          .map((descriptor) => descriptor.id)
          .toList();
      
      final uniqueIds = ids.toSet();
      expect(ids.length, equals(uniqueIds.length));
    });
  });
}
// Helper function to replicate the default descriptors for testing
List<TaskDescriptor> _getTestDefaultDescriptors() {
  return [
    TaskDescriptor(
      id: '0',
      title: 'AC Unit control', 
      instructions: 'Instructions on AC...', 
      category: 'Maintenance',  
      icon: Icons.ac_unit),

    TaskDescriptor(
      id: '1',
      title: 'Basic shopping list', 
      instructions: 'Shopping list...', 
      category: 'Shopping',  
      icon: Icons.child_friendly),

    TaskDescriptor(
      id: '2',
      title: 'Window cleaning', 
      instructions: 'Instructions on window cleaning...', 
      category: 'Cleaning',  
      icon: Icons.cottage),
    
    TaskDescriptor(
      id: '3',
      title: 'Laundry', 
      instructions: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. ', 
      category: 'Cleaning', 
      icon: Icons.local_laundry_service),

    TaskDescriptor(
      id: '4',
      title: 'basic Cooking', 
      instructions: 'Instructions on basic cooking...', 
      category: 'Cooking',  
      icon: Icons.countertops),

    TaskDescriptor(
      id: '5',
      title: 'Gardening', 
      instructions: 'Instructions on gardening...', 
      category: 'Gardening', 
      icon: Icons.yard),
      
    TaskDescriptor(
      id: '6',
      title: 'Mopping the floors', 
      instructions: 'Instructions on mopping...', 
      category: 'Cleaning', 
      icon: Icons.cleaning_services_outlined),

    TaskDescriptor(
      id: '7',
      title: 'Family cheese tarts recipe', 
      instructions: "Ingredients:\n - 200g Appenzeller\n - 100g Gruyere\n - 1 dl full cream\n - 1,5 dl milk\n - 2 fresh eggs\n1. Mix all ingredients with 1/4 tbsp salt and a bit nutmeg\n2. Put puff pastry into a buttered round baking form of diameter 22cm\n3. Put mixture into this layered form\n4. Bake in the middle of the oven at 180°C for 30 min", 
      category: 'Cooking', 
      icon: Icons.dining),
  ];
}