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
  double _pullDistance = 0.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -50,
            child: Container(
              width: size.width * 1.5,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.8,
                  colors: [
                    Colors.yellow.withOpacity(0.35),
                    Colors.white.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.article_rounded,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  "Programmer",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 20,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "MARIA AL-FAWARES",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: size.width / 2 - 1,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  if (_pullDistance < 120) _pullDistance += details.delta.dy;
                });
              },
              onVerticalDragEnd: (details) {
                if (_pullDistance > 80) {
                  _triggerNavigation();
                } else {
                  setState(() => _pullDistance = 0);
                }
              },
              child: Column(
                children: [
                  Container(
                    width: 3,
                    height: (size.height * 0.25) + _pullDistance,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      boxShadow: const [
                        BoxShadow(color: Colors.black, blurRadius: 2, spreadRadius: 1)
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey[800]!, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: const Icon(Icons.power_settings_new, color: Colors.yellow, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _triggerNavigation() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, anim, secAnim, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }
}