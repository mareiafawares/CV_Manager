import 'package:cv_manager/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; 
  
Future<UserModel?> getCurrentUserData(dynamic _auth) async {
  try {
    String uid = _auth.currentUser!.uid;
    var _firestore;
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
  } catch (e) {
    print("Error fetching user: $e");
  }
  return null;
}

Future<void> resetPassword(String email) async {
  try {
 
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } catch (e) {
    
    print("Error in resetPassword: $e");
    rethrow; 
  }
}
  
  

Future<User?> signUp({required UserModel user, required String password}) async {
  try {
    
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: user.email, password: password);
    
    User? firebaseUser = result.user;

  
    if (firebaseUser != null) {
      
      await _firestore.collection('users').doc(firebaseUser.uid).set(user.toMap());
    }
    return firebaseUser;
  } catch (e) {
    print("SignUp Error: $e");
    return null;
  }
}
  
 Future<User?> signIn(String email, String password) async {
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  } on FirebaseAuthException catch (e) {
    
    print("Error Code: ${e.code}");
    return null;
  }
}

  Future<void> signOut() async {}
}
