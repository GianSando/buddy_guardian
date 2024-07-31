// ignore_for_file: unused_local_variable

import 'package:buddy_guardian/game/flappy_game.dart';
import 'package:buddy_guardian/services/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  notAuthenticated,
  checking,
  authenticated,
}

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
   final game = FlappyBirdGame();

  AuthStatus authStatus = AuthStatus.notAuthenticated;

  String? _errorMessage;
  String get errorMessage => _errorMessage ?? '';

  bool obscureText = true;

  bool isLoggedIn = false;

//para el login
  Future<UserCredential?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      //print(e);
      return null;
    }
  }

//VERIFICAR AUTENTICIDAD DEL ROL
  Future<void> checkAuthStatus() async {
    final isSignedIn = LocalStorage().getIsSignedIn();
    final isLoggedIn = LocalStorage().getIsLoggedIn();
    if (isSignedIn == true && isLoggedIn == true) {
      authStatus = AuthStatus.authenticated;
      this.isLoggedIn = isLoggedIn;
    } else {
      authStatus = AuthStatus.notAuthenticated;
    }
    notifyListeners();
  }

  void getObscureText() {
    obscureText == true ? obscureText = false : obscureText = true;
    notifyListeners();
  }

  //SALIR DE LA APP
  Future<void> logoutApp() async {
    await _auth.signOut();
    authStatus = AuthStatus.notAuthenticated;
    isLoggedIn = false;
    // Sign out from Firebase and Google
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    notifyListeners();
    // Elimina la clave 'is_signedin' de la caja usando LocalStorage
    await LocalStorage().deleteIsSignedIn();
    //cambiar a false el valor de isLoggedIn
    await LocalStorage().setIsLoggedIn(false);
    //limpiar la caja
    await LocalStorage().clear();
  }

  //PARA OBTENER LOS DATOS DEL USUARIO
  Future<dynamic> getUserData(String email) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs[0].data();
      return userData;
    }

    return null;
  }
}
