// lib/providers/task_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_model.dart';

//ADD familyID to every method so that it is family specific
class TaskProvider extends ChangeNotifier {
  
  Stream<List<Task>> getAllTasks(String familyId) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('familyId', isEqualTo: familyId)
        .where('isCompleted', isEqualTo: false)
        .orderBy('deadline')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream to fetch pending tasks assigned to a user
  Stream<List<Task>> openTasks(String username, String familyId) {
    
  return FirebaseFirestore.instance
      .collection('tasks')
      .where('familyId', isEqualTo: familyId)
      .where('assignedTo', isEqualTo: username)
      .where('isAccepted', isEqualTo: false)
      .where('isCompleted', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Task.fromMap(doc.data(),doc.id))
          .toList()); // Ensure .toList() is called
}


  // Stream to fetch active tasks accepted by a user
  Stream<List<Task>> myTasks(String username, String familyId) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('familyId', isEqualTo: familyId)
        .where('acceptedBy', isEqualTo: username)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream to fetch completed tasks accepted by a user
  Stream<List<Task>> myCompletedTasks(String username, String familyId) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('familyId', isEqualTo: familyId)
        .where('acceptedBy', isEqualTo: username)
        .where('isCompleted', isEqualTo: true)
        .where('completionTime', isGreaterThanOrEqualTo:  DateTime.now().subtract(const Duration(days: 30)))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Method to accept a task
  Future<void> acceptTask(String taskId, String username) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'isAccepted': true,
      'acceptedBy': username,
    });
    notifyListeners();
  }

  // Method to take over a task
  Future<void> takeOverTask(String taskId, String username) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'isAccepted': true,
      'acceptedBy': username,
      'assignedTo': username,
    });
    notifyListeners();
  }

  // Method to decline a task
  Future<void> declineTask(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'isDeclined': true,
    });
    notifyListeners();
  }

  // Method to complete a task
  Future<void> completeTask(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'isCompleted': true,
      'completionTime' : DateTime.now(),
    });
    notifyListeners();
  }

  // Method to add a new task
  Future<void> addTask(Task task) async {
    await FirebaseFirestore.instance.collection('tasks').add(task.toMap());
    notifyListeners();
  }

  // Optionally, method to remove a task
  Future<void> removeTask(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    notifyListeners();
  }

}
