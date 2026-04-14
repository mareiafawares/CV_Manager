import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  
  final String? Function(String?)? validator; 

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.validator, 
  });

  @override
  Widget build(BuildContext context) {
    
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}