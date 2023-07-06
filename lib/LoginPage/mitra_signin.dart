import 'package:flutter/material.dart';
import 'package:galonku/DesignSystem/_syarat_ketentuan.dart';
import 'package:galonku/LoginPage/mitra_input.dart';
import 'package:galonku/Models/_button_primary.dart';
import 'package:galonku/Models/_group_syarat_ketentuan.dart';
import 'package:galonku/Models/_heading.dart';
import 'package:galonku/LoginPage/mitra_login.dart';
import 'package:galonku/Models/_button_sinkronise.dart';
// import 'package:galonku/LoginPage/verifikasi.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galonku/Pop_up/Pop_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controllers/auth.dart';

class MitraSignIn extends StatefulWidget {
  const MitraSignIn({super.key});
  static const nameRoute = '/mitrasignin';

  @override
  State<MitraSignIn> createState() => _MitraSignInState();
}

class _MitraSignInState extends State<MitraSignIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  late SharedPreferences _preferences;

  // string error
  String? errorMessage = '';
  // cek apakah sudah login atau tidak
  bool isLogin = false;
  // controller edit
  String username = '';
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  // Fungsi sign-in dengan Facebook
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      // Cek apakah login berhasil
      if (result.status == LoginStatus.success) {
        // Dapatkan akses token
        final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
        final String token = accessToken!.token;
        final userData = await FacebookAuth.instance.getUserData();

        // Gunakan akses token untuk autentikasi dengan Firebase
        final OAuthCredential credential = FacebookAuthProvider.credential(token);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    
        final String username = userData['name'];
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('email', username);
        // Gunakan akses token untuk autentikasi dengan Firebase
        //final OAuthCredential credential = FacebookAuthProvider.credential(token);
        //final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Tambahkan logika yang diinginkan setelah berhasil sign-in dengan Facebook
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, MitraInput.nameRoute);
        // Navigasi ke halaman selanjutnya, misalnya HomePage
      } else {
        // Login gagal, tangani kesalahan atau tindakan yang sesuai
      }
    } catch (e) {
      // Tangani kesalahan atau tindakan yang sesuai
    }
  }


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
        Navigator.pushReplacementNamed(context, MitraInput.nameRoute);
      }
    } catch (e) {
      print('Error saat sign-in dengan Google: $e');
    }
  }

  Future<void> initializeSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    // Retrieve email and password from SharedPreferences
    final savedEmail = _preferences.getString('email');
    final savedPassword = _preferences.getString('password');

    _controllerEmail.text = savedEmail ?? '';
    _controllerPassword.text = savedPassword ?? '';
  }

  // method untuk sign in
  Future<void> signInwithEmailAndPassword() async {
    try {
      await Auth(updateLoggedInStatus: (bool) => true).SignWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      // Save email and password to SharedPreferences
      _preferences.setString('email', _controllerEmail.text);
      _preferences.setString('password', _controllerPassword.text);
      // ignore: use_build_context_synchronously
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => Verifikasi(isFromUserSignIn: true)),
      // );
      _preferences.getString('role');
      // ignore: unrelated_type_equality_checks
      if(_preferences == 'mitra'){
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, MitraInput.nameRoute);
      }else{
         // ignore: use_build_context_synchronously
         Navigator.pushNamed(context, MitraInput.nameRoute);
      }
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

  // method create user
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth(updateLoggedInStatus: (bool) => true)
          .CreateUserWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerPassword.text);
      // Save email and password to SharedPreferences
      _preferences.setString('email', _controllerEmail.text);
      _preferences.setString('password', _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
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
    // // ignore: use_build_context_synchronously
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => Verifikasi(isFromUserSignIn: true)),
    // );
    _preferences.getString('role');
      // ignore: unrelated_type_equality_checks
      if(_preferences == 'mitra'){
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, MitraInput.nameRoute);
      }else{
         // ignore: use_build_context_synchronously
         Navigator.pushNamed(context, MitraInput.nameRoute);
      }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(30),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Heading(role: "Depot Air", action: "Daftar"),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Daftarkan akun anda untuk masuk kedalam fitur galonku.",
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
                    onPressed: signInWithFacebook,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Image.asset("images/atau.png"),
                  ),
                  // Container(
                  //   padding: EdgeInsets.only(top: 20),
                  //   child: TextField(
                  //     keyboardType: TextInputType.emailAddress,
                  //     cursorColor: Colors.blue[600],
                  //     decoration: InputDecoration(
                  //       labelText: 'Nama Pengguna',
                  //       labelStyle: TextStyle(color: Colors.black),
                  //       hintText: "masukkan nama pengguna",
                  //       border: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Color.fromARGB(66, 37, 37, 37),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        TextField(
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
                      ],
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
                  GroupSyaratKetentuan(
                    onTap: () {
                      Navigator.pushNamed(context, SyaratKetentuan.nameRoute);
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: BtnPrimary(
                      text: "Daftar",
                      onPressed: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString('role', 'mitra');
                        isLogin
                            ? signInwithEmailAndPassword()
                            : createUserWithEmailAndPassword();
                        isLogin = !isLogin;
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
                          "Sudah memiliki akun ?",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            // aksi yang dijalankan saat teks diklik
                            Navigator.pushNamed(context, MitraLogin.nameRoute);
                          },
                          child: Text(
                            "masuk",
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
      ),
    );
  }
}
