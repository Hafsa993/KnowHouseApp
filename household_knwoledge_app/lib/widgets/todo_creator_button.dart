
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/widgets/todo_creation.dart';

class ToDoCreator extends StatelessWidget {
  const ToDoCreator({super.key});

  
  @override
  Widget build(BuildContext context) {
    return   Padding(
        padding: const EdgeInsets.fromLTRB(16.0,8.0,16.0,16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: ToDoForm(),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 21, 208, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0), // Rounded corners
              ),
            ),
            child: const Text(
              'Add ToDo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      );
  }
}      