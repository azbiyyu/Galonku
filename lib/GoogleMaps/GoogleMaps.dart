import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  List<Marker> _markers = [];

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _currentPosition = CameraPosition(
    bearing: 90,
    target: LatLng(0.0, 0.0),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  Marker _currentLocationMarker = Marker(
    markerId: MarkerId('currentLocation'),
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getMarkersFromFirestore();
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
        // print(lokasiValue);
        // Lakukan sesuatu dengan nilai 'lokasi' di sini, seperti membuat Marker
        // Contoh: Membuat Marker dengan posisi berdasarkan nilai 'lokasi'
        if (lokasiValue is GeoPoint) {
          Marker marker = Marker(
            markerId: MarkerId(document.id),
            position: LatLng(lokasiValue.latitude, lokasiValue.longitude),
            infoWindow: InfoWindow(title: data['username']),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          );

          markers.add(marker);
        }
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _currentPosition,
        markers: <Marker>{_currentLocationMarker, ..._markers},
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCurrentLocation,
        label: const Text('Pusatkan'),
        icon: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
  }
}
