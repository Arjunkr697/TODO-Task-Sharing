import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Register with email and password
  Future<UserCredential> register(String email, String password, String name) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Create user document in Firestore
    await _firestore.collection('users').doc(result.user!.uid).set({
      'email': email,
      'name': name,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
    
    return result;
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}