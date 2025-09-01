import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:household_knwoledge_app/signin_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_descriptions_model.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import '../widgets/menu_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
//TODO: Make contributions show up correctly and be saved correctly
//TODO: make sure points everywhere connected to firebase so changes see
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
  if (!mounted) return; // <-- Add this check after await

  if (image != null) {
    await Provider.of<UserProvider>(context, listen: false).updateProfilePath(image.path);
    if (!mounted) return; // <-- Add this check after await
    setState(() {});
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
              try {
                await auth.FirebaseAuth.instance.signOut();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false); // Remove login status
                // Use parentContext, which is still valid
                if (!mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => SignInPage()),
                    (route) => false,
                  );
              } catch (e) {
                // TODO: Handle error
              }
            },
          ),
        ],
      );
    },
  );
}

  double sumOfContributions(BuildContext context){
    final userProvider = Provider.of<UserProvider>(context);
    User currentUser = userProvider.currentUser!;
    var sum = currentUser.contributions.values.fold<double>(
      0.0,
      (sum, value) => sum + value.toDouble(),
    );
    return sum;
  }
  // Pie Chart
  List<PieChartSectionData> _generatePieChartData(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    User currentUser = userProvider.currentUser!;
    final sum = currentUser.contributions.values.fold<double>(
      0.0,
      (sum, value) => sum + value.toDouble(),
    );

    return currentUser.contributions.entries.map((entry) {
      final percentage = (entry.value.toDouble() / sum) * 100.0;
      return PieChartSectionData(
        value: percentage,
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
                GestureDetector(
                  onTap: () => _showImageDialog(context),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: Provider.of<UserProvider>(context, listen: false).getProfileOfCurrUser(),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Username
                Text(
                  currentUser.username,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                // Points
                Text(
                  'Points: ${currentUser.points}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 32, 129, 35),
                  ),
                ),
                const SizedBox(height: 4),

                // Role
                Text(
                  'Role: ${currentUser.role}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Preferences
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Preferred Categories:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8,
                      children: currentUser.preferences.isEmpty ? [SizedBox(height: 30,),Center(child: Text("No Preferred Categories"))]:
                      currentUser.preferences
                          .map(
                            (task) => Chip(
                              label: Text(
                                task,
                                style: TextStyle(color: categoryColor(task),fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Pie Chart
                const Text(
                  'Contributions:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200,
                  child: 
                  sumOfContributions(context) == 0.0 ? Center(child: Text("No Contributions to the household made yet")) : 
                  PieChart(
                    PieChartData(
                      sections: _generatePieChartData(context),
                      centerSpaceRadius: 40,
                      sectionsSpace: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Exit account
                ElevatedButton(
                  onPressed: () => _showExitConfirm(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    "Exit Account",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
