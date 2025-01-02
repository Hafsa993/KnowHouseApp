import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';

class TaskDescriptorProvider with ChangeNotifier{

  List<TaskDescriptor> descriptors = [
    
    TaskDescriptor(
      title: 'AC Unit control', 
      instructions: 'Instructions on AC...', 
      category: 'Maintenance',  
      icon: Icons.ac_unit),
    
    TaskDescriptor(
      title: 'Sarahs birthday wish', 
      instructions: 'Sarahs gift...', 
      category: 'Care',  
      icon: Icons.child_friendly),

    TaskDescriptor(
      title: 'Basic shopping list', 
      instructions: 'Shopping list...', 
      category: 'Shopping',  
      icon: Icons.child_friendly),

    TaskDescriptor(
      title: 'Window cleaning', 
      instructions: 'Instructions on window cleaning...', 
      category: 'Cleaning',  
      icon: Icons.cottage),
    
    TaskDescriptor(
      title: 'Looping', 
      instructions: 'Instructions on window looping...', 
      category: 'Other',  
      icon: Icons.kebab_dining),

    TaskDescriptor(
      title: 'Piano practice', 
      instructions: 'Instructions on window looping...', 
      category: 'Care',  
      icon: Icons.headphones),

    TaskDescriptor(
      title: 'Names of relatives', 
      instructions: 'Names of relatives...', 
      category: 'Other',  
      icon: Icons.groups_2),

    TaskDescriptor(
      title: 'Writing an essay', 
      instructions: 'Instructions on writing on essay...', 
      category: 'Other',  
      icon: Icons.keyboard),
    
    TaskDescriptor(
      title: 'Laundry', 
      instructions: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. ', 
      category: 'Cleaning', 
      icon: Icons.local_laundry_service),

    TaskDescriptor(
      title: 'Cooking', 
      instructions: 'Instructions on basic cooking...', 
      category: 'Cooking',  
      icon: Icons.countertops),

    TaskDescriptor(
      title: 'Gardening', 
      instructions: 'Instructions on gardening...', 
      category: 'Gardening', 
      icon: Icons.yard),
      
    TaskDescriptor(
      title: 'Mopping the floors', 
      instructions: 'Instructions on mopping...', 
      category: 'Cleaning', 
      icon: Icons.cleaning_services_outlined),

      TaskDescriptor(
      title: 'Family cheese tarts recipe', 
      instructions: "Ingredients:\n - 200g Appenzeller\n - 100g Gruyere\n - 1 dl full cream\n - 1,5 dl milk\n - 2 fresh eggs\n1. Mix all ingredients with 1/4 tbsp salt and a bit nutmeg\n2. Put puff pastry into a buttered round baking form of diameter 22cm\n3. Put mixture into this layered form\n4. Bake in the middle of the oven at 180°C for 30 min", 
      category: 'Cooking', 
      icon: Icons.dining),
  ];

  void addTaskDescriptor (TaskDescriptor descriptor) async {
    descriptors.add(descriptor);
   // print('added a task with name: ${descriptor.title}');
   // print(descriptors.toString());
    notifyListeners();
  }
  // is this the same object?
  void removeTaskDescriptor(TaskDescriptor descriptor) {
    descriptors.remove(descriptor);
    notifyListeners();
  }

  void editTaskDescriptor(TaskDescriptor descriptor, String ntitle, String ninstructions, String ncategory, IconData nicon,) {
    //TaskDescriptor ntask = TaskDescriptor(title: ntitle, instructions: ninstructions, category: ncategory, icon: nicon);
    descriptor.title = ntitle;
    descriptor.instructions = ninstructions;
    descriptor.category = ncategory;
    descriptor.icon = nicon;
    notifyListeners();
  }

  int getLength() {
    return descriptors.length;
  }


} 