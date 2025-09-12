import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  final VoidCallback onTap;
  final ImageProvider? profileImage;
  
  const ProfilePictureWidget({super.key, 
    required this.onTap,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: profileImage,
          ),
          Positioned(
            bottom: -3,
            right: -3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.edit,
                size: 24,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
