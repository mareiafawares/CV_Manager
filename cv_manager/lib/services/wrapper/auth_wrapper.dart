import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cv_manager/features/auth/screens/login_screen.dart'; 
import 'package:cv_manager/features/auth/screens/home.dart'; 
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          return const HomeScreen();
        }
       
        else {
          return const LoginScreen();
        }
      },
    );
  }
}