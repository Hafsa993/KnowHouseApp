// test/models/task_test.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_knwoledge_app/models/task_model.dart';

void main() {
  group('Task Model Tests', () {
    late Task testTask;
    late DateTime futureDeadline;
    late DateTime pastDeadline;

    setUp(() {
      futureDeadline = DateTime.now().add(const Duration(hours: 24));
      pastDeadline = DateTime.now().subtract(const Duration(hours: 1));
      
      testTask = Task(
        id: 'task-123',
        title: 'Clean Kitchen',
        description: 'Deep clean the kitchen counters and appliances',
        category: 'Cleaning',
        difficulty: 'Medium',
        deadline: futureDeadline,
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true, 
        isDeclined: false, 
        rewardPoints: 15,
        completionTime: null, 
      );
    });

    test('should create task with correct properties', () {
      expect(testTask.id, equals('task-123'));
      expect(testTask.title, equals('Clean Kitchen'));
      expect(testTask.category, equals('Cleaning'));
      expect(testTask.difficulty, equals('Medium'));
      expect(testTask.rewardPoints, equals(15));
      expect(testTask.isCompleted, isFalse);
      expect(testTask.isAccepted, isTrue);
      expect(testTask.isDeclined, isFalse);
      expect(testTask.acceptedBy, equals('user-123'));
      expect(testTask.assignedTo, equals('user-123'));
    });

    test('should identify overdue tasks correctly', () {
      final overdueTask = Task(
        id: 'overdue-task',
        title: 'Overdue Task',
        description: 'This task is overdue',
        category: 'Other',
        difficulty: 'Easy',
        deadline: pastDeadline,
        assignedTo: 'user-123',
        acceptedBy: 'user-123',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: true,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: null,
      );

      //  Add helper method to your Task model
      expect(overdueTask.deadline.isBefore(DateTime.now()), isTrue);
      expect(testTask.deadline.isAfter(DateTime.now()), isTrue);
    });

    test('should handle task completion correctly', () {
      expect(testTask.isCompleted, isFalse);
      expect(testTask.completionTime, isNull);
      
      // Simulate task completion
      testTask.isCompleted = true;
      testTask.completionTime = DateTime.now();
      
      expect(testTask.isCompleted, isTrue);
      expect(testTask.completionTime, isNotNull);
    });

    test('should handle task acceptance workflow', () {
      final newTask = Task(
        id: 'new-task',
        title: 'New Task',
        description: 'A brand new task',
        category: 'Cooking',
        difficulty: 'Easy',
        deadline: futureDeadline,
        assignedTo: '',
        acceptedBy: '',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: false,
        isDeclined: false,
        rewardPoints: 5,
        completionTime: null,
      );

      expect(newTask.isAccepted, isFalse);
      expect(newTask.isDeclined, isFalse);
      expect(newTask.acceptedBy, equals(''));
      
      // Simulate task acceptance
      newTask.isAccepted = true;
      newTask.acceptedBy = 'user-456';
      newTask.assignedTo = 'user-456';
      
      expect(newTask.isAccepted, isTrue);
      expect(newTask.acceptedBy, equals('user-456'));
      expect(newTask.assignedTo, equals('user-456'));
    });

    test('should handle task decline correctly', () {
      final taskToDecline = Task(
        id: 'decline-task',
        title: 'Task to Decline',
        description: 'This task will be declined',
        category: 'Maintenance',
        difficulty: 'Hard',
        deadline: futureDeadline,
        assignedTo: '',
        acceptedBy: '',
        familyId: 'family-789',
        isCompleted: false,
        isAccepted: false,
        isDeclined: false,
        rewardPoints: 20,
        completionTime: null,
      );

      // Simulate task decline
      taskToDecline.isDeclined = true;
      
      expect(taskToDecline.isDeclined, isTrue);
      expect(taskToDecline.isAccepted, isFalse);
    });

    test('should convert to map correctly', () {
      final taskMap = testTask.toMap();
      
      expect(taskMap['title'], equals('Clean Kitchen'));
      expect(taskMap['category'], equals('Cleaning'));
      expect(taskMap['difficulty'], equals('Medium'));
      expect(taskMap['rewardPoints'], equals(15));
      expect(taskMap['isCompleted'], isFalse);
      expect(taskMap['isAccepted'], isTrue);
      expect(taskMap['isDeclined'], isFalse);
      expect(taskMap['acceptedBy'], equals('user-123'));
      expect(taskMap['assignedTo'], equals('user-123'));
      expect(taskMap['deadline'], isA<DateTime>());
      expect(taskMap['familyId'], equals('family-789'));
      expect(taskMap['completionTime'], isNull);
    });

    test('should create task from map correctly', () {
      
      final taskMap = {
        'title': 'Garden Work',
        'description': 'Water plants and trim hedges',
        'category': 'Gardening',
        'difficulty': 'Hard',
        'deadline': Timestamp.fromDate(DateTime.now().add(const Duration(days: 2))), //  Use Timestamp
        'assignedTo': 'user-789',
        'acceptedBy': 'user-789', //  Correct field name
        'familyId': 'family-456',
        'isCompleted': true,
        'isAccepted': true,
        'isDeclined': false,
        'rewardPoints': 20,
        'completionTime': null, //  Use Timestamp
      };

      final task = Task.fromMap(taskMap, 'new-task-id');
      
      expect(task.id, equals('new-task-id'));
      expect(task.title, equals('Garden Work'));
      expect(task.category, equals('Gardening'));
      expect(task.difficulty, equals('Hard'));
      expect(task.rewardPoints, equals(20));
      expect(task.isCompleted, isTrue);
      expect(task.isAccepted, isTrue);
      expect(task.isDeclined, isFalse);
      expect(task.acceptedBy, equals('user-789'));
      expect(task.assignedTo, equals('user-789'));
      expect(task.completionTime, isNull);
    });

    test('should handle task workflow states correctly', () {
      final workflowTask = Task(
        id: 'workflow-task',
        title: 'Workflow Test Task',
        description: 'Testing task workflow',
        category: 'Planning',
        difficulty: 'Medium',
        deadline: futureDeadline,
        assignedTo: '',
        acceptedBy: '',
        familyId: 'family-123',
        isCompleted: false,
        isAccepted: false,
        isDeclined: false,
        rewardPoints: 10,
        completionTime: null,
      );

      // Initial state: unassigned
      expect(workflowTask.isAccepted, isFalse);
      expect(workflowTask.isDeclined, isFalse);
      expect(workflowTask.isCompleted, isFalse);
      
      // User accepts task
      workflowTask.isAccepted = true;
      workflowTask.acceptedBy = 'user-123';
      workflowTask.assignedTo = 'user-123';
      
      expect(workflowTask.isAccepted, isTrue);
      expect(workflowTask.acceptedBy, equals('user-123'));
      
      // User completes task
      workflowTask.isCompleted = true;
      workflowTask.completionTime = DateTime.now();
      
      expect(workflowTask.isCompleted, isTrue);
      expect(workflowTask.completionTime, isNotNull);
    });

    test('should validate required fields', () {
      // Test minimum required fields
      final minimalTask = Task(
        title: 'Minimal Task',
        deadline: futureDeadline,
        category: 'Other',
        difficulty: 'Easy',
      );

      expect(minimalTask.title, equals('Minimal Task'));
      expect(minimalTask.id, equals(''));
      expect(minimalTask.description, equals(''));
      expect(minimalTask.rewardPoints, equals(0));
      expect(minimalTask.isAccepted, isFalse);
      expect(minimalTask.isDeclined, isFalse);
      expect(minimalTask.isCompleted, isFalse);
      expect(minimalTask.acceptedBy, equals(''));
      expect(minimalTask.assignedTo, equals(''));
    });
  });
}