import 'package:cv_manager/services/firebase/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cv_manager/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My CV Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacementNamed(context, '/login'); 
            },
          )
        ],
      ),
      body: const Center(
        child: Text("Welcome! Home Page is Ready", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}