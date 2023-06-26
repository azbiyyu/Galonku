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
      body: Align(
        alignment: Alignment.topCenter,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text(
                  'Judul Card',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Subjudul Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
