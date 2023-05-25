// import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/home_page_user.dart';
import 'package:galonku/LandingPage/landingpage.dart';
import 'package:galonku/LandingPage/login_role.dart';
import 'package:galonku/LoginPage/mitra_input.dart';
import 'package:galonku/LoginPage/mitra_login.dart';
import 'package:galonku/LoginPage/mitra_signin.dart';
import 'package:galonku/LoginPage/user_login.dart';
import 'package:galonku/LoginPage/user_signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LandingPage(),
        // body: Try(),
      ),
      initialRoute: LandingPage.nameRoute,
      routes: {
        LandingPage.nameRoute: (context) => LandingPage(),
        LoginRole.nameRoute: (context) => LoginRole(),
        UserSignIn.nameRoute: (context) => UserSignIn(),
        UserLogin.nameRoute: (context) => UserLogin(),
        MitraSignIn.nameRoute: (context) => MitraSignIn(),
        MitraLogin.nameRoute: (context) => MitraLogin(),
        MitraInput.nameRoute: (context) => MitraInput(),
        HomePageUser.nameRoute: (context) => HomePageUser(),
      },
    );
  }
}
