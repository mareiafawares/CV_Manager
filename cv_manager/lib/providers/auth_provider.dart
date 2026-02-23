import 'package:cv_manager/models/user_model.dart';
import 'package:cv_manager/services/firebase/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  
  
  bool _isLoading = false; 

 
  bool get isLoading => _isLoading; 

  User? get user => _user;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  
  Future<bool> signUp(String email, String password, String name) async {
    _setLoading(true); 
    try {
      UserModel newUser = UserModel(
        uid: "", 
        name: name, 
        email: email, 
        createdAt: DateTime.now(),
      );

      User? user = await _authService.signUp(
        email: email, 
        password: password, 
        user: newUser,
      );
      
      _user = user;
      _setLoading(false); 
      return user != null;
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      User? user = await _authService.signIn(email, password);
      _user = user;
      _setLoading(false);
      return user != null;
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

 
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  Future<void> logout() async {
  await _authService.signOut();
  _user = null;
  notifyListeners();
}
}