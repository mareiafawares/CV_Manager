import 'package:cv_manager/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 
  Future<UserModel?> getCurrentUserData() async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
    return null;
  }

  
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error in resetPassword: $e");
      rethrow;
    }
  }

  
  Future<User?> signUp({
    required String email,
    required String password,
    UserModel? user, 
  }) async {
    try {
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? firebaseUser = result.user;

     
      if (firebaseUser != null && user != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'uid': firebaseUser.uid,
          'name': user.name,
          'email': user.email,
          'createdAt': user.createdAt ?? DateTime.now(),
        });
      }
      return firebaseUser;
    } catch (e) {
      print("Error in signUp: $e");
      rethrow;
    }
  }

 
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      
      print("Firebase Login Error Code: ${e.code}");
      rethrow; 
    } catch (e) {
      rethrow;
    }
  }

 
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error in signOut: $e");
      rethrow;
    }
  }
}