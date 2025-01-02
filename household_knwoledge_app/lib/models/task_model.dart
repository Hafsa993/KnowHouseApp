// lib/models/task_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

//IMPORTANT: 
//ADD familyID field so that users only see family intern tasks

class Task {
  String id; // Firestore document ID
  String title;
  DateTime deadline;
  DateTime? completionTime;
  String category;
  String difficulty;
  String description;
  int rewardPoints;
  bool isAccepted;
  bool isDeclined;
  bool isCompleted;
  String acceptedBy; // Username of the user who accepted the task
  String assignedTo;

  Task({
    this.id = '',
    required this.title,
    required this.deadline,
    this.completionTime,
    required this.category,
    required this.difficulty,
    this.description = '',
    this.rewardPoints = 0,
    this.isAccepted = false,
    this.isDeclined = false,
    this.isCompleted = false,
    this.acceptedBy = '',
    this.assignedTo = '',
  });

  // Factory constructor to create a Task from Firestore data
  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    return Task(
      id: documentId,
      title: data['title'] ?? '',
      deadline: (data['deadline'] as Timestamp).toDate(),
      completionTime: data['comletionTime'] == null? null : (data['comletionTime'] as Timestamp).toDate(),
      category: data['category'] ?? '',
      difficulty: data['difficulty'] ?? '',
      description: data['description'] ?? '',
      rewardPoints: data['rewardPoints'] ?? 0,
      isAccepted: data['isAccepted'] ?? false,
      isDeclined: data['isDeclined'] ?? false,
      isCompleted: data['isCompleted'] ?? false,
      acceptedBy: data['acceptedBy'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
    );
  }

  // Method to convert Task to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'deadline': deadline,
      'completionTime' : completionTime,
      'category': category,
      'difficulty': difficulty,
      'description': description,
      'rewardPoints': rewardPoints,
      'isAccepted': isAccepted,
      'isDeclined': isDeclined,
      'isCompleted': isCompleted,
      'acceptedBy': acceptedBy,
      'assignedTo': assignedTo,
    };
  }
}
