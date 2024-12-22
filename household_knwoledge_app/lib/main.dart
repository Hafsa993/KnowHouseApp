import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:household_knwoledge_app/auth_wrapper.dart';
import 'package:household_knwoledge_app/models/permissions_provider.dart';
import 'package:household_knwoledge_app/models/user_provider.dart';
import 'package:provider/provider.dart';
import 'models/task_provider.dart';
import 'models/task_descriptions_provider.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:household_knwoledge_app/signin_page.dart';

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
        ChangeNotifierProvider(create: (_) => PermissionsProvider()),
      ],
      child: const HouseholdApp(),
    ),
  );
}

class HouseholdApp extends StatelessWidget {
  const HouseholdApp({super.key});

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
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/sign_in': (context) => SignInPage(),
        '/home': (context) => HomeScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  }
}
