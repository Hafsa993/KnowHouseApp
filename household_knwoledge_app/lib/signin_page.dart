// lib/pages/sign_in_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // Aliased import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:household_knwoledge_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:household_knwoledge_app/models/user_provider.dart';

//very primitive user sign in to see if it works

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool isRegisterMode = false;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> _handleSubmit() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (isRegisterMode) {
      final username = _usernameController.text.trim();
      if (username.isEmpty) {
        setState(() {
          errorMessage = 'Please enter a username.';
          isLoading = false;
        });
        return;
      }
      try {
        auth.UserCredential cred = await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Store user info in Firestore first 
        // User can join or create family later
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'familyId': null,
          'joinedAt': FieldValue.serverTimestamp(),
          'rankingPoints': 0,
          'preferences': [],
          'contributions': {'Cleaning': 0, 'Gardening': 0, 'Cooking': 0, "Shopping": 0, "Planning" : 0,"Care" : 0,"Maintenance" : 0,"Other" : 0},
          'role': 'Member',
          'profilepath': 'lib/assets/f.jpeg',
        });

        // Load current user into provider
        await userProvider.loadCurrentUser();

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() {
          errorMessage = e is auth.FirebaseAuthException
              ? e.message ?? "Unknown error occurred."
              : e.toString();
          isLoading = false;
     });
      }
    } else {
      // Sign-in existing user
      try {
        await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, password: password);
        await userProvider.loadCurrentUser();
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = isRegisterMode ? 'Register' : 'Sign In';

    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 211, 239, 247),
      appBar: AppBar(title: Text(title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 60,),
          Center(child: Text("Sign In here", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),)),
          SizedBox(height: 80,),
          Center(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (errorMessage.isNotEmpty)
                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      if (isRegisterMode)
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(labelText: 'Username'),
                        ),
                      SizedBox(height: 20),
                      if (isLoading)
                        CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _handleSubmit,
                          child: Text(title),
                        ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isRegisterMode = !isRegisterMode;
                          });
                        },
                        child: Text(isRegisterMode
                            ? 'Already have an account? Sign in here.'
                            : 'Don\'t have an account? Register now.'
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
