import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/user_provider.dart';
import '../screens/preference_screen.dart';
import '../screens/home_screen.dart';
import '../models/task_descriptions_model.dart';

class FamilySelectionScreen extends StatefulWidget {
  const FamilySelectionScreen({super.key});

  @override
  State<FamilySelectionScreen> createState() => _FamilySelectionScreenState();
}

class _FamilySelectionScreenState extends State<FamilySelectionScreen> {
  final _familyCodeController = TextEditingController();
  final _familyNameController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';
  
  @override
  void dispose() {
    _familyCodeController.dispose();
    _familyNameController.dispose();
    super.dispose();
  }

  String _generateSecureCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    
    // Combine and hash
    final combined = '$timestamp$random';
    final hash = combined.hashCode.abs();
    
    // Convert to 6-letter code
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String result = '';
    int temp = hash;
    
    for (int i = 0; i < 6; i++) {
      result = chars[temp % 26] + result;
      temp = temp ~/ 26;
    }
    
    return result;
  }


  Future<void> _createNewFamily() async {
    if (_familyNameController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please enter a family name';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;
      
      if (currentUser == null) {
        throw Exception('No current user found');
      }
     
      // Generate unique family code
      final familyCode = _generateSecureCode();

      // Update user with family ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'familyId': familyCode,
        'role': 'Admin', // Creator becomes admin
      });

      // load local user
      await userProvider.loadCurrentUser();

      if (!mounted) return;
      
      // Show success and go to preferences
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Family created! Your family code is: $familyCode'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
      
      _goToPreferences();
      
    } catch (e) {
      setState(() {
        errorMessage = 'Error creating family: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _joinFamily() async {
    
    final familyCode = _familyCodeController.text.trim().toUpperCase();
    
    if (familyCode.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a family code';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;
      
      if (currentUser == null) {
        throw Exception('No current user found');
      }
      // Check if family code exists
      final existingUsers = await FirebaseFirestore.instance
        .collection('users')
        .where('familyId', isEqualTo: familyCode)
        .limit(1)
        .get();

      if (existingUsers.docs.isEmpty) {
        setState(() {
          errorMessage = 'Family code "$familyCode" not found. Please check and try again.';
          isLoading = false;
        });
        return;
      }
      // Update user with family ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'familyId': familyCode,
        'role': 'Member', // Default role
      });

      // load local user
      await userProvider.loadCurrentUser();

      if (!mounted) return;
      // Show success and go to preferences
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully joined the family!'),
          backgroundColor: Colors.green,
        ),
      );
      
      _goToPreferences();
      
    } catch (e) {
      setState(() {
        errorMessage = 'Error joining family: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _goToPreferences() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PreferencesScreen(
          allCategories: categories,
          initialSelected: [],
          onSave: (prefs) async {
            await userProvider.setPreferencesForUser(prefs);

            navigator.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 211, 239, 247),
      appBar: AppBar(
        title: const Text('Join or Create Family'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Family Setup',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Join an existing family or create a new one to get started.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            if (errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Join Family Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.group_add, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Join Existing Family',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Enter the 6-character family code you received',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _familyCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Family Code',
                        hintText: 'e.g. ABC123',
                        prefixIcon: Icon(Icons.vpn_key),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _joinFamily,
                        child: const Text('Join Family'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Divider
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            
            const SizedBox(height: 20),

            // Create Family Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.add_home, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text(
                          'Create New Family',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Start a new family and invite others to join',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _familyNameController,
                      decoration: const InputDecoration(
                        labelText: 'Family Name',
                        hintText: 'e.g. The Smith Family',
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _createNewFamily,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Create Family'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            if (isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing...'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}