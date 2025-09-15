import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TaskDescriptorProvider with ChangeNotifier{
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Default templates for initializing a new family (possibly add this functionality in the future)
  static final List<TaskDescriptor> _defaultDescriptors = [
    
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


  // Initialize family with default templates (possibly add this functionality in the future)
  Future<void> initializeFamilyWithDefaults(String familyId) async {
    try {
      final existing = await _firestore
          .collection('taskDescriptors')
          .where('familyId', isEqualTo: familyId)
          .limit(1)
          .get();

      if (existing.docs.isEmpty) {
        final batch = _firestore.batch();
        
        for (final descriptor in _defaultDescriptors) {
          final docRef = _firestore.collection('taskDescriptors').doc();
          final data = descriptor.toMap();
          data['familyId'] = familyId;
          data['createdBy'] = _auth.currentUser?.uid;
          data['createdAt'] = FieldValue.serverTimestamp();
          data['isTemplate'] = true;
          
          batch.set(docRef, data);
        }

        await batch.commit();
      }
    } catch (e) {
      debugPrint('Error initializing default task descriptors: $e');
    }
  }
  // Stream to fetch all task descriptors for a family
  Stream<List<TaskDescriptor>> getAllTaskDescriptors(String familyId) {
  return _firestore
        .collection('taskDescriptors')
        .where('familyId', isEqualTo: familyId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskDescriptor.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream to fetch task descriptors by category
  Stream<List<TaskDescriptor>> getTaskDescriptorsByCategory(String familyId, String category) {
    return _firestore
        .collection('taskDescriptors')
        .where('familyId', isEqualTo: familyId)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskDescriptor.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Method to add a new task descriptor
  Future<void> addTaskDescriptor(TaskDescriptor descriptor, String familyId) async {
    try {

      final data = descriptor.toMap();
      data['familyId'] = familyId;
      data['createdBy'] = _auth.currentUser?.uid;
      data['createdAt'] = FieldValue.serverTimestamp();
      data['isTemplate'] = false; // User-created content

    final docRef = await _firestore.collection('taskDescriptors').add(data);
    descriptor.id = docRef.id;

    } catch (e) {
      debugPrint('Error adding task descriptor: $e');
  }
}

  // Method to edit a task descriptor
  Future<void> editTaskDescriptor(
    String descriptorId, 
    String newTitle, 
    String newInstructions, 
    String newCategory, 
    IconData newIcon
  ) async {
    await _firestore.collection('taskDescriptors').doc(descriptorId).update({
      'title': newTitle,
      'instructions': newInstructions,
      'category': newCategory,
      'icon': newIcon.codePoint,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': _auth.currentUser?.uid,
    });
  }

  // Method to remove a task descriptor
  Future<void> removeTaskDescriptor(String descriptorId) async {
    await _firestore.collection('taskDescriptors').doc(descriptorId).delete();
  }

  // Get count of descriptors for a family
  Future<int> getLength(String familyId) async {
    final snapshot = await _firestore
        .collection('taskDescriptors')
        .where('familyId', isEqualTo: familyId)
        .get();
    return snapshot.docs.length;
  }

} 