import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  // dapatkan instance firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // dapatkan user sekarang
  User? get currentUser => _firebaseAuth.currentUser;
  // stream user untuk perubahan state pada user
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  
  
  //method untuk sign in dengan email
   Future<void> SignWithEmailAndPassword(
    {
      required String email,
      required String password,
    }) async {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
  }
  
  // method untuk membuat user untuk dimasukkan kedalam firebase
  Future<void> CreateUserWithEmailAndPassword(
    {
      required String email,
      required String password,
    }) async {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    }
  
  // method sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}