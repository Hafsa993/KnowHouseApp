import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/user_provider.dart';
import 'package:household_knwoledge_app/screens/ranking_screen.dart';
import 'package:household_knwoledge_app/screens/todo_show.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../models/task_provider.dart';
import '../models/user_model.dart';
import '../widgets/menu_drawer.dart';
import 'package:household_knwoledge_app/widgets/todo_creator_button.dart';

class HomeScreen extends StatelessWidget {
  

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<User> currUsers = Provider.of<UserProvider>(context).currUsers;
    User currentUser = Provider.of<UserProvider>(context).getCurrUser();
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    List<Task> urgentTasks = taskProvider.pendingTasks(currentUser.username);
    
  
    currUsers.sort((a, b) {
      if (b.points == a.points) {
        return a.username.compareTo(b.username); // Tie-breaker: alphabetical order
      }
      return b.points.compareTo(a.points); // Primary sorting: points descending
    });

    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title: Row(
          children: [
          const Icon(
                Icons.home,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 40,
              ),
          SizedBox(width: 10,),
          const Text('Home'),
        ],),
        
      ),
      drawer: const MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: 400,
              height: 255,
              child: Stack(
                children: [Stack(
                  children: [Positioned(child: Column(
                    /*children: [Image.asset("lib/assets/leaderboard.png", fit: BoxFit.scaleDown,),
                    ], */
                      children: [InkWell(
                              onTap: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RankingScreen()));
                                },
                                child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset("lib/assets/leaderboard.png", fit: BoxFit.scaleDown,),
                      ))],
                  ))],
                ),
                const Positioned(
                  top: 8,
                  right: 125,
                  child: Text(
                    "Leaderboard",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      shadows: <Shadow>[
      
      Shadow(
        offset: Offset(1.0, 1.0),
        blurRadius: 2.0,
        color: Color.fromARGB(124, 111, 163, 227),
      ),
    ],
                    ),
                  ),
                ),/* 
                const Positioned(
                  top: 120,
                  left: 10,
                  child: Text(
                    "Ends in 2d 23Hours",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ), */
                // Rank 1st
                Positioned(
                  top: 48,
                  right: 150,
                  child: rank(
                      radius: 30.0,
                      height: 2,
                      image: currUsers[0].profilepath,
                      name: currUsers[0].username,
                      point: "${currUsers[0].points}",
                      context: context),
                ),
                // for rank 2nd
                Positioned(
                  top: 85,
                  left: 45,
                  child: rank(
                      radius: 25.0,
                      height: 2,
                      image: currUsers[1].profilepath,
                      name: currUsers[1].username,
                      point: "${currUsers[1].points}",
                      context: context),
                ),
                // For 3rd rank
                Positioned(
                  top: 115,
                  right: 48,
                  child: rank(
                      radius: 20.0,
                      height: 2,
                      image: currUsers[2].profilepath,
                      name: currUsers[2].username,
                      point: "${currUsers[2].points}",
                      context: context),
                ),
              ],
              ),
            ),
            // Rest of the home screen
            const SizedBox(height: 8),
            const SizedBox(height: 16),
            const Text(
              'Open ToDos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
             Expanded(
                child: urgentTasks.isEmpty
                    ? const Center(child: Text('No pending tasks!'))
                    : ListView.builder(
                        itemCount: urgentTasks.length,
                        itemBuilder: (context, index) {
                          Task task = urgentTasks[index];
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
                                                    : Colors.black54,
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
                                                    backgroundColor: Colors.green,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 12, vertical: 8), // Increased padding
                                                    minimumSize: const Size(70, 40), // Ensures minimum button size
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      _showAcceptDialog(context, task, taskProvider, currentUser),
                                                  child: const Text('Accept'),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: Colors.white,
                                                    backgroundColor: Colors.red,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 12, vertical: 8),
                                                    minimumSize: const Size(70, 40),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  onPressed: () =>
                                                      _showDeclineDialog(context, task, taskProvider),
                                                  child: const Text('Decline'),
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
              ),

          ],
        ),
      ),
      bottomNavigationBar:  ToDoCreator(),
    );
  }

  // Helper function for rank in the leaderboard
  Column rank({
    required double radius,
    required double height,
    required String image,
    required String name,
    required String point,
    required BuildContext context,
  }) {
    ImageProvider<Object> profile;

    String currName = Provider.of<UserProvider>(context).getCurrUser().username;
    if (name == currName) {
      profile = Provider.of<UserProvider>(context).getProfileOfCurrUser();
    } else {
      profile = AssetImage(image);
    }
    return Column(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: profile,
        ),
        SizedBox(
          height: height,
        ),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: height,
        ),
        Container(
          height: 20,
          width: 60,
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(50)),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              const Icon(
                CupertinoIcons.smiley,
                color: Color.fromARGB(255, 255, 187, 0),
                size: 16,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                point,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // Helper to show accept dialog
  void _showAcceptDialog(BuildContext context, Task task, TaskProvider taskProvider, User currentUser) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to accept this toDo?"),
          content: const Text("This is a non-reversible action."),
          actions: [
            TextButton(
              onPressed: () {

                taskProvider.acceptTask(task, currentUser.username);
                Navigator.pop(context);

                //show message
                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                  content: Text('accepted ToDo has been moved to My ToDos'),
                                   backgroundColor: const Color.fromARGB(255, 3, 125, 3),
                                ));
              },
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 6, 201, 64)),
              child: const Text('Yes, accept'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              child: const Text("No, don't accept"),
            ),
          ],
        );
      },
    );
  }

  // Helper to show decline dialog
  void _showDeclineDialog(BuildContext context, Task task, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to decline this toDo?"),
          content: const Text("This is a non-reversible action."),
          actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showReasoningDialog(context, task, taskProvider);
                  },
                  style: TextButton.styleFrom(
                    
                      foregroundColor: Colors.white, backgroundColor: Colors.red),
                  child: const Text('Yes, really decline'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green),
                  child: const Text("No, don't"),
                ),
              ],
        );
      },
    );
  }

  // Helper to show reasoning dialog
  void _showReasoningDialog(BuildContext context, Task task, TaskProvider taskProvider) {
    TextEditingController reasoningController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: const Text("Provide Reasoning"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Please provide a reason for declining this toDo."),
              const SizedBox(height: 8),
              TextField(
                controller: reasoningController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your reason here",
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String reasoning = reasoningController.text;
                if (reasoning.isNotEmpty) {
                  taskProvider.declineTask(task);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Reasoning cannot be empty!"),
                      backgroundColor: Color.fromARGB(240, 255, 8, 4),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green),
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
