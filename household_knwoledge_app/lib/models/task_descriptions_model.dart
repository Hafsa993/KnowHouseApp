
import 'package:flutter/material.dart';

//IMPORTANT: 
//TODO: integrate TaskDescriptor into firebase like Tasks 

class TaskDescriptor {
  String? id; //firestore doc Id
  String title;
  String instructions;
  String category;
  IconData icon;
  String? familyId;

  TaskDescriptor({
    required this.id,
    required this.title,
    this.instructions = '',
    this.category = '',
    this.icon = Icons.favorite,
    this.familyId
  });

    // constructor to create TaskDescriptor from Firestore data
  factory TaskDescriptor.fromMap(Map<String, dynamic> data, String documentId) {
    return TaskDescriptor(
      id: documentId,
      title: data['title'] ?? '',
      instructions: data['instructions'] ?? '',
      category: data['category'] ?? '',
      icon: IconData(
        data['icon'] ?? Icons.favorite.codePoint, 
        fontFamily: 'MaterialIcons'
      ),
      familyId: data['familyId'],
    );
  }

  // Method to convert TaskDescriptor to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'instructions': instructions,
      'category': category,
      'icon': icon.codePoint, // Store icon as codePoint integer
      'familyId': familyId,
    };
  }
}
   
Color categoryColor(String category){
  switch(category){
    case 'Cooking': return Colors.red;
    case 'Gardening': return Colors.green;
    case 'Shopping': return Colors.amber[600]!;
    case 'Planning': return const Color.fromARGB(255, 145, 74, 189);
    case 'Care': return const Color.fromARGB(255, 255, 93, 212);
    case 'Maintenance': return const Color.fromARGB(255, 100, 155, 159);
    case 'Other': return const Color.fromARGB(255, 155, 144, 173);
  }
  //default Cleaning
  return Colors.blue;

}
final categories = <String>[
  "Cooking",
  "Cleaning",
  "Gardening",
  "Shopping",
  "Planning",
  "Care",
  "Maintenance",
  "Other"
];
final selectableCategories = <String>[
  "Cooking",
  "Cleaning",
  "Gardening",
  "Shopping",
  "Planning",
  "Care",
  "Maintenance",
  "Other",
  "All Categories"
];