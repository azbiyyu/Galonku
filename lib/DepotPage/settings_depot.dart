import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:galonku/LandingPage/login_role.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDepot extends StatefulWidget {
  const SettingsDepot({Key? key});
  static const nameRoute = '/settingsdepot';

  @override
  State<SettingsDepot> createState() => _SettingDepotState();
}

class _SettingDepotState extends State<SettingsDepot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Logika ketika tombol edit foto ditekan
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Alamat'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Produk'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Buka'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Tutup'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
           
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('email');
                await prefs.remove('password');
                // Navigasi ke halaman login atau halaman lain yang sesuai
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginRole((p0) => true)),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
