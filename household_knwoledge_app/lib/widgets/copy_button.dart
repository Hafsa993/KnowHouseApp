import 'package:flutter/material.dart';

class CopyButton extends StatelessWidget {
  final VoidCallback onTap;
  
  const CopyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(
          Icons.copy,
          size: 16,
          color: Colors.blue,
        ),
      ),
    );
  }
}