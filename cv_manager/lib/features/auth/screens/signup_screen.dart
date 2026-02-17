import 'dart:ui';
import 'package:cv_manager/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../../../core/constants/app_colors.dart';
import '../../../core/common_widgets/custom_text_field.dart';
import 'package:cv_manager/services/firebase/auth_service.dart'; 
import 'home.dart'; 

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent.withOpacity(0.8) : Colors.green.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -50, left: -50, child: _buildDecorCircle(200, Colors.purpleAccent.withOpacity(0.15))),
            Positioned(bottom: -50, right: -50, child: _buildDecorCircle(250, Colors.cyanAccent.withOpacity(0.1))),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const Icon(Icons.person_add_rounded, size: 60, color: Colors.white),
                                const SizedBox(height: 10),
                                const Text(
                                  "Create Account",
                                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 25),
                                
                                CustomTextField(
                                  hint: "Full Name",
                                  icon: Icons.person_outline,
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return "Please enter your name";
                                    if (value.length < 3) return "Name too short";
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                
                                CustomTextField(
                                  hint: "Email Address",
                                  icon: Icons.email_outlined,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return "Email is required";
                                    if (!value.contains("@")) return "Invalid email format";
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                
                                CustomTextField(
                                  hint: "Password",
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return "Password is required";
                                    if (value.length < 6) return "Password must be 6+ chars";
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                
                                CustomTextField(
                                  hint: "Confirm Password",
                                  icon: Icons.lock_reset_outlined,
                                  isPassword: true,
                                  controller: _confirmPasswordController,
                                  validator: (value) {
                                    if (value != _passwordController.text) return "Passwords do not match";
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 30),
                                
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleSignUp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.cyanAccent.shade700,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                      elevation: 8,
                                    ),
                                    child: _isLoading 
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text("SIGN UP", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text.rich(
                                    TextSpan(
                                      text: "Already have an account? ",
                                      style: const TextStyle(color: Colors.white70),
                                      children: [
                                        TextSpan(
                                          text: "Login",
                                          style: TextStyle(color: Colors.cyanAccent.shade400, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        UserModel newUser = UserModel(
          uid: "", 
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          createdAt: DateTime.now(),
        );

        var user = await _authService.signUp(
          user: newUser, 
          password: _passwordController.text.trim(),
        );

        if (user != null && mounted) {
          _showSnackBar("Account created successfully!", isError: false);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(isDark: true)));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = "Registration Failed";
        if (e.code == 'email-already-in-use') {
          errorMessage = "This email is already registered.";
        } else if (e.code == 'weak-password') {
          errorMessage = "The password provided is too weak.";
        }
        _showSnackBar(errorMessage);
      } catch (e) {
        _showSnackBar("Something went wrong. Please try again.");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildDecorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}