import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:household_knwoledge_app/screens/family_selection_screen.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/task_descriptions_provider.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:household_knwoledge_app/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TaskDescriptorProvider()),
      ],
      child: const HouseholdApp(),
    ),
  );
}

class HouseholdApp extends StatefulWidget {
  const HouseholdApp({super.key});

  @override
  State<HouseholdApp> createState() => _HouseholdAppState();
}

class _HouseholdAppState extends State<HouseholdApp> {
  bool _isLoggedIn = false;

  // Check login status on app start
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); 
  }

  // Check login status from SharedPreferences
  Future<void> _checkLoginStatus() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });

  }
  Future<Map<String, dynamic>?> _checkUserSetupStatus(BuildContext context) async {
  try {
    // Load current user first
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadCurrentUser();
    
    final currentUser = userProvider.currentUser;
    if (currentUser == null) {
      return null;
    }
    
    // Check if user has family
    final hasFamily = currentUser.familyId != null && 
                     currentUser.familyId!.isNotEmpty;
    
    debugPrint('User setup check:');
    debugPrint('  familyId: ${currentUser.familyId}');
    debugPrint('  hasFamily: $hasFamily');

    return {
      'hasFamily': hasFamily,
    };
    
  } catch (e) {
    debugPrint('Error checking user setup: $e');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Household Knowledge App',
      theme: ThemeData(
        fontFamily: GoogleFonts.robotoSlab().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 102, 163, 255),
          primary: const Color.fromARGB(255, 41, 141, 255),
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
          contrastLevel: 1
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasData || _isLoggedIn) {
            return FutureBuilder<Map<String, dynamic>?>(
              future: _checkUserSetupStatus(context),
              builder: (context, setupSnapshot) {
                if (setupSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (setupSnapshot.hasError || setupSnapshot.data == null) {
                  debugPrint('Setup check failed, redirecting to SignIn');
                  return const SignInPage();
                }

                final setupStatus = setupSnapshot.data!;

                //Check if user has family
                if (!setupStatus['hasFamily']) {
                  debugPrint('User has no family, redirecting to FamilySelection');
                  return const FamilySelectionScreen();
                } 
                //User has family, go to homescreen
                else {
                  debugPrint('User has family, redirecting to HomeScreen');
                  return const HomeScreen();
                }
              },
            );
          }
          
          return const SignInPage();
        },
      ),
    );
  }
}