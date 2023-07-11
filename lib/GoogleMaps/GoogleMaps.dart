import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/chat_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DepotPage/chat_page.dart';
import '../DepotPage/detail_depot.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage>
    with SingleTickerProviderStateMixin {
  List<Marker> _markers = [];
  bool _isDropdownOpen = false;
  String _selectedUsername = '';
  String _selectedEmail = '';
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<String> _katalogs = [];

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _currentPosition = CameraPosition(
    bearing: 0,
    target: LatLng(-3.105305, 117.591325),
    tilt: 20,
    zoom: 3,
  );

  Marker _currentLocationMarker = Marker(
    markerId: MarkerId('currentLocation'),
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getMarkersFromFirestore();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15.0,
      );

      _currentLocationMarker = Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Lokasi Saat Ini'),
      );
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
  }

  Future<void> _getMarkersFromFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('user').get();

    List<Marker> markers = [];

    for (var document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      if (data.containsKey('lokasi')) {
        dynamic lokasiValue = data['lokasi'];
        if (lokasiValue is GeoPoint) {
          Marker marker = Marker(
            markerId: MarkerId(document.id),
            position: LatLng(lokasiValue.latitude, lokasiValue.longitude),
            infoWindow: InfoWindow(title: data['username']),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            onTap: () async {
              setState(() {
                _isDropdownOpen = true;
                _selectedUsername = data['username'];
                _selectedEmail = data['email'];
                _katalogs = [
                  data['katalog1'],
                  data['katalog2'],
                  data['katalog3']
                ];
              });
            },
          );

          markers.add(marker);
        }
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  void _closeDropdown() {
    setState(() {
      _isDropdownOpen = false;
      _selectedUsername = '';
      _katalogs = [];
    });
  }

  void _goToDetailDepot() async {
    SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
    sharedPreferences.setString('data_email', _selectedEmail);
    sharedPreferences.setString('data', _selectedUsername);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetailDepot(email: _selectedEmail), // Ganti dengan halaman DetailDepot yang sesuai
      ),
    );
  }
  void _goToChatPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(email: _selectedEmail),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double fabTopMargin = _isDropdownOpen ? 16.0 : 16.0;

    return Scaffold(
      body: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _currentPosition,
              markers: <Marker>{_currentLocationMarker, ..._markers},
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: 0,
            right: 0,
            bottom: _isDropdownOpen ? 0.0 : -500.0,
            child: GestureDetector(
              onTap: _closeDropdown,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _closeDropdown,
                      icon: Icon(Icons.close),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _selectedUsername + " Depot",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _katalogs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 16),
                            width: 150,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(_katalogs[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            _goToDetailDepot();
                          },
                          child: Text('Detail Depot'),
                        ),
                        IconButton(
                          onPressed: () async{
                            SharedPreferences srf = await SharedPreferences.getInstance();
                            String mail = srf.getString('email') ?? '';
                            if(mail == _selectedEmail){
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context, ChatList.nameRoute);
                            }else{
                              _goToChatPage();
                            }
                          },
                         icon: Icon(Icons.chat),
                         iconSize: 20,
                         )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(top: fabTopMargin, right: 16.0),
        child: FloatingActionButton.extended(
          onPressed: _goToCurrentLocation,
          label: const Text('Pusatkan'),
          icon: const Icon(Icons.my_location),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
  }
}
