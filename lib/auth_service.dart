import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'theme.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppTheme _currentTheme = AppTheme.Light;
  AppTheme get currentTheme => _currentTheme;

  static final _encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));
  static final _iv = encrypt.IV.fromLength(16);

  ThemeData getThemeData(AppTheme theme) {
    switch (theme) {
      case AppTheme.Light:
        return MaterialTheme(ThemeData().textTheme).light();
      case AppTheme.Dark:
        return MaterialTheme(ThemeData().textTheme).dark();
      case AppTheme.LightMediumContrast:
        return MaterialTheme(ThemeData().textTheme).lightMediumContrast();
      case AppTheme.LightHighContrast:
        return MaterialTheme(ThemeData().textTheme).lightHighContrast();
      case AppTheme.DarkMediumContrast:
        return MaterialTheme(ThemeData().textTheme).darkMediumContrast();
      case AppTheme.DarkHighContrast:
        return MaterialTheme(ThemeData().textTheme).darkHighContrast();
      default:
        return MaterialTheme(ThemeData().textTheme).light();
    }
  }

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    await _updateUserData(userCredential.user);
    notifyListeners();
    return userCredential.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _updateUserData(userCredential.user);
      notifyListeners();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // User doesn't exist, create a new account
        return await createUserWithEmail(email, password);
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
          code: 'wrong-password',
          message: 'Incorrect password. Please try again.',
        );
      } else {
        rethrow;
      }
    }
  }

  Future<User?> createUserWithEmail(String email, String password) async {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _updateUserData(userCredential.user);
    notifyListeners();
    return userCredential.user;
  }

  Future<void> _updateUserData(User? user) async {
    if (user != null) {
      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
      }, SetOptions(merge: true));
    }
  }

  Future<void> updateUserName(String name) async {
    final user = _auth.currentUser;
    if (user != null && !isGoogleUser(user)) {
      await user.updateDisplayName(name);
      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.update({'displayName': name});
      notifyListeners();
    }
  }

  Future<void> updatePassword(String password) async {
    final user = _auth.currentUser;
    if (user != null && !isGoogleUser(user)) {
      final encryptedPassword = _encrypter.encrypt(password, iv: _iv).base64;
      await user.updatePassword(password);
      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.update({'password': encryptedPassword});
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> deleteUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.delete();
      await user.delete();
      notifyListeners();
    }
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  bool isGoogleUser(User user) {
    return user.providerData.any((userInfo) => userInfo.providerId == 'google.com');
  }
}
