import 'package:flutter/material.dart';
import '../models/task_descriptions_model.dart';
import 'package:fl_chart/fl_chart.dart';

class ContributionsChartWidget extends StatelessWidget {
  final Map<String, int> contributions;
  
  const ContributionsChartWidget({super.key, required this.contributions});

  @override
  Widget build(BuildContext context) {
    final hasContributions = _hasNonZeroContributions();
    
    return Column(
      children: [
        Text(
          'Contributions:',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: hasContributions 
            ? PieChart(PieChartData(
                sections: _generatePieChartData(),
                centerSpaceRadius: 40,
                sectionsSpace: 4,
              ))
            : _buildEmptyContributionsState(),
        ),
      ],
    );
  }
  
  bool _hasNonZeroContributions() {
    return contributions.values.any((value) => value > 0);
  }
  
  Widget _buildEmptyContributionsState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              "No Contributions Yet",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Complete tasks to see your contributions!",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<PieChartSectionData> _generatePieChartData() {
    final sum = contributions.values.fold<double>(0.0, (sum, value) => sum + value.toDouble());

    final nonZeroContributions = Map<String, int>.fromEntries(
      contributions.entries.where((entry) => entry.value > 0),
    );

    if (nonZeroContributions.isEmpty) {
      return []; // Return empty list if no contributions
    }

    return nonZeroContributions.entries.map((entry) {
        final percentage = sum == 0 ? 0.0 : (entry.value.toDouble() / sum) * 100.0;
        return PieChartSectionData(
          value: entry.value.toDouble(),
          title: '${entry.key} (${percentage.toInt()}%)',
          color: categoryColor(entry.key),
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList();
  }
}