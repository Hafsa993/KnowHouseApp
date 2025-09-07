// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:household_knwoledge_app/providers/task_provider.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:household_knwoledge_app/screens/calendar_screen.dart';
import 'package:household_knwoledge_app/screens/home_screen.dart';
import 'package:household_knwoledge_app/screens/profile_screen.dart';
import 'package:household_knwoledge_app/screens/ranking_screen.dart';
import 'package:household_knwoledge_app/widgets/todo_creation.dart';
import 'package:provider/provider.dart';

void main() {
    group('Home Screen Tests', () {
    testWidgets('Displays leaderboard and tasks', (WidgetTester tester) async {
      // Wrap the widget with necessary providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => TaskProvider()),
          ],
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Check for Leaderboard header
      expect(find.text('Leaderboard'), findsOneWidget);

      // Check for Open Tasks section
      expect(find.text('Open Tasks'), findsOneWidget);

      // Check for Add ToDo button
      expect(find.text('Add ToDo'), findsOneWidget);

      await tester.tap(find.text('Accept'));
      await tester.pump();

      expect(find.text('Are you sure you want to accept this toDo?'), findsOneWidget);

      await tester.tap(find.text('Yes, really accept'));
      await tester.pump();

    });
  });
  group('Leaderboard Screen Tests', () {
    testWidgets('Displays users with correct ranks and points', (WidgetTester tester) async {
       await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => TaskProvider()),
          ],
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      // Verify the Leaderboard header
      expect(find.text('Rankings'), findsOneWidget);

      // Check if the top users are displayed
      expect(find.text('Max'), findsOneWidget); // First place
      expect(find.text('Sarah'), findsOneWidget); // Second place
      expect(find.text('JohnDoe'), findsOneWidget); // Third place

      // Check if points are correct
      expect(find.text('125 pts'), findsOneWidget); // Max's points
      expect(find.text('122 pts'), findsOneWidget); // Sarah's points
      expect(find.text('100 pts'), findsAny); // JohnDoe's points
      expect(find.text('90 pts'), findsOneWidget); // Anna's points
      expect(find.text('75 pts'), findsOneWidget); // Alex's points
    });
  });

  group('Calendar Screen Tests', () {
    testWidgets('Displays tasks on correct dates', (WidgetTester tester) async {
       await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TaskProvider()),
          ],
          child: MaterialApp(
            home: CalendarScreen(),
          ),
        ),
      );

      // Verify the Calendar header
      expect(find.text('Calendar'), findsOneWidget);

      // Tap on a 12.12
      await tester.tap(find.text('12')); 
      await tester.pumpAndSettle();

      // Verify that the tasks for the date are displayed
      expect(find.text('ToDos for 12-12-2024'), findsOneWidget);
      expect(find.text('Clean Kitchen'), findsOneWidget);
    });
  });

  group('Profile Screen Tests', () {
    testWidgets('Displays user information', (WidgetTester tester) async {
       await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
          ],
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      // Verify username and points Assuming here prototype with Johndoe!!!!!!!

      expect(find.text('JohnDoe'), findsOneWidget); // Username
      expect(find.text('Points: 100'), findsOneWidget); // Points

    });
  });

 group('ToDo Creation Tests', () {
    testWidgets('Handles form validation correctly', (WidgetTester tester) async {
      // Wrap the ToDoForm with MaterialApp and necessary providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => TaskProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ToDoForm(),
            ),
          ),
        ),
      );

      // Check if the first step is displayed
      expect(find.text('Select Category'), findsOneWidget);

      // Attempt to proceed without selecting a category
      await tester.tap(
      find.descendant(
        of: find.byType(Stepper), // Limit to buttons within the Stepper
        matching: find.text('Next'),
      ).first, // Tap the first matching "Next" button
    );
      await tester.pump();


      // Verify validation message appears
      expect(find.text('Please select a category'), findsOneWidget);

  
    });
  });
}
