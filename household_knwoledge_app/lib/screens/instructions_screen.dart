import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:household_knwoledge_app/models/user_model.dart';
import 'package:household_knwoledge_app/providers/task_descriptions_provider.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:household_knwoledge_app/screens/add_task_description_screen.dart';
import 'package:household_knwoledge_app/screens/task_description_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/menu_drawer.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  String dropdownvalue = 'All Categories';
  String searchQuery = '';
  List<TaskDescriptor> filteredDescriptors = [];
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    User currentUser = userProvider.currentUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title: const Text('Instructions'),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          SizedBox(height: 10,),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  //filterTasks(searchQuery, dropdownvalue, allDescriptors ?? []);
                });
              },
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 66, 67, 67),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 57, 58, 57),
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          // Dropdown Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownvalue,
              items: selectableCategories.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: getCategoryColor(items),
                                radius: 5,
                              ),
                              SizedBox(width: 8),
                              Text(items),
                            ],
                          ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    dropdownvalue = newValue;
                    //filterTasks(searchQuery, newValue, allDescriptors  ?? []);
                  });
                }
              },
            ),
          ),
          // Task List
          // Replace the Expanded ListView section with:
  Expanded(
    child: StreamBuilder<List<TaskDescriptor>>(
      stream: context.read<TaskDescriptorProvider>().getAllTaskDescriptors(currentUser.familyId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        final allDescriptors = snapshot.data ?? [];
        
        // Apply filters
        List<TaskDescriptor> filtered = allDescriptors;
        if (dropdownvalue != 'All Categories') {
          filtered = filtered.where((task) => task.category == dropdownvalue).toList();
        }
        if (searchQuery.isNotEmpty) {
          filtered = filtered.where((task) {
            return task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                task.instructions.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();
        }
        
        return filtered.isEmpty
            ? Center(child: Text('No instructions found.'))
            : ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  TaskDescriptor descriptor = filtered[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.circle),
                      trailing: Icon(descriptor.icon),
                      iconColor: categoryColor(descriptor.category),
                      title: Text(descriptor.title),
                      subtitle: Text(descriptor.category, style: TextStyle(color: Colors.grey)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDescriptionScreen(task: descriptor),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
          // Add Instruction Button
      ],
    ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 21, 208, 255))),
              icon: const Icon(Icons.add, size: 20, color: Colors.white,),
                  label: Text('Add new instruction', style: TextStyle(fontSize: 20, color: Colors.white,)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskDescriptorScreen(),
                      ),
                    );
                  },
                ),
          ),]
        ),
      ),
    );
  }

}

Color getCategoryColor(String s) {
  if (s == 'All Categories') {
    return Colors.black;
  } else {
    return categoryColor(s);
  }
}