import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'copy_button.dart';

class UserInfoWidget extends StatelessWidget {
  final User user;
  final VoidCallback onCopyFamilyId;
  
  const UserInfoWidget({super.key, 
    required this.user,
    required this.onCopyFamilyId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          user.username,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildPointsChip(user.points),
        const SizedBox(height: 4),
        Text(
          'Role: ${user.role}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        _buildFamilyIdRow(context),
      ],
    );
  }
  
  Widget _buildPointsChip(int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Text(
        'Points: $points',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 32, 129, 35),
        ),
      ),
    );
  }
  
  Widget _buildFamilyIdRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Family ID: ${user.familyId ?? "No Family"}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        if (user.familyId?.isNotEmpty == true) ...[
          const SizedBox(width: 8),
          CopyButton(onTap: onCopyFamilyId),
        ],
      ],
    );
  }
}
