// lib/widgets/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:household_knwoledge_app/models/user_provider.dart';
import 'package:household_knwoledge_app/screens/home_screen.dart';
import 'package:household_knwoledge_app/signin_page.dart';

//should make it so that user signs in or logs in only after download and later no 
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // User is signed in so load
          userProvider.loadCurrentUser(); 
          return HomeScreen();
        } else {
          // User is not signed in
          return SignInPage();
        }
      },
    );
  }
}
