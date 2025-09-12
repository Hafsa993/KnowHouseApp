import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/user_model.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:household_knwoledge_app/screens/todo_show.dart';
import 'package:household_knwoledge_app/widgets/todo_creator_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/menu_drawer.dart';

class ToDoListScreen extends StatelessWidget {
  const ToDoListScreen({super.key});

    void _showAcceptDialog(BuildContext context, Task task, TaskProvider taskProvider, String name) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
             actionsAlignment: MainAxisAlignment.center,title: const Text("Are you sure you want to take over this ToDo?"),
            content: const Text("This is a non-reversible action."),
            actions: [
              TextButton(
                onPressed: () {
                  taskProvider.takeOverTask(task.id, name);
                 
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                  content: Text('accepted ToDo has been moved to My ToDos'),
                                  backgroundColor: const Color.fromARGB(255, 3, 125, 3),
                                  
                                ));
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 6, 201, 64)),
                child: const Text('Yes, really take over'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red),
                child: const Text("No, don't"),
              ),
            ],
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
      final userProvider = Provider.of<UserProvider>(context);
    
    User currentUser = userProvider.currentUser!;
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);


    return StreamBuilder<List<Task>>(
      stream: taskProvider.getAllTasks(currentUser.familyId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
              // While the stream is loading, show a loading indicator
              return Center(child: CircularProgressIndicator());

            } else if (snapshot.hasError) {
              // If there's an error, display it
              return Center(child: Text('Error: ${snapshot.error}'));

            } 
              //process data once available
              List<Task> toDoList = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 226, 224, 224),
            title: const Text('House ToDos'),
          ),
          drawer: const MenuDrawer(),
          body: ListView.builder(
            itemCount: toDoList.length,
            itemBuilder: (context, index) {
              Task task = toDoList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoShowScreen(task: task),
                      ),
                    );
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Title
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Task Details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due: ${DateFormat('dd-MM-yyyy HH:mm').format(task.deadline)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: task.deadline.difference(DateTime.now()).inHours < 24
                                                  ? Colors.red // Red if due in less than 24 hours
                                                  : Colors.black54
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Difficulty: ${task.difficulty}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Reward: ${task.rewardPoints}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                          // Buttons Section
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: task.isAccepted ? Colors.grey : task.assignedTo == currentUser.username? 
                                        const Color.fromARGB(255, 235, 75, 63) : (task.assignedTo == "" ? Color.fromARGB(255, 244, 146, 54) :  Colors.teal),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      minimumSize: const Size(70, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => task.isAccepted || task.assignedTo == currentUser.username ? null :  _showAcceptDialog(context, task, taskProvider, currentUser.username) ,
                                    child: task.isAccepted ? Text('ToDo is taken') : (( task.assignedTo == currentUser.username ? 
                                      Text('ToDo is assigned to you') : (task.assignedTo == "" ? 
                                      Text('Take on unassigned ToDo') : Text('Take over from ${task.assignedTo}')))),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
          bottomNavigationBar:  ToDoCreator(),
        );
      }
    );
  }
}