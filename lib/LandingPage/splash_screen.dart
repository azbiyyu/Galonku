import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    bool skipped = prefs.getBool('isSkipped') ?? false;
    String? initialRoute;

    if (role == null) {
      if (skipped == true) {
        initialRoute = '/loginrole';
      }else{
        initialRoute = '/landingpage';
      }
    } else if (role == 'mitra') {
      initialRoute = '/homepagedepot';
    } else if (role == 'user') {
      initialRoute = '/homepageuser';
    }

    if (initialRoute != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context,
        initialRoute,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/loginrole',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
