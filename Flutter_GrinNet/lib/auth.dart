import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

/// Utility class to send information to Firebase
/// 
/// This code started from the following tutorial:
/// https://www.youtube.com/watch?v=rWamixHIKmQ&ab_channel=FlutterMapp

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> sendEmailVerificationLink() async {
    try {
      currentUser?.sendEmailVerification();
    }
    catch (e) {
      log(e.toString());
    }
  }

  // Authenticate user info for an existing account
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password,
    );
  }

  // Create a new user and add their credentials to the Firebase database
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  // Sign out the user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}