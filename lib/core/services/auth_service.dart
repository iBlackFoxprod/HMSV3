// lib/core/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hmsv3/core/models/user_model.dart';
import 'package:hmsv3/core/enums/user_role_enum.dart'; // Ensure this path is correct

class AuthService {
  final fb_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthService(this._firebaseAuth, this._firestore);

  // Stream to listen to authentication state changes
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) {
        return null;
      }
      // Fetch user details from Firestore
      final userDoc = await _firestore.collection('users').doc(fbUser.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        // This case might happen if user exists in Auth but not Firestore (e.g., direct creation via Firebase console)
        // Or if registration didn't complete Firestore write. Handle as appropriate.
        // For now, return a basic UserModel from Auth data.
        return UserModel(uid: fbUser.uid, email: fbUser.email, displayName: fbUser.displayName);
      }
    });
  }

  // Get current Firebase user
  fb_auth.User? get currentUser => _firebaseAuth.currentUser;

  // Sign Up with Email and Password
  Future<UserModel?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = userCredential.user;
      if (fbUser != null) {
        // Update display name in Firebase Auth
        await fbUser.updateDisplayName('$firstName $lastName');

        // Create user document in Firestore
        final newUser = UserModel(
          uid: fbUser.uid,
          email: fbUser.email,
          displayName: '$firstName $lastName',
          role: role,
        );
        await _firestore.collection('users').doc(fbUser.uid).set(newUser.toFirestore());
        return newUser;
      }
      return null;
    } on fb_auth.FirebaseAuthException catch (e) {
      print('FirebaseAuthException on SignUp: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('Error on SignUp: $e');
      throw Exception('An unknown error occurred during sign up.');
    }
  }

  // Sign In with Email and Password
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = userCredential.user;
      if (fbUser != null) {
        final userDoc = await _firestore.collection('users').doc(fbUser.uid).get();
        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc as DocumentSnapshot<Map<String, dynamic>>);
        }
        // If user exists in auth but not in firestore, create a basic user model
        return UserModel(
          uid: fbUser.uid,
          email: fbUser.email,
          displayName: fbUser.displayName,
          role: UserRole.patient, // Default role if not found in Firestore
        );
      }
      return null;
    } on fb_auth.FirebaseAuthException catch (e) {
      print('FirebaseAuthException on SignIn: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('Error on SignIn: $e');
      throw Exception('An unknown error occurred during sign in.');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error on SignOut: $e');
      throw Exception('Error signing out.');
    }
  }

  // (Optional) Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on fb_auth.FirebaseAuthException catch (e) {
      print('FirebaseAuthException on PasswordReset: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('Error on PasswordReset: $e');
      throw Exception('An unknown error occurred.');
    }
  }

  // (Optional) Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}