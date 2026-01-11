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

  Future<void> signOut() => FirebaseAuth.instance.signOut();
}
