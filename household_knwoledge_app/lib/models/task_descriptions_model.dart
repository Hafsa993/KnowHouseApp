import 'package:flutter/material.dart';

class TaskDescriptor {
  String? id;
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

  // Constructor to create TaskDescriptor from Firestore data
  factory TaskDescriptor.fromMap(Map<String, dynamic> data, String documentId) {
    return TaskDescriptor(
      id: documentId,
      title: data['title'] ?? '',
      instructions: data['instructions'] ?? '',
      category: data['category'] ?? '',
      icon: AppIcons.getIconFromName(data['iconName'] ?? 'favorite'),
      familyId: data['familyId'],
    );
  }

  // Method to convert TaskDescriptor to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'instructions': instructions,
      'category': category,
      'iconName': AppIcons.getIconName(icon), 
      'familyId': familyId,
    };
  }
}

/// Predefined icon mapping to avoid dynamic IconData creation
class AppIcons {
  // Map of icon names to IconData (all constant)
  static const Map<String, IconData> _iconMap = {
    'favorite': Icons.favorite,
    'home': Icons.home,
    'work': Icons.work,
    'school': Icons.school,
    'sports': Icons.sports,
    'music': Icons.music_note,
    'games': Icons.games,
    'travel': Icons.flight,
    'food': Icons.restaurant,
    'shopping': Icons.shopping_cart,
    'health': Icons.local_hospital,
    'fitness': Icons.fitness_center,
    'car': Icons.directions_car,
    'phone': Icons.phone,
    'email': Icons.email,
    'calendar': Icons.calendar_today,
    'camera': Icons.camera_alt,
    'book': Icons.book,
    'star': Icons.star,
    'heart': Icons.favorite_border,
    'thumb_up': Icons.thumb_up,
    'check': Icons.check,
    'close': Icons.close,
    'add': Icons.add,
    'delete': Icons.delete,
    'edit': Icons.edit,
    'settings': Icons.settings,
    'help': Icons.help,
    'info': Icons.info,
    'warning': Icons.warning,
    'error': Icons.error,
    'cooking': Icons.restaurant,
    'kitchen': Icons.kitchen,
    'cleaning': Icons.cleaning_services,
    'vacuum': Icons.home_work,
    'gardening': Icons.grass,
    'plant': Icons.local_florist,
    'maintenance': Icons.build,
    'repair': Icons.handyman,
    'care': Icons.favorite,
    'medical': Icons.medical_services,
    'planning': Icons.event_note,
    'calendar_plan': Icons.calendar_month,
  };

  // Get list of all available icon names
  static List<String> get availableIconNames => _iconMap.keys.toList();

  // Get list of all available icons
  static List<IconData> get availableIcons => _iconMap.values.toList();

  // Get IconData from icon name
  static IconData getIconFromName(String iconName) {
    return _iconMap[iconName] ?? Icons.favorite; // Default fallback
  }

  // Get icon name from IconData (reverse lookup)
  static String getIconName(IconData icon) {
    for (String name in _iconMap.keys) {
      if (_iconMap[name] == icon) {
        return name;
      }
    }
    return 'favorite'; // Default fallback
  }

  // Get icons by category (for easier selection in UI)
  static List<IconData> getIconsForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cooking':
        return [Icons.restaurant, Icons.kitchen, Icons.local_dining];
      case 'cleaning':
        return [Icons.cleaning_services, Icons.home_work, Icons.local_laundry_service];
      case 'gardening':
        return [Icons.grass, Icons.local_florist, Icons.yard];
      case 'shopping':
        return [Icons.shopping_cart, Icons.store, Icons.local_grocery_store];
      case 'planning':
        return [Icons.event_note, Icons.calendar_month, Icons.schedule];
      case 'care':
        return [Icons.favorite, Icons.medical_services, Icons.child_care];
      case 'maintenance':
        return [Icons.build, Icons.handyman, Icons.home_repair_service];
      default:
        return [Icons.favorite, Icons.star, Icons.check];
    }
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
  return Colors.blue; // default Cleaning
}
// List of predefined categories
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
// List of selectable categories including "All Categories" for filtering
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