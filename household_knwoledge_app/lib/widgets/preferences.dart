import 'package:flutter/material.dart';
import '../models/task_descriptions_model.dart';

class PreferencesWidget extends StatelessWidget {
  final List<String> preferences;
  
  const PreferencesWidget({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Preferred Categories:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (preferences.isEmpty)
          _buildEmptyState()
        else
          _buildPreferenceChips(),
      ],
    );
  }
  
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: const Text(
        "No Preferred Categories",
        style: TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
  
  Widget _buildPreferenceChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: preferences.map((category) => Chip(
        label: Text(
          category,
          style: TextStyle(
            color: categoryColor(category),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: categoryColor(category).withValues(alpha: 0.1),
        side: BorderSide(
          color: categoryColor(category).withValues(alpha: 0.3),
        ),
      )).toList(),
    );
  }
}