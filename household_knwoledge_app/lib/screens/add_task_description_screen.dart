import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:household_knwoledge_app/models/task_descriptions_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/icon_picker.dart';

class AddTaskDescriptorScreen extends StatefulWidget {
  const AddTaskDescriptorScreen({super.key});

  @override
  _AddTaskDescriptorScreenState createState() => _AddTaskDescriptorScreenState();
}

class _AddTaskDescriptorScreenState extends State<AddTaskDescriptorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _categoryController = TextEditingController();
  IconData? _selectedIcon;
  String? _category;

  Future<void> _showIconPickerDialog() async {
    IconData? iconPicked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pick an icon',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: IconPicker(),
        );
      },
    );

    if (iconPicked != null) {
      debugPrint('Icon changed to $iconPicked');
      setState(() {
        _selectedIcon = iconPicked;
      });
    }
  }

  void _saveTaskDescriptor() {
    if (_formKey.currentState!.validate() && _selectedIcon != null) {
      final newDescriptor = TaskDescriptor(
        title: _titleController.text,
        instructions: _instructionsController.text,
        category: _category!,
        icon: _selectedIcon!,
      );

      Provider.of<TaskDescriptorProvider>(context, listen: false)
          .addTaskDescriptor(newDescriptor);

      Navigator.of(context).pop(); // Navigate back after saving
    } else if (_selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an icon for the task')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title: Text('Add New Instruction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Enter the title:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5,),
                TextFormField(
                  controller: _titleController,
                  
                  decoration: InputDecoration(
                    labelText: 'Title', 
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter the title of the instruction here', 
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                      color: const Color.fromARGB(255, 66, 67, 67),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 57, 58, 57),
                      width: 2,
                    ),
                  ),),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40,),
                Text('Enter the instruction description:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5,),
                TextFormField(
                  controller: _instructionsController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Instructions', 
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter instruction description here', 
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                      color: const Color.fromARGB(255, 66, 67, 67),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 57, 58, 57),
                      width: 2,
                    ),
                  ),),
                  maxLines: 10,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter instructions';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40,),
                /*
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ), */
                Text('Choose a category:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5,),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: _category,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      //child: Text(category),
                      child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: categoryColor(category),
                                  radius: 5,
                                ),
                                SizedBox(width: 8),
                                Text(category),
                              ],
                            ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue;
                      // Reset assigned user if category changes
                     
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                SizedBox(height: 16),
                Text(
                  'Select an Icon:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: _showIconPickerDialog,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: getFilling(),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Wrap(
        alignment: WrapAlignment.center,
        children: [Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton.icon(
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 21, 208, 255))),
                    onPressed: _saveTaskDescriptor,
                    label: Text('Save Instruction', style: TextStyle(fontSize: 20, color: Colors.white)),
                    icon: const Icon(Icons.add, size: 20, color: Colors.white,),
                  ),
        ),]
      ),
    );
  }
  Widget getFilling() {
    if (_selectedIcon == null) {
      return Text('Click here to pick an icon',style: TextStyle(color: Colors.grey),);
    } else {
      return Icon(_selectedIcon, size: 32);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}