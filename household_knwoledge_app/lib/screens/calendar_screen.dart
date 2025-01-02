// lib/pages/calendar_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:household_knwoledge_app/models/task_model.dart';
import 'package:household_knwoledge_app/widgets/todo_creator_button.dart';
import 'package:provider/provider.dart';
import 'package:household_knwoledge_app/providers/task_provider.dart';
import '../widgets/menu_drawer.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access TaskProvider without listening to changes directly, so listen false
    TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 220, 227, 230),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title: const Text('Calendar'),
      ),
      drawer: const MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<List<Task>>(
          // Listen to the stream of all tasks
          stream: taskProvider.getAllTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the stream is loading, show a loading indicator
              return Center(child: CircularProgressIndicator());

            } else if (snapshot.hasError) {
              // If there's an error, display it
              return Center(child: Text('Error: ${snapshot.error}'));

            }  else {
              // Once data is available, process it
              List<Task> allTasks = snapshot.data!;

              List<Task> tasks = allTasks.where((task) => !task.isCompleted).toList();

              return CalendarCarousel(
                todayButtonColor: Colors.blue,
                headerTextStyle: TextStyle(color: Colors.black, fontSize: 20),
                iconColor: Colors.black,
                onDayPressed: (date, events) {
                  // Find tasks for the selected date
                  List<Task> tasksForDate = tasks
                      .where((task) => isSameDay(task.deadline, date))
                      .toList();

                  if (tasksForDate.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('ToDos for ${dateOnly(date.toLocal())}'),
                          insetPadding: EdgeInsets.symmetric(
                            horizontal: 50.0,
                            vertical: 200.0,
                          ),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView.builder(
                              itemCount: tasksForDate.length,
                              itemBuilder: (context, index) {
                                Task lvtask = tasksForDate[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(lvtask.title),
                                    subtitle: Text(dateOnly(lvtask.deadline.toLocal())),
                                  ),
                                );
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                weekendTextStyle: const TextStyle(color: Colors.red),
                thisMonthDayBorderColor: Colors.grey,
                markedDatesMap: _getMarkedDates(tasks),
                firstDayOfWeek: 1,
              );
            }
          },
        ),
      ),
      bottomNavigationBar: ToDoCreator(),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  EventList<Event> _getMarkedDates(List<Task> tasks) {
    EventList<Event> markedDateMap = EventList<Event>(events: {});
    for (var task in tasks) {
      DateTime date = DateTime(task.deadline.year, task.deadline.month, task.deadline.day);
      markedDateMap.add(
        date,
        Event(
          date: date,
          title: task.title,
          icon: Icon(
            Icons.task,
            color: categoryColor(task.category),
          ),
        ),
      );
    }
    return markedDateMap;
  }

  // Converts a DateTime to a String containing only the date
  String dateOnly(DateTime date) {
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    return formattedDate;
  }

  // Assign colors based on task categories
  Color categoryColor(String category) {
    switch (category) {
      case 'Cooking':
        return Colors.red;
      case 'Gardening':
        return Colors.green;
      case 'Shopping':
        return Colors.amber[600]!;
      case 'Planning':
        return const Color.fromARGB(255, 145, 74, 189);
      case 'Care':
        return const Color.fromARGB(255, 255, 93, 212);
      case 'Maintenance':
        return const Color.fromARGB(255, 100, 155, 159);
      case 'Other':
        return const Color.fromARGB(255, 155, 144, 173);
      default:
        return Colors.blue; // Default color
    }
  }
}
