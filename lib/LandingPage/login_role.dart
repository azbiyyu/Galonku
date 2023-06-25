import 'package:flutter/material.dart';
import 'package:galonku/LoginPage/mitra_login.dart';
import 'package:galonku/LoginPage/user_login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controllers/shared_preferences_helper.dart';


// ignore: must_be_immutable
class LoginRole extends StatelessWidget {
  static const nameRoute = '/loginrole';
  // ignore: prefer_typing_uninitialized_variables
  var isLoggedIn;
  


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "Masuk sebagai",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                Text(
                  "Pilih peran kamu saat ini dan bergabunglah bersama kami",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 99, 99, 99),
                    fontSize: 15,
                    overflow: TextOverflow.visible,
                  ),
                ),
                Expanded(
                  child: Image.asset("images/role.png"),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 50.0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 255, 255, 255),
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: Colors.blue),
                            ),
                          ),
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('role', "mitra");
                            SharedPreferencesHelper.updateLoginStatus(true); // Metode yang mengarahkan pengguna ke halaman beranda (login berhasil)
                            SharedPreferencesHelper.updateRole("mitra"); // Metode yang mengupdate nilai role di MyApp

                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, MitraLogin.nameRoute, arguments: {isLoggedIn : true});
                          },
                          child: Text(
                            "Mitra Galonku",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 50.0),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 255, 255, 255),
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: Colors.blue),
                            ),
                          ),
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('role', "user");
                            SharedPreferencesHelper.updateLoginStatus(true); // Metode yang mengarahkan pengguna ke halaman beranda (login berhasil)
                            SharedPreferencesHelper.updateRole("user"); // Metode yang mengupdate nilai role di MyApp
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamed(context, UserLogin.nameRoute, arguments: {isLoggedIn : false});
                          },
                          child: Text(
                            "Pelanggan",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


