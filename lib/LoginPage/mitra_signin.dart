import 'package:flutter/material.dart';
import 'package:galonku/Models/_button_primary.dart';
import 'package:galonku/Models/_group_syarat_ketentuan.dart';
import 'package:galonku/Models/_heading.dart';
import 'package:galonku/LoginPage/mitra_login.dart';
import 'package:galonku/Models/_button_sinkronise.dart';
import 'package:galonku/LoginPage/verifikasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Controllers/auth.dart';


class MitraSignIn extends StatefulWidget {
  const MitraSignIn({super.key});
  static const nameRoute = '/mitrasignin';

  @override
  State<MitraSignIn> createState() => _MitraSignInState();
}

class _MitraSignInState extends State<MitraSignIn> {
  bool _obscureText = true;

  // string error
  String? errorMessage = ' ';
  // cek apakah sudah login atau tidak
  bool isLogin = true;
  // controller edit
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  
  // method untuk sign in
  Future<void> signInwithEmailAndPassword() async {
    try {
      await Auth().SignWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
  // method create user
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().CreateUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
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
                    onPressed: () {},
                  ),
                  SizedBox(height: 10),
                  BtnSinkronise(
                    image: "images/facebook_logo.png",
                    text: "Sinkronasi Dengan Facebook",
                    onPressed: () {},
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Image.asset("images/atau.png"),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.blue[600],
                      decoration: InputDecoration(
                        labelText: 'Nama Pengguna',
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: "masukkan nama pengguna",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(66, 37, 37, 37),
                          ),
                        ),
                      ),
                    ),
                  ),
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
                      // Navigator.pushNamed(context, routeName);
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: BtnPrimary(
                      text: "Daftar",
                      onPressed: () {
                        isLogin ? signInwithEmailAndPassword() : createUserWithEmailAndPassword();
                        isLogin = !isLogin;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Verifikasi(
                              isFromUserSignIn: false,
                            ),
                          ),
                        );
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
