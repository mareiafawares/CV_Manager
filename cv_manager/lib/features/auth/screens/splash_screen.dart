import 'package:cv_manager/services/wrapper/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
   Timer(const Duration(seconds: 3), () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const AuthWrapper()), 
  );
});
  }

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), 
      body: SizedBox(
        width: screenWidth, 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           
            Icon(
              Icons.contact_page_rounded,
              size: screenWidth * 0.25, 
              color: Colors.blueAccent,
            ),
            
            
            SizedBox(height: screenHeight * 0.05),

            
            SizedBox(
              width: screenWidth * 0.5,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.white10,
                color: Colors.blueAccent,
                minHeight: 4,
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

           
            const Text(
              "Programmed by:",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "MARIA FAWARES",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}