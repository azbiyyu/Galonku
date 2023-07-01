import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galonku/LandingPage/landingpage.dart';


class Auth {
  late SharedPreferences _preferences;
  // dapatkan instance firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // dapatkan user sekarang
  User? get currentUser => _firebaseAuth.currentUser;
  // stream user untuk perubahan state pada user
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  

  Auth({required this.updateLoggedInStatus}) {
    initializeSharedPreferences();
  }

  Function(bool) updateLoggedInStatus;


  Future<void> initializeSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }
  
  //method untuk sign in dengan email
   // ignore: non_constant_identifier_names
   Future<void> SignWithEmailAndPassword(
    {
      required String email,
      required String password,
    }) async {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      // Mendapatkan instance SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Menyimpan email dan password
      prefs.setString('email', email);
      prefs.setString('password', password);
  }
  
  // method untuk membuat user untuk dimasukkan kedalam firebase
  // ignore: non_constant_identifier_names
  Future<void> CreateUserWithEmailAndPassword(
    {
      required String email,
      required String password,
    }) async {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      // Mendapatkan instance SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Menyimpan email dan password
      prefs.setString('email', email);
      prefs.setString('password', password);
    }
  
  // method sign out
  Future<void> signOut() async {
    await _preferences.remove('email');
    await _preferences.remove('password');
  
    // Ubah nilai isLoggedIn menjadi false
    var isLoggedIn = false;
    updateLoggedInStatus(isLoggedIn);
  }

}