import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/chat_user.dart';
import 'package:galonku/DepotPage/pesanan_user.dart';
import 'package:galonku/LandingPage/login_role.dart';
import '../GoogleMaps/GoogleMaps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({Key? key}) : super(key: key);

  static const nameRoute = '/homepageuser';

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  List<Widget> widgetPage = [
    Center(
      child: Text(
        "Home",
        style: TextStyle(fontSize: 50),
      ),
    ),
    Center(
      child: PesananUser(),
    ),
    GoogleMapPage(),
    Center(
      child: ChatUser(),
    ),
    Center(
      child: Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('password');

              // Navigasi ke halaman login atau halaman lain yang sesuai
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginRole((p0) => false)),
              );
            },
            child: Text('Logout'),
          );
        },
      ),
    ),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Cari Depot")),
        backgroundColor: Color.fromARGB(255, 52, 83, 209),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: widgetPage[index],
      bottomNavigationBar: SizedBox(
        height: 95,
        child: BottomNavigationBar(
          currentIndex: index,
          selectedItemColor: Colors.blue[400],
          unselectedIconTheme: IconThemeData(color: Colors.black26),
          unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
          iconSize: 30,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          backgroundColor: Color.fromARGB(151, 174, 174, 174),
          items: [
            BottomNavigationBarItem(
                icon: Image.asset('images/Icon_HomePage.png'), label: 'Home'),
            BottomNavigationBarItem(
                icon: Image.asset('images/Icon_Pesanan.png'), label: "Pesanan"),
            BottomNavigationBarItem(
                icon: Image.asset('images/Icon_Maps.png'), label: "Maps"),
            BottomNavigationBarItem(
                icon: Image.asset('images/Icon_Pesan.png'), label: "Pesan"),
            BottomNavigationBarItem(
                icon: Image.asset('images/Icon_Setting.png'), label: "Setting"),
          ],
        ),
      ),
    );
  }
}
