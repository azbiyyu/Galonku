// import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:galonku/LandingPage/landingpage.dart';
// import 'package:galonku/LoginPage/verifikasi.dart';
// import 'package:galonku/try.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LandingPage(),
        // body: Try(),
      ),
    );
  }
}
