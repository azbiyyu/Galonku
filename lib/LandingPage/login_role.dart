import 'package:flutter/material.dart';
import 'package:galonku/LoginPage/mitra_login.dart';
import 'package:galonku/LoginPage/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../DepotPage/home_page_depot.dart';
// import '../DepotPage/home_page_user.dart';

class LoginRole extends StatefulWidget {
  static const nameRoute = '/loginrole';

  @override
  // ignore: library_private_types_in_public_api
  _LoginRoleState createState() => _LoginRoleState();
}

class _LoginRoleState extends State<LoginRole> {
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  void checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    if (role != null) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

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
                            setState(() {
                              isLoggedIn = true;
                            });
                            Navigator.pushNamed(context, MitraLogin.nameRoute);
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
                            setState(() {
                              isLoggedIn = false;
                            });
                            Navigator.pushNamed(context,UserLogin.nameRoute);
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
