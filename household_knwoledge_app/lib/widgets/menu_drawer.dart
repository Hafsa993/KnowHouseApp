import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/ranking_screen.dart';
import '../screens/home_screen.dart';
import '../screens/todo_list_screen.dart';
import '../screens/my_tasks_screen.dart';
import '../screens/tasks_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/options_screen.dart';
import 'package:household_knwoledge_app/models/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    User currUser = userProvider.getCurrUser();

    return Drawer(
      //backgroundColor: Color.fromARGB(255, 211, 239, 247),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                DrawerHeader( 
                  decoration: BoxDecoration(
                    //color: Colors.blue, 
                    gradient: LinearGradient(
                      //stops: [1, 0.5],
                      begin: Alignment.bottomCenter, 
                      end: Alignment.topCenter, 
                      stops: [0.2, 0.5],
                      colors: [const Color.fromARGB(255, 230, 236, 243), const Color.fromARGB(255, 240, 240, 240)],
                      //colors: [Theme.of(context).primaryColorLight, const Color.fromARGB(255, 240, 240, 240)],
                    ),
                  ),
                  child: 
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
                      },
                      child: Stack(
                    children: [
                      Positioned(
                        top:20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                                radius: 50,
                                backgroundImage: userProvider.getProfileOfCurrUser(),
                              ),
                            
                            SizedBox(width: 10,),
                            Column(children: [
                            SizedBox(height: 20,),  
                            Text(currUser.username, style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 24)),
                            Text('${currUser.points} points', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18)),
                            ],)
                            
                          ],
                        ),
                      )
                    ],
                  ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                      Icons.home,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30,
                    ),
                  title: const Text('Home', style: TextStyle(fontSize: 24,),),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                  },
                  minVerticalPadding: 20,
                ),
                ListTile(
                  leading: const Icon(
                      Icons.checklist_rounded,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30,
                    ),
                  title: const Text('My ToDos', style: TextStyle(fontSize: 24,),),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MyTasksScreen()));
                  },
                  minVerticalPadding: 20,
                ),
                ListTile(
                  leading: const Icon(
                      Icons.maps_home_work_outlined,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30,
                    ),
                  title: const Text('House ToDos', style: TextStyle(fontSize: 24,),),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ToDoListScreen()));
                  },
                  minVerticalPadding: 20,
                ),
                ListTile(
                  leading: const Icon(
                      CupertinoIcons.book_circle_fill,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30,
                    ),
                  title: const Text('Instructions', style: TextStyle(fontSize: 24,),),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TasksScreen()));
                  },
                  minVerticalPadding: 20,
                ),
                ListTile(
                  leading: const Icon(
                      CupertinoIcons.calendar,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30,
                    ),
                  title: const Text('Calendar', style: TextStyle(fontSize: 24,),),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CalendarScreen()));
                  },
                  minVerticalPadding: 20,
                ),
                ListTile(
                  leading: const Icon(
                      CupertinoIcons.chart_bar_alt_fill,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30,
                    ),
                  title: const Text('Ranking List', style: TextStyle(fontSize: 24,),),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  RankingScreen()));
                  },
                  minVerticalPadding: 20,
                ),
                SizedBox(height: 20,),
                Divider(indent: 20, endIndent: 20, color: const Color.fromARGB(255, 83, 115, 140)),
                /* // profile as a menu tab 
                ListTile(
                  leading: const Icon(
                      CupertinoIcons.person_crop_circle,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30,
                      size: 30,
                    ),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
                  },
                ), */
                // align needed?
                ListTile(
                  leading: const Icon(
                      CupertinoIcons.gear_solid,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 30,
                    ),
                  title: const Text('Options', style: TextStyle(fontSize: 24,),),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OptionsScreen()));
                  },
                 // minVerticalPadding: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
