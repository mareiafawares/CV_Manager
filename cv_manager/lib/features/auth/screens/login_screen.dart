import 'package:cv_manager/services/firebase/auth_service.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/common_widgets/custom_text_field.dart';
import '../../../core/common_widgets/social_auth_button.dart';
import '../../../core/common_widgets/wave_clipper.dart';

import 'package:cv_manager/services/auth_service.dart'; 
import 'signup_screen.dart'; 

import 'home.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

 
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: MyWaveClipper(),
                  child: Container(
                    height: screenHeight * 0.3,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.darkBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.description_rounded, size: 80, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const Text("Sign in to continue", style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
                  
                  const SizedBox(height: 30),

                  _buildLabel("Email Address"),
                  CustomTextField(
                    hint: "example@mail.com", 
                    icon: Icons.email_outlined,
                    controller: _emailController,
                  ),
                  
                  const SizedBox(height: 20),

                  _buildLabel("Password"),
                  CustomTextField(
                    hint: "••••••••", 
                    icon: Icons.lock_outline, 
                    isPassword: true,
                    controller: _passwordController,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) => setState(() => _rememberMe = value!),
                            activeColor: AppColors.primaryBlue,
                          ),
                          const Text("Remember me", style: TextStyle(color: AppColors.textGrey)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password?", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        var user = await _authService.signIn(
                          _emailController.text.trim(), 
                          _passwordController.text.trim()
                        );

                        if (user != null) {
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login Failed. Check your data.")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                      ),
                      child: const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Center(child: Text("OR CONTINUE WITH", style: TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: SocialAuthButton(
                          label: "Google", 
                          icon: Icons.g_mobiledata, 
                          iconColor: Colors.red, 
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: SocialAuthButton(
                          label: "GitHub", 
                          icon: Icons.terminal, 
                          iconColor: Colors.black, 
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: AppColors.textGrey)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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

 
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        label, 
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)
      ),
    );
  }
}