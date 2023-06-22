import 'package:flutter/material.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});
  static const nameRoute = '/homeuser';

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("CEKKK"),
    );
  }
}
