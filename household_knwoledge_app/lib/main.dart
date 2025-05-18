import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/task_descriptions_provider.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:household_knwoledge_app/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

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
  bool _isLoggedIn = false; // Track login status

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status on app start
  }

  // Check login status from SharedPreferences
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
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
            return FutureBuilder(
              future: Provider.of<UserProvider>(context, listen: false).loadCurrentUser(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!mounted) return const SizedBox.shrink();
                return const HomeScreen();
              },
            );
          }
          return const SignInPage();
        },
      ),
    );
  }
}