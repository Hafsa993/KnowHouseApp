import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:household_knwoledge_app/models/user_provider.dart';
import 'package:household_knwoledge_app/screens/todo_show.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../models/task_provider.dart';
import '../models/user_model.dart';
import '../widgets/menu_drawer.dart';
import '../screens/profile_screen.dart';

class MyTasksScreen extends StatelessWidget {

  const MyTasksScreen({super.key}); // Example user

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    User currentUser = userProvider.getCurrUser();
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    // Separate tasks into pending and completed
    List<Task> pendingTasks = taskProvider.myTasks(currentUser.username);
    List<Task> completedTasks = taskProvider.myCompletedTasks(currentUser.username);

    return Scaffold(
      //backgroundColor:  Color.fromARGB(255, 211, 239, 247),
      appBar: AppBar(
        //backgroundColor:  Color.fromARGB(255, 6, 193, 240),
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title:  Text('My ToDos'),
      ),
      drawer:  MenuDrawer(),
      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        child: Column(
          children: [
            // Tasks To-Do Section
            Container(
              decoration: BoxDecoration(
                boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        //spreadRadius: 5,
        blurRadius: 5,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
                borderRadius: BorderRadius.all(Radius.circular(50)),
                //color: const Color.fromARGB(255, 255, 255, 255), 
                color: Theme.of(context).primaryColorLight,
                      /*
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter, 
                        end: Alignment.topCenter, 
                        colors: [Colors.blue, Colors.white],
                      ),
                      */
                    ),
              height: 100,
              child: Stack(
                    children: [
                      Positioned(
                        top:10,
                        left: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
                              },
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: userProvider.getProfileOfCurrUser(),
                              ),
                            ),
                            SizedBox(width: 10,),
              
                            Column(
                              children: [
                                SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
                                  },
                                  child: Text(currentUser.username, style: TextStyle(color: Colors.black, fontSize: 24))
                                ),
                                //SizedBox(height: 5,),
                                Text('${currentUser.points} points', style: TextStyle(color: Colors.green, fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
            ),
            SizedBox(height: 50,),
            Text(
              "Accepted but not completed ToDos:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 226, 223, 231),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      blurRadius: 8.0, // Spread of the shadow
                      offset: const Offset(0, 4), // Offset in the X and Y axis
                    ),
                  ],
                ),
                child: pendingTasks.isEmpty ? const Center(child: Text('No accepted ToDos')) : 
                ListView.builder(
                  itemCount: pendingTasks.length,
                  itemBuilder: (context, index) {
                    Task task = pendingTasks[index];
                    return Card(
                      margin:  EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                        padding:  EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style:  TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                 SizedBox(height: 4),
                                Text(
                                  'Due: ${DateFormat('dd-MM-yyyy HH:mm').format(task.deadline)}',
                                  style:  TextStyle(
                                    fontSize: 14,
                                    color: task.deadline.difference(DateTime.now()).inHours < 24
                                      ? Colors.red // Red if due in less than 24 hours
                                      : Colors.black54, // Default color
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
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 139, 143, 144), // Initial button color
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Mark task as completed and show reward popup
                                taskProvider.completeTask(task);
                                currentUser.contributions.update(task.category, (value) => value + task.rewardPoints );
                                currentUser.addPoints(task.rewardPoints);
                                // Show popup for completed Task
                                showCompletionDialog(context, task);
                              },
                              icon:  Icon(Icons.check_box_outline_blank),
                              label:  Text("Complete"),
                            ),
                          ],
                        ),
                      ),
                      ),
                    );
                  },
                ),
              ),
            ),
             SizedBox(height: 16),

            // Completed Tasks Section
             Text(
              "Completed ToDos in the last 30 days:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
             SizedBox(height: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 226, 223, 231),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      blurRadius: 8.0, // Spread of the shadow
                      offset: const Offset(0, 4), // Offset in the X and Y axis
                    ),
                  ],
                ),
                child: completedTasks.isEmpty ? const Center(child: Text('No ToDos completed in the last 30 days')) :
                ListView.builder(
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    Task task = completedTasks[index];
                    return Padding(
                      padding:  EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            task.title,
                            style:  TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey, // Completed tasks in grey
                            ),
                          ),
                          Text(
                            '+ ${task.rewardPoints}',
                            style:  TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar:  ToDoCreator(),
    );
  }
}
void showCompletionDialog(BuildContext context, Task task) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor:  Colors.white, // Light lavender background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with bounce animation
             Text(
              "ToDo Completed!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50), // Green text
              ),
            ).animate()
                .scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0), duration: 500.ms)
                .then(delay: 200.ms)
                .scale(begin: Offset(1.0, 1.0), end: Offset(1.05, 1.05), duration: 300.ms, curve: Curves.easeOut)
                .then()
                .scale(begin: Offset(1.05, 1.05), end: Offset(1.0, 1.0), duration: 200.ms, curve: Curves.easeIn),

            

             SizedBox(height: 16),

            // Animated smiley
             Icon(
              Icons.emoji_emotions,
              size: 90,
              color: Color.fromARGB(255, 178, 237, 38), // Purple smiley
            )
                .animate()
                .scale(begin: Offset(0, 0), end: Offset(1.0, 1.0), duration: 600.ms, curve: Curves.elasticOut),

             SizedBox(height:5 ),

            // Animated arrows
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Column(
                  children: [
                    Icon(Icons.arrow_upward, color: Color(0xFF66BB6A), size: 30),
                  ],
                ),
                 SizedBox(width: 20),
              Column(
                  children: [  SizedBox(height: 8),
                    Icon(Icons.arrow_upward, color: Color(0xFF66BB6A), size: 30),
                  ],
                ), // Medium green arrows
                 SizedBox(width: 20),
              Column(
                  children: [
                    Icon(Icons.arrow_upward, color: Color(0xFF66BB6A), size: 30),
                  ],
                ),
                 SizedBox(width: 20),
              Column(
                  children: [  SizedBox(height: 8),
                    Icon(Icons.arrow_upward, color: Color(0xFF66BB6A), size: 30),
                  ],
                ),
              ]
                  .animate(interval: 150.ms) // Delay each arrow
                  .fadeIn(duration: 400.ms) // Fade-in effect
                  .slideY(begin: 0.2, end: 0.0, duration: 400.ms).then()
                  .slideY(begin: 0.0, end: 0.2, duration: 400.ms).then()
                  .slideY(begin: 0.2, end: 0.0, duration: 400.ms), // Slide up animation
            
            ),

             SizedBox(height: 20),

            // Animated reward points
            Text(
              "+ ${task.rewardPoints} 😊",
              style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF388E3C), // Green text
              ),
            )
                .animate()
                .scale(begin: Offset(0, 0), end: Offset(1.0, 1.0), duration: 500.ms, curve: Curves.easeOut)
                .fadeIn(), // Fade-in for smooth entry

             SizedBox(height: 20),

            // "OK" button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFF4CAF50), // Vibrant green
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child:  Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).animate().fadeIn(delay: 200.ms), // Button fade-in animation
          ],
        ),
      );
    },
  );
}