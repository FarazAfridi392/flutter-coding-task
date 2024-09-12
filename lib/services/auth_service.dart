import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_task/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In method
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          e.code, e.message ?? 'An error occurred during sign-in.');
    } catch (e) {
      throw AuthException(
          'unknown', 'An unknown error occurred during sign-in.');
    }
  }

  // Sign Up method
  Future<User?> signUpWithEmail(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      // Add user to Firestore collection
      if (user != null) {
        print('hello');
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'createdAt': Timestamp.now(),
          // Add any other user information you want to store
        });
        print('bye');

        // Navigate to HomeScreen
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          e.code, e.message ?? 'An error occurred during sign-up.');
    } catch (e) {
      throw AuthException('$e', 'An unknown error occurred during sign-up.');
    }
  }

  // Sign Out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('sign_out_error', 'Failed to sign out.');
    }
  }

  // Auth State Changes Stream (e.g. to listen to sign-in/sign-out)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

// Custom exception class for handling Auth errors
class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() {
    return 'AuthException: $code - $message';
  }
}
