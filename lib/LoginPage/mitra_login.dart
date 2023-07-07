import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:galonku/Controllers/auth.dart';
import 'package:galonku/DepotPage/home_page_depot.dart';
import 'package:galonku/DesignSystem/_lupa_sandi.dart';
import 'package:galonku/Models/_button_primary.dart';
import 'package:galonku/Models/_heading.dart';
// import 'package:galonku/LandingPage/login_role.dart';
import 'package:galonku/LoginPage/mitra_signin.dart';
import 'package:galonku/Models/_button_sinkronise.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galonku/Pop_up/Pop_up.dart';
// import 'package:firebase_auth_project/auth.dart';

class MitraLogin extends StatefulWidget {
  const MitraLogin({super.key});
  static const nameRoute = '/mitralogin';

  @override
  State<MitraLogin> createState() => _MitraLoginState();
}

class _MitraLoginState extends State<MitraLogin> {
  bool _obscureText = true;
  bool isLogged = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // string error
  String? errorMessage = ' ';
  // cek apakah sudah login atau tidak
  bool isLogin = true;
  // controller edit
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
   // Method untuk login dengan Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleSignInAccount?.authentication;

      if (googleAuth != null) {
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        // Mendapatkan email dari user yang login dengan Google
        final String? email = userCredential.user?.email;

        // Menyimpan email ke SharedPreferences
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('email', email ?? '');
        // Tambahkan logika yang diinginkan setelah berhasil sign-in dengan Google
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, HomePageDepot.nameRoute);
      }
    } catch (e) {
      print('Error saat sign-in dengan Google: $e');
    }
  }
  // method untuk sign in
  Future<void> signInwithEmailAndPassword() async {
    try {
      // ignore: avoid_types_as_parameter_names
      await Auth(updateLoggedInStatus: (bool) => true).SignWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, HomePageDepot.nameRoute);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          PopupButton();
          errorMessage = e.message;
        });
      } else {
        setState(() {
          PopupButton();
          errorMessage = e.message;
        });
      }
    }
  }
  Future<void> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
        final userData = await FacebookAuth.instance.getUserData();
    
        final String username = userData['name'];
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('email', username);
      
      if (result.status == LoginStatus.success) {
        // Login berhasil, lakukan tindakan yang sesuai
        print('Login dengan Facebook berhasil');
      } else if (result.status == LoginStatus.cancelled) {
        // Login dibatalkan oleh pengguna, lakukan tindakan yang sesuai
        print('Login dengan Facebook dibatalkan');
      } else {
        // Login gagal, lakukan tindakan yang sesuai
        print('Login dengan Facebook gagal');
      }
    } catch (e) {
      // Tangani kesalahan atau lakukan tindakan yang sesuai
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              children: [
                SizedBox(height: 10),
                Heading(role: "Depot Air", action: "Masuk"),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Masuk dengan akun anda yang telah terdaftar sebelumnya",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                SizedBox(height: 40),
                BtnSinkronise(
                  image: "images/google_logo.png",
                  text: "Sinkronasi Dengan Google",
                  onPressed: signInWithGoogle,
                ),
                SizedBox(height: 10),
                BtnSinkronise(
                  image: "images/facebook_logo.png",
                  text: "Sinkronasi Dengan Facebook",
                  onPressed: loginWithFacebook,
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Image.asset("images/atau.png"),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.blue[600],
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: "masukkan email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(66, 37, 37, 37),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: _controllerPassword,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "masukkan password",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(66, 37, 37, 37),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: _obscureText
                            ? Icon(Icons.visibility_off_outlined)
                            : Icon(Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        // aksi yang dijalankan saat teks diklik
                        // if (isLogin == false) {
                        //   Navigator.pushNamed(context, LoginRole.nameRoute);
                        // } else {
                        //   Popup();
                        // }
                        Navigator.pushNamed(context, LupaSandi.nameRoute);
                      },
                      child: Text(
                        "lupa sandi ?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: BtnPrimary(
                    text: "Masuk",
                    onPressed: () async {
                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          'email', _controllerEmail.text);
                      sharedPreferences.setString('role', 'mitra');
                      signInwithEmailAndPassword();
                    },
                  ),
                ),
                Container(
                  // alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum memiliki akun ?",
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          // aksi yang dijalankan saat teks diklik
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MitraSignIn()),
                          );
                        },
                        child: Text(
                          "daftar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
