import 'package:cv_manager/services/firebase/auth_service.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/common_widgets/custom_text_field.dart';
import '../../../core/common_widgets/wave_clipper.dart';

import 'package:cv_manager/services/auth_service.dart';

import 'home.dart'; 

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(screenHeight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildLabel("Full Name"),
                  CustomTextField(hint: "Maria Fawares", icon: Icons.person_outline, controller: _nameController),
                  
                  const SizedBox(height: 15),
                  _buildLabel("Email Address"),
                  CustomTextField(hint: "example@mail.com", icon: Icons.email_outlined, controller: _emailController),
                  
                  const SizedBox(height: 15),
                  _buildLabel("Password"),
                  CustomTextField(hint: "••••••••", icon: Icons.lock_outline, isPassword: true, controller: _passwordController),
                  
                  const SizedBox(height: 15),
                  _buildLabel("Confirm Password"),
                  CustomTextField(hint: "••••••••", icon: Icons.lock_reset_outlined, isPassword: true, controller: _confirmPasswordController),

                  const SizedBox(height: 30),

                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        
var user = await _authService.signUp(
  _emailController.text.trim(), 
  _passwordController.text.trim(),
  _nameController.text.trim(), 
);

                       
                        if (user != null) {
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          }
                        } else {
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Registration Failed")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Sign Up", 
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double height) {
    return ClipPath(
      clipper: MyWaveClipper(),
      child: Container(
        height: height * 0.22,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.primaryBlue, AppColors.darkBlue]),
        ),
        child: const Center(
          child: Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 15)),
    );
  }
}