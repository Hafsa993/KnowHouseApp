import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:household_knwoledge_app/providers/task_descriptions_provider.dart';
import './change_task_descriptor_screen.dart';
import 'package:provider/provider.dart';
// This screen displays the description of an instruction, accessed through instructions tab

class TaskDescriptionScreen extends StatefulWidget{
  const TaskDescriptionScreen({super.key, required this.task});
  final TaskDescriptor task;

  @override
  State<TaskDescriptionScreen> createState() => _TaskDescriptionScreenState();
}

class _TaskDescriptionScreenState extends State<TaskDescriptionScreen> {
  bool? isDeleted = false;
  late TaskDescriptor temptask;
  @override
  void initState() {
    super.initState();
    temptask = widget.task;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
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
                Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Icon(widget.task.icon, color: categoryColor(widget.task.category),),
                  SizedBox(width: 10),
                  Text(widget.task.title, style: TextStyle(fontSize: 20),),
                ],
                ),
                SizedBox(height: 35,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text('Category:', style: TextStyle(fontSize: 25),)),
                  SizedBox(width: 15,),
                  Flexible(
                    child: Chip(
                      label: Text(widget.task.category, style: TextStyle( color: categoryColor(widget.task.category)),), 
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                  )
                ],
                            ),
                            SizedBox(height:20,),
                            Divider(),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                //decoration: BoxDecoration(border: Border.symmetric()),
                                children: [Text(widget.task.instructions, style: TextStyle(fontSize: 18),)],
                              ),
                            ),
                            ]),
              ))),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChangeTaskDescriptorScreen(task: widget.task),
                                            ),
                                          ).then((val) {
                                            if (val != null) {
                                              setState(() {
                                                temptask = val;
                                              });
                                            }
                                          });
                                        },
                                        icon: const Icon(Icons.edit, color: Colors.white),
                                        label: const Text('Edit',style : TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          isDeleted = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Are you sure you want to delete this instruction?"),
                                                content: const Text("This is a non-reversible action."),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context, true);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: Colors.white,
                                                      backgroundColor: Colors.red,
                                                    ),
                                                    child: const Text('Yes, really delete'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: Colors.white,
                                                      backgroundColor: Colors.grey,
                                                    ),
                                                    child: const Text("No, don't delete"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          if (isDeleted == true) {
                                            if (context.mounted) Provider.of<TaskDescriptorProvider>(context, listen: false).removeTaskDescriptor(widget.task.id!);
                                            if (context.mounted) Navigator.of(context).pop();
                                          }
                                        },
                                        icon: const Icon(Icons.delete, color: Colors.white),
                                        label: const Text('Delete',style : TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
    );
  }
}

