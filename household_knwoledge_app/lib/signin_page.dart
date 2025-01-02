// lib/pages/sign_in_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // Aliased import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:household_knwoledge_app/screens/home_screen.dart';
import 'package:household_knwoledge_app/widgets/password_reset.dart';
import 'package:provider/provider.dart';
import 'package:household_knwoledge_app/providers/user_provider.dart';
import 'package:form_field_validator/form_field_validator.dart';


//very primitive user sign in to see if it works

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool isRegisterMode = false;
  bool isLoading = false;
  String errorMessage = '';

  bool _validateInputs() {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Email and password cannot be empty.';
        isLoading = false;
      });
      return false;
    }

    if (isRegisterMode && _usernameController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please enter a username.';
        isLoading = false;
      });
      return false;
    }

    return true;
  }

  void _handleFirebaseAuthError(auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'This email is already in use.';
        break;
      case 'weak-password':
        errorMessage = 'Password should be at least 6 characters.';
        break;
      case 'user-not-found':
        errorMessage = 'No user found with this email.';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password.';
        break;
      default:
        errorMessage = e.message ?? "Unknown error occurred.";
    }
  }

  Future<void> _handleSigninSubmit() async {
    if (!_validateInputs()) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (isRegisterMode) {
        auth.UserCredential cred = await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
         
        //for testing purposes justs fam und so simple
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'familyId': "h",
          'joinedAt': FieldValue.serverTimestamp(),
          'rankingPoints': 0,
          'preferences': [],
          'contributions': {
            'Cleaning': 0,
            'Gardening': 0,
            'Cooking': 0,
            'Shopping': 0,
            'Planning': 0,
            'Care': 0,
            'Maintenance': 0,
            'Other': 0,
          },
          'role': 'Member',
          'profilepath': 'lib/assets/f.jpeg',
        });

        await userProvider.loadCurrentUser();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));

      } else {

        await auth.FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        await userProvider.loadCurrentUser();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }

    } catch (e) {

      setState(() {
        if (e is auth.FirebaseAuthException) {
          _handleFirebaseAuthError(e);
        } else {
          errorMessage = e.toString();
        }
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = isRegisterMode ? 'Register' : 'Sign In';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 211, 239, 247),
        appBar: AppBar(title: Text(title)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: Column(
              children: [
                Text(
                  isRegisterMode ? 'Register here' : 'Sign in here',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Email is required'),
                    EmailValidator(errorText: 'Invalid email format'),
                  ]).call, 
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                   validator: MultiValidator([
                    RequiredValidator(errorText: 'Password is required'),
                    MinLengthValidator(6, errorText: 'Password must be at least 6 characters'),
                  ]).call,
                ),
                if (isRegisterMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _handleSigninSubmit,
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
                      : 'Don\'t have an account? Register now.'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PasswordResetPage()),
                    );
                  },
                  child: const Text('Forgot Password? click here to reset your Password'),
                ), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
