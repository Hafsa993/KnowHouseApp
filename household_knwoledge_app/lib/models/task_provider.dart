// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:household_knwoledge_app/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Task>> getAllTasks() {
    return _firestore
        .collection('tasks')
        .orderBy('deadline') // Optional: Order tasks by deadline
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream to fetch pending tasks assigned to a user
  Stream<List<Task>> pendingTasks(String username) {
    return _firestore
        .collection('tasks')
        .where('assignedTo', isEqualTo: username)
        .where('isAccepted', isEqualTo: false)
        .where('isDeclined', isEqualTo: false)
        .orderBy('deadline')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream to fetch active tasks accepted by a user
  Stream<List<Task>> myTasks(String username) {
    return _firestore
        .collection('tasks')
        .where('acceptedBy', isEqualTo: username)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream to fetch completed tasks accepted by a user
  Stream<List<Task>> myCompletedTasks(String username) {
    return _firestore
        .collection('tasks')
        .where('acceptedBy', isEqualTo: username)
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Method to accept a task
  Future<void> acceptTask(String taskId, String username) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isAccepted': true,
      'acceptedBy': username,
    });
    notifyListeners();
  }

  // Method to take over a task
  Future<void> takeOverTask(String taskId, String username) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isAccepted': true,
      'acceptedBy': username,
      'assignedTo': username,
    });
    notifyListeners();
  }

  // Method to decline a task
  Future<void> declineTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isDeclined': true,
    });
    notifyListeners();
  }

  // Method to complete a task
  Future<void> completeTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isCompleted': true,
    });
    notifyListeners();
  }

  // Method to add a new task
  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').add(task.toMap());
    notifyListeners();
  }

  // Optionally, method to remove a task
  Future<void> removeTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
    notifyListeners();
  }

  // Additional methods as needed...
}
