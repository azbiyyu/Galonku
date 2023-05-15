import 'package:flutter/material.dart';
import 'package:galonku/DesignSystem/_button_primary.dart';
import 'package:galonku/DesignSystem/_heading.dart';
import 'package:galonku/LandingPage/login_role.dart';
import 'package:galonku/LoginPage/mitra_signin.dart';
import 'package:galonku/DesignSystem/_button_sinkronise.dart';


class MitraLogin extends StatefulWidget {
  const MitraLogin({super.key});

  @override
  State<MitraLogin> createState() => _MitraLoginState();
}

class _MitraLoginState extends State<MitraLogin> {
  bool _obscureText = true;
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginRole()),
                        );
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginRole()),
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
