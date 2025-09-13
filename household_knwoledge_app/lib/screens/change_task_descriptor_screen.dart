import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/models/task_descriptions_model.dart';
import 'package:household_knwoledge_app/providers/task_descriptions_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/icon_picker.dart';

class ChangeTaskDescriptorScreen extends StatefulWidget {
  const ChangeTaskDescriptorScreen({super.key, required this.task});
  final TaskDescriptor task;

  @override
  ChangeTaskDescriptorScreenState createState() => ChangeTaskDescriptorScreenState();
}

class ChangeTaskDescriptorScreenState extends State<ChangeTaskDescriptorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _categoryController = TextEditingController();
  IconData? _selectedIcon;
  String? _category;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.task.icon;
    _titleController.text = widget.task.title;
    _instructionsController.text = widget.task.instructions;
    _category = widget.task.category;
  }

  Future<void> _showIconPickerDialog() async {
    IconData? iconPicked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
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

  Future<void> _editTaskDescriptor() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an icon for the task')),
      );
      return;
    }

    if (widget.task.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Invalid task ID. Cannot save changes.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Saving changes...'),
          ],
        ),
      ),
    );

    try {
      await Provider.of<TaskDescriptorProvider>(context, listen: false)
          .editTaskDescriptor(
            widget.task.id!,
            _titleController.text.trim(),
            _instructionsController.text.trim(),
            _category!,
            _selectedIcon!,
          );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Instruction updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back
        Navigator.of(context).pop(widget.task);
      }

    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating instruction: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title: Text('Edit Instruction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Enter new title:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5,),
                TextFormField(
                  //initialValue: widget.task.title,
                  controller: _titleController,
        
                  decoration: InputDecoration(
                    labelText: 'Title', 
                    hintText: 'Enter new title of the instruction here', 
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
                const SizedBox(height: 40,),
                const Text('Enter new instruction description:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5,),
                TextFormField(
                  //initialValue: widget.task.instructions,
                  controller: _instructionsController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Instructions', 
                    hintText: 'Enter new instruction description here', 
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
                  maxLines: 11,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter instructions';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40,),
                Text('Choose a new category:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5,),
                DropdownButtonFormField<String>(
                  
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: _category,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: categoryColor(category),
                                  radius: 5,
                                ),
                                const SizedBox(width: 8),
                                Text(category),
                              ],
                            ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 16),
                Text(
                  'Select a new Icon:',
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
                  onPressed: _editTaskDescriptor,
                  child: Text('Done',style: TextStyle(fontSize: 25),),
                ),
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