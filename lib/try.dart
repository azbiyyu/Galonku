import 'package:flutter/material.dart';
import 'package:galonku/DesignSystem/_button_try.dart';
// import 'package:galonku/LandingPage/landingpage.dart';
import 'package:galonku/LandingPage/login_role.dart';

class Try extends StatelessWidget {
  const Try({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: CustomButton(
          text: 'BOTTOM_TRY',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginRole()),
            );
          },
        ),
      ),
    );
  }
}
