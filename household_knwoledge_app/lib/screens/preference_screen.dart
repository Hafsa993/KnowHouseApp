import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  final List<String> allCategories;
  final List<String> initialSelected;
  final Future Function(List<String>) onSave;

  const PreferencesScreen({
    super.key, 
    required this.allCategories,
    required this.initialSelected,
    required this.onSave,
  });

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = List<String>.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Choose Your Preferences'),
      ),

      body: Column(
        children: [
          SizedBox(height: 20),

          Expanded(
            child: ListView.separated( 
              itemCount: widget.allCategories.length,

              separatorBuilder: (context, index) => const Divider(
                color: Color.fromARGB(255, 84, 84, 84),
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
              ),

              itemBuilder: (context, index) {
                final cat = widget.allCategories[index];
                
                return CheckboxListTile(
                  title: Text(cat, style: const TextStyle(
                      fontSize: 22
                    ),),

                  value: selected.contains(cat),

                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selected.add(cat);
                      } else {
                        selected.remove(cat);
                      }
                    });
                  },
                );
              },
            ),
          ),

          // Button to select preferences
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  debugPrint('Selected Preferences: $selected');
                  widget.onSave(selected);
                  debugPrint('Completed saving preferences.');
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 21, 208, 255),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),

                child: Text(
                    'Save ${selected.length} Preferences',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}