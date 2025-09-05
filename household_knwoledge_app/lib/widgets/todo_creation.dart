// lib/widgets/todo_creation.dart

import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:household_knwoledge_app/models/task_model.dart';
import 'package:household_knwoledge_app/providers/task_provider.dart';
import 'package:household_knwoledge_app/models/user_model.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ToDoForm extends StatefulWidget {
  const ToDoForm({super.key});

  @override
  State<ToDoForm> createState() => _ToDoFormState();
}

class _ToDoFormState extends State<ToDoForm> {
  @override
  void initState() {
    super.initState();
   
  }

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
  // Categories
  final List<String> _categories = categories;

  // Difficulties
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

/////////////////////////////
/// Helper Methods
///////////////////////////////
  @override
  void dispose() {
    _deadlineController.dispose();
    _rewardPointsController.dispose();
    super.dispose();
  }

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
              primary: Colors.purple[700]!,
              onSurface: Colors.indigo[600]!,
            ),
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

    if (!mounted) return;

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: this.context, 
        initialTime:
            TimeOfDay.fromDateTime(_selectedDeadline ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.purple[700]!,
                onSurface: Colors.indigo[600]!,
              ),
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

      if (!mounted) return; 

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
  List<User> _getSortedUsers(List<User> familyMembers) {
    List<User> users = familyMembers;

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

  void _showErrorSnackBar(String message) {
    //if other snackBar displayed, close it
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(8.0),

          // puts snackBar at the top so that its consistent with other error Snackbars here
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 130,
              right: 20,
              left: 20),
        ));

  }

  bool isPreferred(User user) {
    return _selectedCategory != null &&
        user.preferences.contains(_selectedCategory);
  }

  // Method to validate and move to next step
  //gets called upon every step continue
  void _continue() {

    if (_currentStep == 0) {

      if (_selectedCategory == null) {
        // if no category has been seletcted, display error snackbar
        _showErrorSnackBar('Please select a category');
        return;
      }
      
      // No validation needed for assigning to user
    } else if (_currentStep == 2) {
      // Validate task details

      if (_taskTitle.trim().isEmpty) {
      
        _showErrorSnackBar('Please enter a task title');
        return;
      }

      if (_rewardPointsController.text.trim().isEmpty) {

        _showErrorSnackBar('Please enter reward points');

        return;
      }

      if (int.tryParse(_rewardPointsController.text.trim()) == null) {
        
        _showErrorSnackBar('Reward points must be a valid number');
        return;
      }

      if (_selectedDeadline == null) {
        
        _showErrorSnackBar('Please select a deadline');
        return;
      }

      if (_description.trim().isEmpty) {
        
        _showErrorSnackBar('Please enter a task description');
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
        familyId: Provider.of<UserProvider>(context, listen: false)
            .currentUser!
            .familyId,
      );

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

///////////////////
/// Wigets
////////////////////

  Widget _buildUserAssignmentStep(UserProvider userProvider) {
  Stream<List<User>> familyMembersStream = userProvider.getFamilyMembers(userProvider.currentUser!);

    // Transform the stream by applying the sorting function
  Stream<List<User>> sortedFamilyMembersStream = familyMembersStream.map(_getSortedUsers);
    return Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<List<User>>(
                  stream: sortedFamilyMembersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {

                    return const Center(child: CircularProgressIndicator());

                  } else if (snapshot.hasError) {

                    return Center(
                        child:
                            Text('Error: ${snapshot.error.toString()}'));
                  }
                    List<User> sortedUsers = snapshot.data!;
                    return  _buildUserDropdown(sortedUsers);
                  }
                ),
              );
  }

  Widget _buildUserDropdown(List<User> sortedUsers) {
    return DropdownButtonFormField<String>(
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
          );
  }

  Widget _buildTaskDetailsStep() {
    return Column(
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
    );
  }


/////////////////////////////
/// Build Method
//////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
              content: _currentStep == 1 ? _buildUserAssignmentStep(userProvider) : SizedBox.shrink(),
            ),

            // Step 3: Enter Task Details
            Step(
              title: Text('ToDo Details'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.editing,
              content: _currentStep == 2 ? _buildTaskDetailsStep() : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
  
}

