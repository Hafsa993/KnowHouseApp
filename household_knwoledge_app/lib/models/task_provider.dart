import 'package:flutter/material.dart';
import 'task_model.dart';
//hi

class TaskProvider extends ChangeNotifier {
  List<Task> toDoList = [
    // Shared tasks among family members
    Task(
      title: 'Bake cheese tarts',
      deadline: DateTime.now().add(const Duration(days: 1)),
      category: 'Cooking',
      difficulty: 'Easy',
      description: 'Bake cheese tarts following the recipe in the instructions',
      rewardPoints: 15,
      assignedTo: 'JohnDoe',
    ),
    Task(
      title: 'Clean Kitchen',
      deadline: DateTime.now().add(const Duration(days: 1)),
      category: 'Cleaning',
      difficulty: 'Medium',
      description: 'Clean all surfaces, mop the floor, and take out the trash.',
      rewardPoints: 20,
      assignedTo: "JohnDoe",
    ),
    Task(
      title: 'Prepare for guests',
      deadline: DateTime.now().add(const Duration(days: 1)),
      category: 'Planning',
      difficulty: 'Easy',
      description: 'Plan for guests',
      rewardPoints: 15,
      assignedTo: 'JohnDoe',
    ),
    Task(
      title: 'Take out trash',
      deadline: DateTime.now().add(const Duration(days: 1)),
      category: 'Cleaning',
      difficulty: 'Easy',
      description: 'Take out trash',
      rewardPoints: 15,
      assignedTo: 'Sarah',
    ),
    Task(
      title: 'Clean the fish tank',
      deadline: DateTime.now().add(const Duration(days: 1)),
      category: 'Cleaning',
      difficulty: 'Easy',
      description: 'Clean the fish tank',
      rewardPoints: 15,
      assignedTo: 'JohnDoe',
    ),
    Task(
      title: 'Do Laundry',
      deadline: DateTime.now().add(const Duration(days: 2)),
      category: 'Cleaning',
      difficulty: 'Easy',
      description: 'Wash, dry, and fold clothes.',
      rewardPoints: 15,
      assignedTo: 'Alex',
    ),
    // Add more tasks
  ];
  

  List<Task> pendingTasks(String username) {
    // Return the most urgent, unaccepted Tasks assgned to me


    List<Task> unsortedList = toDoList.where((task) => !task.isAccepted && !task.isDeclined && task.assignedTo.compareTo(username) == 0).toList();      
    unsortedList.sort((a, b) => a.deadline.compareTo(b.deadline));
    return unsortedList;
  }

  List<Task> myTasks(String username) {
    return toDoList.where((task) => task.acceptedBy == username && !task.isCompleted).toList();
  }
  List<Task> myCompletedTasks(String username) {
    return toDoList.where((task) => task.acceptedBy == username && task.isCompleted).toList();
  }
  void acceptTask(Task task, String username) {
    task.isAccepted = true;
    task.acceptedBy = username;
    notifyListeners();
  }
   void takeOverTask(Task task, String username) {
    task.isAccepted = true;
    task.acceptedBy = username;
    task.assignedTo = username;
    notifyListeners();
  }
  void declineTask(Task task) {
    task.isDeclined = true;
    notifyListeners();
  }

  void completeTask(Task task) {
    task.isCompleted = true;
    notifyListeners();
  }

  void addTask(Task task) {
    toDoList.add(task);
    notifyListeners();
  }
  
}
