import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthWrapper {
  static var _instance = FirebaseAuthWrapper._();

  static FirebaseAuthWrapper get get => _instance;

  @visibleForTesting
  static void set(FirebaseAuthWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = FirebaseAuthWrapper._();

  FirebaseAuthWrapper._();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Stream<User?> authStateChanges() => FirebaseAuth.instance.authStateChanges();

  Stream<User?> idTokenChanges() => FirebaseAuth.instance.idTokenChanges();

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Don't call this directly; call `AuthManager.signOut` instead, so every
  /// `Manager.onSignOut` runs before the user is signed out.
  Future<void> signOut() => FirebaseAuth.instance.signOut();

  Future<void> sendPasswordResetEmail({required String email}) =>
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}
