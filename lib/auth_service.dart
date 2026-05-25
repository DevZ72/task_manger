import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to track authentication status changes across the app
  Stream<User?> get userStream => _auth.authStateChanges();

  // Week 5 Task 1 & 2: Cloud Registration Workflow
  Future<String?> registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = result.user;

      // Week 5 Task 3: Store explicit user profile parameters in Cloud Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name.trim(),
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return null; // Return null if successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return the exact error message from Firebase
    } catch (e) {
      return "An unexpected registration error occurred.";
    }
  }

  // Week 5 Task 2: Cloud Login Authentication Workflow
  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected login error occurred.";
    }
  }

  // Sign Out function
  Future<void> signOut() async {
    await _auth.signOut();
  }
}