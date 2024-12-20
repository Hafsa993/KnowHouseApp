
import 'package:flutter/material.dart';

class TaskDescriptor {
  String title;
  String instructions;
  String category;
  IconData icon;

  TaskDescriptor({
    required this.title,
    this.instructions = '',
    this.category = '',
    this.icon = Icons.favorite
  });
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