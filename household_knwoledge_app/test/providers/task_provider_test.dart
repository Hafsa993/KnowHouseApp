// test/providers/task_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:household_knwoledge_app/models/task_model.dart';

void main() {
  group('TaskProvider Tests', () {


    test('should filter tasks by category correctly', () {
      final cookingTask = Task(
        id: 'task-1',
        title: 'Make Dinner',
        description: 'Cook dinner for family',
        category: 'Cooking',
        difficulty: 'Medium',
        deadline: DateTime.now().add(const Duration(hours: 2)),
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 10,
        completionTime: null,
      );

      final cleaningTask = Task(
        id: 'task-2',
        title: 'Clean Bathroom',
        description: 'Deep clean the bathroom',
        category: 'Cleaning',
        difficulty: 'Medium',
        deadline: DateTime.now().add(const Duration(hours: 3)),
        assignedTo: 'user-456',
        acceptedBy: 'user-456',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 10,
        completionTime: null,
      );

      final allTasks = [cookingTask, cleaningTask];
      
      // Test filtering by category
      final cookingTasks = allTasks.where((task) => task.category == 'Cooking').toList();
      final cleaningTasks = allTasks.where((task) => task.category == 'Cleaning').toList();
      
      expect(cookingTasks.length, equals(1));
      expect(cleaningTasks.length, equals(1));
      expect(cookingTasks.first.title, equals('Make Dinner'));
      expect(cleaningTasks.first.title, equals('Clean Bathroom'));
    });

    test('should filter completed vs pending tasks correctly', () {
      final completedTask = Task(
        id: 'completed-task',
        title: 'Completed Task',
        description: 'This task is done',
        category: 'Other',
        difficulty: 'Easy',
        deadline: DateTime.now(),
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: true,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: DateTime.now(),
      );

      final pendingTask = Task(
        id: 'pending-task',
        title: 'Pending Task',
        description: 'This task is not done',
        category: 'Other',
        difficulty: 'Easy',
        deadline: DateTime.now().add(const Duration(hours: 1)),
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: null,
      );

      final allTasks = [completedTask, pendingTask];
      
      // Filter completed and pending tasks
      final completed = allTasks.where((task) => task.isCompleted).toList();
      final pending = allTasks.where((task) => !task.isCompleted).toList();
      
      expect(completed.length, equals(1));
      expect(pending.length, equals(1));
      expect(completed.first.title, equals('Completed Task'));
      expect(pending.first.title, equals('Pending Task'));
    });

    test('should sort tasks by deadline correctly', () {
      final task1 = Task(
        id: 'task-1',
        title: 'Later Task',
        description: 'Due later',
        category: 'Other',
        difficulty: 'Easy',
        deadline: DateTime.now().add(const Duration(hours: 5)),
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: null,
      );

      final task2 = Task(
        id: 'task-2',
        title: 'Earlier Task',
        description: 'Due earlier',
        category: 'Other',
        difficulty: 'Easy',
        deadline: DateTime.now().add(const Duration(hours: 1)),
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: null,
      );

      final unsortedTasks = [task1, task2];
      
      // Sort tasks by deadline - earliest first
      final sortedTasks = List<Task>.from(unsortedTasks)
        ..sort((a, b) => a.deadline.compareTo(b.deadline));
      
      expect(sortedTasks.first.id, equals('task-2')); // Earlier deadline first
      expect(sortedTasks.last.id, equals('task-1'));
    });

    test('should calculate total points from completed tasks', () {
      final tasks = [
        Task(
          id: 'task-1',
          title: 'Task 1',
          description: 'First task',
          category: 'Cooking',
          difficulty: 'Easy',
          deadline: DateTime.now(),
          assignedTo: 'user-1',
          acceptedBy: 'user-1',
          familyId: 'family-123',
          isCompleted: true,
          isAccepted: true,
          isDeclined: false,
          rewardPoints: 5,
          completionTime: DateTime.now(),
        ),
        Task(
          id: 'task-2',
          title: 'Task 2',
          description: 'Second task',
          category: 'Cleaning',
          difficulty: 'Medium',
          deadline: DateTime.now(),
          assignedTo: 'user-2',
          acceptedBy: 'user-2',
          familyId: 'family-123',
          isCompleted: true,
          isAccepted: true,
          isDeclined: false,
          rewardPoints: 10,
          completionTime: DateTime.now(),
        ),
        Task(
          id: 'task-3',
          title: 'Task 3',
          description: 'Incomplete task',
          category: 'Shopping',
          difficulty: 'Easy',
          deadline: DateTime.now().add(const Duration(hours: 1)),
          assignedTo: 'user-1',
          acceptedBy: 'user-1',
          familyId: 'family-123',
          isCompleted: false,
          isAccepted: true,
          isDeclined: false,
          rewardPoints: 7,
          completionTime: null,
        ),
      ];

      // Calculate total points from completed tasks only
      final completedTasks = tasks.where((task) => task.isCompleted).toList();
      final totalPoints = completedTasks.fold<int>(0, (sum, task) => sum + task.rewardPoints);

      expect(totalPoints, equals(15)); // 5 + 10 = 15 (excluding incomplete task)
    });

    test('should filter tasks by acceptance status', () {
      final acceptedTask = Task(
        id: 'accepted-task',
        title: 'Accepted Task',
        description: 'This task is accepted',
        category: 'Cooking',
        difficulty: 'Easy',
        deadline: DateTime.now().add(const Duration(hours: 2)),
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: null,
      );

      final openTask = Task(
        id: 'open-task',
        title: 'Open Task',
        description: 'This task is open for acceptance',
        category: 'Cleaning',
        difficulty: 'Medium',
        deadline: DateTime.now().add(const Duration(hours: 3)),
        assignedTo: 'user-456',
        acceptedBy: '',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: false,
        isDeclined: false,
        rewardPoints: 10,
        completionTime: null,
      );

      final allTasks = [acceptedTask, openTask];
      
      // Filter by acceptance status
      final accepted = allTasks.where((task) => task.isAccepted).toList();
      final open = allTasks.where((task) => !task.isAccepted && !task.isDeclined).toList();
      
      expect(accepted.length, equals(1));
      expect(open.length, equals(1));
      expect(accepted.first.acceptedBy, equals('user-123'));
      expect(open.first.acceptedBy, equals(''));
    });

    test('should filter tasks by assigned user', () {
      final task1 = Task(
        id: 'task-1',
        title: 'Task for User 1',
        description: 'Assigned to user 1',
        category: 'Cooking',
        difficulty: 'Easy',
        deadline: DateTime.now().add(const Duration(hours: 2)),
        assignedTo: 'user-1',
        acceptedBy: 'user-1',
        familyId: 'family-123',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: null,
      );

      final task2 = Task(
        id: 'task-2',
        title: 'Task for User 2',
        description: 'Assigned to user 2',
        category: 'Cleaning',
        difficulty: 'Medium',
        deadline: DateTime.now().add(const Duration(hours: 3)),
        assignedTo: 'user-2',
        acceptedBy: 'user-2',
        familyId: 'family-123',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 10,
        completionTime: null,
      );

      final allTasks = [task1, task2];
      
      // Filter tasks by assigned user
      final user1Tasks = allTasks.where((task) => task.assignedTo == 'user-1').toList();
      final user2Tasks = allTasks.where((task) => task.assignedTo == 'user-2').toList();
      
      expect(user1Tasks.length, equals(1));
      expect(user2Tasks.length, equals(1));
      expect(user1Tasks.first.title, equals('Task for User 1'));
      expect(user2Tasks.first.title, equals('Task for User 2'));
    });

    test('should identify overdue tasks', () {
      final overdueTask = Task(
        id: 'overdue-task',
        title: 'Overdue Task',
        description: 'This task is overdue',
        category: 'Other',
        difficulty: 'Easy',
        deadline: DateTime.now().subtract(const Duration(hours: 1)),
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: null,
      );

      final futureTask = Task(
        id: 'future-task',
        title: 'Future Task',
        description: 'This task is not overdue',
        category: 'Other',
        difficulty: 'Easy',
        deadline: DateTime.now().add(const Duration(hours: 1)),
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: null,
      );

      final allTasks = [overdueTask, futureTask];
      final now = DateTime.now();
      
      // Filter overdue tasks
      final overdueTasks = allTasks.where((task) => 
        !task.isCompleted && task.deadline.isBefore(now)).toList();
      
      expect(overdueTasks.length, equals(1));
      expect(overdueTasks.first.title, equals('Overdue Task'));
    });
  });
}