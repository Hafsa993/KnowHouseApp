import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_model.dart';
import 'package:household_knwoledge_app/models/user_model.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class ConfirmTaskCompleted extends StatefulWidget {
  final Task taskToComplete;
  final User currentUser;

  const ConfirmTaskCompleted(this.taskToComplete, this.currentUser, {super.key});

  @override
  ConfirmTaskCompletedState createState() => ConfirmTaskCompletedState();
}

class ConfirmTaskCompletedState extends State<ConfirmTaskCompleted> {
  @override
  Widget build(BuildContext context) {
    
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    return Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[   
            Text('Are you sure you want to complete this task?'),
            Row( 
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    taskProvider.completeTask(widget.taskToComplete.id);
                    // Add reward points to the user
                     Provider.of<UserProvider>(context, listen: false)
                      .addPointsToUser(widget.taskToComplete.rewardPoints);
                    Navigator.pop(context);                    
                  },
                  child: const Text("Confirm"),
                ) 
              ],
            ),
          ]   
        )
      );
  }
}