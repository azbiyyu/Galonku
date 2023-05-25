import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:galonku/DepotPage/chat_user.dart';

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
      child: Text(
        "Pesanan",
        style: TextStyle(fontSize: 50),
      ),
    ),
    GoogleMapPage(),
    Center(
      child: ChatUser(),
    ),
    Center(
      child: Text(
        "Settings",
        style: TextStyle(fontSize: 50),
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
                icon: Image.asset('images/Icon_Pesanan.png'),
                label: "Pesanan"),
            BottomNavigationBarItem(
                icon: Image.asset('images/Icon_Maps.png'), label: "Maps"),
            BottomNavigationBarItem(
                icon: Image.asset('images/Icon_Pesan.png'), label: "Pesan"),
            BottomNavigationBarItem(
                icon: Image.asset('images/Icon_Setting.png'),
                label: "Setting"),
          ],
        ),
      ),
    );
  }
}

class GoogleMapPage extends StatefulWidget {
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
