import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthProvider with ChangeNotifier {
  FirebaseAuth firebase;
  AuthProvider(this.firebase);
  bool isLoading = false;
  Stream<User?> stream() => firebase.authStateChanges();
  bool get loading => isLoading;
  Future<void> signOut() async {
    await firebase.signOut();
  }

  Future<String> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await firebase.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      isLoading = false;
      notifyListeners();
      return Future.value('');
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      return Future.value(e.message);
    }
  }

  void signInPressed(email, password, context) async {
    final message = await signIn(email, password);
    if (message == '') {
      return;
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );
    }
    notifyListeners();
  }

  Future<String> signUp(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await firebase.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      isLoading = false;
      notifyListeners();
      return Future.value('');
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      return Future.value(e.message);
    }
  }

  void signUpPressed(email, password, context) async {
    final message = await signUp(email, password);
    if (message == '') {
      return;
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );
    }
    notifyListeners();
  }


  bool obscureText = true;
  void toggle() {
    obscureText = !obscureText;
    notifyListeners();
  }
}
