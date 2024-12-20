import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:household_knwoledge_app/models/task_model.dart';
import 'package:intl/intl.dart';
// This screen displays the description of an instruction, accessed through instructions tab

class TodoShowScreen extends StatefulWidget{
  const TodoShowScreen({super.key, required this.task});
  final Task task;

  @override
  State<TodoShowScreen> createState() => _TodoShowScreenState();
}

class _TodoShowScreenState extends State<TodoShowScreen> {

  bool? isDeleted = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        //title: const Text('               ToDo',textAlign: TextAlign.center,style: TextStyle(fontSize: 25) ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            Expanded(child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                SizedBox(height: 15,),
                Flexible(child: Text(widget.task.title, style: TextStyle(fontSize: 35),)),
                SizedBox(height: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text('Category:', style: TextStyle(fontSize: 25, color: const Color.fromARGB(255, 37, 37, 37)),)),
                  SizedBox(width: 15,),
                  Flexible(
                    child: Chip(
                      label: Text(widget.task.category, style: TextStyle( color: categoryColor(widget.task.category)),), 
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                  )
                ],
                            ),
                            SizedBox(height:20,),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Due: ${DateFormat('dd-MM-yyyy HH:mm').format(widget.task.deadline)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widget.task.deadline.difference(DateTime.now()).inHours < 24
                                          ? Colors.red // Red if due in less than 24 hours
                                          : Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Difficulty: ${widget.task.difficulty}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Reward: ${widget.task.rewardPoints}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20 ,),
                            Divider(),
                             SizedBox(height: 10 ,),
                            Container(decoration: BoxDecoration(border: Border.symmetric()),child: Text(widget.task.description, style: TextStyle(fontSize: 18),),)
                            ]),
              ))),
          ],
        ),
      ),   
    );
  }

   /* _showDeleteDialog(BuildContext context, TaskDescriptor descriptor, TaskDescriptorProvider taskDescriptorProvider) {
    //bool val = false;
    
    //print(val);
    //return val;
  }*/
}

