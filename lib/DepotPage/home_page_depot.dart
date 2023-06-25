import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/chat_depot.dart';
import 'package:galonku/DepotPage/home_depot.dart';
import 'package:galonku/DepotPage/pesanan_depot.dart';
import 'package:galonku/DepotPage/settings_depot.dart';
import 'package:galonku/LandingPage/login_role.dart';
import '../GoogleMaps/GoogleMaps.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageDepot extends StatefulWidget {
  const HomePageDepot({Key? key}) : super(key: key);

  static const nameRoute = '/homepagedepot';

  @override
  State<HomePageDepot> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageDepot> {
  List<Widget> widgetPage = [
    Center(
      child: HomeDepot(),
    ),
    Center(
      child: PesananDepot(),
    ),
    GoogleMapPage(),
    Center(
      child: ChatDepot(),
    ),
    Center(
      child: SettingsDepot(),
    ),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Mitra Galonku")),
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
