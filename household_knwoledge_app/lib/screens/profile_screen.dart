import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/signin_page.dart';
import 'package:household_knwoledge_app/widgets/actions_buttons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import '../widgets/menu_drawer.dart';
import '../widgets/profile_pic.dart';
import '../widgets/user_info.dart';
import '../widgets/preferences.dart';
import '../widgets/contributions_chart.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  // Pick image from Gallery or Camera
  Future<void> _pickImage(ImageSource source) async {
    User currUser = Provider.of<UserProvider>(context, listen: false).currentUser!;

    // Check permissions
    if (source == ImageSource.camera && !currUser.cameraPermissionEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text("Camera permission is disabled, enable in Options")),
      );
      return;
    }

    if (source == ImageSource.gallery && !currUser.galleryPermissionEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content:Text("Gallery permission is disabled, enable in Options")),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: source);
    if (!mounted) return; // check if widget is still mounted

    if (image != null) {

      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Uploading profile picture...")),
      );

      // Upload to Firebase
      final downloadUrl = await Provider.of<UserProvider>(context, listen: false)
          .uploadProfilePicture(image.path);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();

      if (downloadUrl != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture updated successfully!")),
        );
        setState(() {}); // Refresh UI
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text("Failed to upload profile picture.")),
        );
      }
    }
  }

  // Exit Button
  Future<void> _showExitConfirm(BuildContext parentContext) async {
  showDialog(
    context: parentContext,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("Are you sure you want to exit your account?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text("Logout"),
            onPressed: () async {
                await auth.FirebaseAuth.instance.signOut();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false); // Remove login status

                if (!mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => SignInPage()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showPasswordDialog(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    String? password;

    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        return AlertDialog(

          title: const Text('Confirm Account Deletion'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter your password to confirm account deletion:'),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                onSubmitted: (value) {
                  password = value;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                password = passwordController.text;
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Account', style: TextStyle(color: Colors.white)),
            ),

          ],
        );
      },
    );

    return password;
  }
  // Delete Account
  Future<void> _showDeleteConfirm(BuildContext parentContext) async {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Are you sure you want to delete your account?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text("Permanently Delete Account"),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog
                await _deleteUserAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

Future<void> _deleteUserAccount(BuildContext context) async {
  try {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Deleting account..."),
          ],
        ),
      ),
    );

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = auth.FirebaseAuth.instance.currentUser!.uid;

    // 1. Delete profile picture from Firebase Storage if Implemented
    /* if (currentUser.profilepath != null && currentUser.profilepath!.isNotEmpty) {
      try {
        await userProvider.deleteProfilePicture();
      } catch (e) {
        print('Error deleting profile picture: $e');
        // Continue even if profile picture deletion fails
      }
    } */

    // Re-authenticate with password
    final password = await _showPasswordDialog(context);
    if (password == null || password.isEmpty) {
      // User cancelled password entry
      return;
    }
    
    
    final credential = auth.EmailAuthProvider.credential(
      email: auth.FirebaseAuth.instance.currentUser!.email!,
      password: password, // You'll need to prompt user for their password
    );
    await auth.FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);

   // change user tasks (if any exist)
    final userTasks = await FirebaseFirestore.instance
        .collection('tasks')
        .where('assignedTo', isEqualTo: userId)
        .get();
    
    for (var doc in userTasks.docs) {
      await doc.reference.update({'assignedTo': null});
    }

    // Delete user document from Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .delete();

   

    // Clear local data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data
    userProvider.clearUser();


    // Delete Firebase Auth account (this must be last!)
    await auth.FirebaseAuth.instance.currentUser!.delete();

    // Close loading dialog
    if(context.mounted) { 
      Navigator.of(context).pop(); 
    }


    // Navigate to sign-in page on SUCCESS
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => SignInPage()),
        (route) => false,
      );
    }

    // Show success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
    } catch (e) {
      debugPrint('Error cleaning/deleting user account data: $e');

      // Close loading dialog on ERROR
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      String errorMessage = "Failed to delete account";
      
      if (e.toString().contains('requires-recent-login')) {
        errorMessage = "Please sign out and sign back in, then try deleting your account again.";
      } else if (e.toString().contains('network')) {
        errorMessage = "Network error. Please check your connection and try again.";
      }

      // Show error message
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  } 
  
    double sumOfContributions(BuildContext context){
      final userProvider = Provider.of<UserProvider>(context);
      if (userProvider.currentUser == null) return 0.0;
      User currentUser = userProvider.currentUser!;
      var sum = currentUser.contributions.values.fold<double>(
        0.0,
        (sum, value) => sum + value.toDouble(),
      );
      return sum;
    }

  // Show image picker dialog
  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick an image for your Profile"),
          actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                   try {
                    _pickImage(ImageSource.camera);
                  } on PlatformException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error picking image: $e")),
                    );
                  }          
                },
                child: const Text("Camera"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  try {
                    _pickImage(ImageSource.gallery);
                  } on PlatformException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error picking image: $e")),
                    );
                  }           
                },
                child: const Text("Gallery"),
              ),
          ],
        );
      },
    );
  }


  void _copyFamilyId(String familyId) {
    Clipboard.setData(ClipboardData(text: familyId));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Family ID "$familyId" copied to clipboard!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.currentUser == null) {
    // User was deleted or logged out, redirect to sign-in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => SignInPage()),
        (route) => false,
      );
    });
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
        ),
      );
    }
    User currentUser = userProvider.currentUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 224, 224),
        title: const Text('My Profile'),
      ),

      drawer: const MenuDrawer(),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile picture
                ProfilePictureWidget(
                  onTap: () => _showImageDialog(context),
                  profileImage: context.read<UserProvider>().getProfileOfCurrUser(),
                ),

                const SizedBox(height: 24),

                UserInfoWidget(
                  user: currentUser,
                  onCopyFamilyId: () => _copyFamilyId(currentUser.familyId!),
                ),

                const SizedBox(height: 32),

                PreferencesWidget(preferences: currentUser.preferences),

                const SizedBox(height: 32),

                ContributionsChartWidget(contributions: currentUser.contributions),

                const SizedBox(height: 32),

                ActionButtonsWidget(
                  onExitAccount: () => _showExitConfirm(context),
                  onDeleteAccount: () => _showDeleteConfirm(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
