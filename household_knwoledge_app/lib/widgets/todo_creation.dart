// lib/widgets/todo_creation.dart

import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:household_knwoledge_app/models/task_model.dart';
import 'package:household_knwoledge_app/models/task_provider.dart';
import 'package:household_knwoledge_app/models/user_model.dart';
import 'package:household_knwoledge_app/models/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ToDoForm extends StatefulWidget {
  const ToDoForm({super.key});

  @override
  State<ToDoForm> createState() => _ToDoFormState();
}

class _ToDoFormState extends State<ToDoForm> {
  // Stepper current step
  int _currentStep = 0;

  // Form fields
  String? _selectedCategory;
  String? _selectedUser;
  String _taskTitle = '';
  String _difficulty = 'Easy';
  String _description = '';
  int _rewardPoints = 0;
  DateTime? _selectedDeadline;

  // Controllers
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _rewardPointsController = TextEditingController();

  @override
  void dispose() {
    _deadlineController.dispose();
    _rewardPointsController.dispose();
    super.dispose();
  }

  // Categories
  final List<String> _categories = categories;

  // Difficulties
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  // Helper method to select date
  Future<void> _selectDateTime(BuildContext context) async {
    DateTime initialDate = DateTime.now().add(Duration(days: 1));
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime.now().add(Duration(days: 365));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // change the border color
              primary: Colors.purple[700]!,
              // change the text color
              onSurface: Colors.indigo[600]!,
            ),
            // button colors
            buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme.light(
                primary: Colors.green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDeadline ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                // change the border color
                primary: Colors.purple[700]!,
                // change the text color
                onSurface: Colors.indigo[600]!,
              ),
              // button colors
              buttonTheme: ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: Colors.green,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _deadlineController.text =
              DateFormat('yyyy-MM-dd HH:mm').format(_selectedDeadline!);
        });
      }
    }
  }

  // Method to sort users based on category preferences
  List<User> _getSortedUsers(UserProvider userProvider) {
    List<User> users = userProvider.currUsers;

    // Separate users with the selected category in their preferences
    List<User> preferredUsers = [];
    List<User> otherUsers = [];

    if (_selectedCategory != null) {
      for (var user in users) {
        if (user.preferences.contains(_selectedCategory)) {
          preferredUsers.add(user);
        } else {
          otherUsers.add(user);
        }
      }
    } else {
      preferredUsers = users;
      otherUsers = [];
    }

    // Combine the lists with preferred users first
    return [...preferredUsers, ...otherUsers];
  }

  // Method to get color for user based on preference
  Color _getUserColor(User user) {
    if (_selectedCategory != null &&
        user.preferences.contains(_selectedCategory)) {
      return Colors.green; // Preferred users in green
    } else {
      return Colors.blueGrey; // Others in blue-grey
    }
  }

  bool isPreferred(User user) {
    return _selectedCategory != null &&
        user.preferences.contains(_selectedCategory);
  }

  // Method to validate and move to next step
  void _continue() {
    //gets called upon every step continue

    if (_currentStep == 0) {
      if (_selectedCategory == null) {

        //if other snackBar displayed, close it
        ScaffoldMessenger.of(context).clearSnackBars();

        // if no category has been seletcted, display error snackbar

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(8.0),

          // puts snackBar at the top so that its consistent with other "error message" Snackbars here

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 130,
              right: 20,
              left: 20),
        ));
        return;
      }
      //} else if (_currentStep == 1) {

      // No validation needed for assigning to user
    } else if (_currentStep == 2) {
      // Validate task details

      if (_taskTitle.trim().isEmpty) {
      
        //if other snackBar displayed, close it
        ScaffoldMessenger.of(context).clearSnackBars();
        
        //if no title has been written
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter the task title'),
          behavior: SnackBarBehavior.floating,

          // puts snackBar at the top so that its visible

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 130,
              right: 20,
              left: 20),
        ));
        return;
      }

      if (_rewardPointsController.text.trim().isEmpty) {
        
        //if other snackBar displayed, close it
        ScaffoldMessenger.of(context).clearSnackBars();
        
        //if no rewardPoints have been specified
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter reward points'),
          behavior: SnackBarBehavior.floating,

          // puts snackBar at the top so that its visible

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 130,
              right: 20,
              left: 20),
        ));
        return;
      }

      if (int.tryParse(_rewardPointsController.text.trim()) == null) {
        
        //if other snackBar displayed, close it
        ScaffoldMessenger.of(context).clearSnackBars();
        
        //if rewardPoints are not Integers
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Reward points must be an integer'),
          behavior: SnackBarBehavior.floating,

          // puts snackBar at the top so that its visible

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 130,
              right: 20,
              left: 20),
        ));
        return;
      }

      if (_selectedDeadline == null) {
        
        //if other snackBar displayed, close it
        ScaffoldMessenger.of(context).clearSnackBars();
        
        //if no deadline has been selected
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a deadline'),
          behavior: SnackBarBehavior.floating,

          // puts snackBar at the top so that its visible

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 130,
              right: 20,
              left: 20),
        ));
        return;
      }

      if (_description.trim().isEmpty) {
        
        //if other snackBar displayed, close it
        ScaffoldMessenger.of(context).clearSnackBars();
        
        //if no decription has been written
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter a description for this task'),
          behavior: SnackBarBehavior.floating,

          // puts snackBar at the top so that its visible

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 130,
              right: 20,
              left: 20),
        ));
        return;
      }

      // All validations passed, proceed to create task
      _rewardPoints = int.parse(_rewardPointsController.text.trim());

      // Create Task object
      Task newTask = Task(
        title: _taskTitle.trim(),
        deadline: _selectedDeadline!,
        category: _selectedCategory!,
        difficulty: _difficulty,
        description: _description.trim(),
        rewardPoints: _rewardPoints,
        assignedTo:
            _selectedUser ?? '', // Assigned to selected user or 'No One'
      );

      //print('Task Created: ${newTask.title}, Assigned To: ${newTask.assignedTo}'); // Debug print

      // Add task via TaskProvider
      Provider.of<TaskProvider>(context, listen: false).addTask(newTask);

      // Close the dialog
      Navigator.of(context).pop();
    }

    setState(() {
      if (_currentStep < 2) {
        _currentStep += 1;
      }
    });
  }

  // Method to go back to previous step
  void _cancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<User> sortedUsers = _getSortedUsers(userProvider);

    //add ToDo in steps
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: _continue,
          onStepCancel: _cancel,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 2 ? 'Create' : 'Next'),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: Text(_currentStep == 0 ? 'Close' : 'Back'),
                ),
              ],
            );
          },
          steps: [
            // Step 1: Select Category
            Step(
              title: Text('Select Category'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.editing,
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a category' : null,
                ),
              ),
            ),

            // Step 2: Assign to User
            Step(
              title: Text('Assign to User'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.editing,
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Assign To',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedUser,
                  //drop Down menu to select User
                  items: [
                    ...sortedUsers.map((User user) {
                      return DropdownMenuItem<String>(
                        value: user.username,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: _getUserColor(user),
                                radius: 5,
                              ),
                              SizedBox(width: 8),
                              Text(user.username),
                              if (isPreferred(user))
                                Text(
                                  " prefers this category",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    DropdownMenuItem<String>(
                      value: '',
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              radius: 5,
                            ),
                            SizedBox(width: 8),
                            Text('No One'),
                            SizedBox(width: 8),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                  // Customize the displayed item when collapsed so that prefer this doesnt peek outside
                  selectedItemBuilder: (BuildContext context) {
                    return [
                      ...sortedUsers.map((User user) {
                        return DropdownMenuItem<String>(
                          value: user.username,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: _getUserColor(user),
                                radius: 5,
                              ),
                              SizedBox(width: 8),
                              Text(user.username),
                            ],
                          ),
                        );
                      }),
                      DropdownMenuItem<String>(
                        value: '',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                radius: 5,
                              ),
                              SizedBox(width: 8),
                              Text('No One'),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUser = newValue!;
                    });
                  },
                ),
              ),
            ),

            // Step 3: Enter Task Details
            Step(
              title: Text('ToDo Details'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.editing,
              content: Column(
                children: [
                  // Task Title
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ToDo Title',
                        border: OutlineInputBorder(),
                        hintText: 'Enter a title',
                      ),
                      onChanged: (value) {
                        _taskTitle = value;
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  //Difficulty of Task
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Difficulty',
                      border: OutlineInputBorder(),
                    ),
                    value: _difficulty,
                    items: _difficulties.map((String level) {
                      return DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _difficulty = newValue!;
                      });
                    },
                  ),

                  SizedBox(height: 16),

                  // Reward Points
                  TextFormField(
                    controller: _rewardPointsController,
                    decoration: InputDecoration(
                      labelText: 'Reward Points',
                      border: OutlineInputBorder(),
                      hintText: 'Enter an integer value',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),

                  // Deadline
                  TextFormField(
                    controller: _deadlineController,
                    decoration: InputDecoration(
                      labelText: 'Deadline',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDateTime(context),
                  ),
                  SizedBox(height: 16),

                  // Description
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
