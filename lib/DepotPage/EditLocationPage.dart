import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/home_page_depot.dart';
import 'package:galonku/DepotPage/settings_depot.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditLocationPage extends StatefulWidget {
  const EditLocationPage({Key? key}) : super(key: key);
  static const nameRoute = '/editlocation';

  @override
  State<EditLocationPage> createState() => _EditLocationPage();
}

class _EditLocationPage extends State<EditLocationPage> {

  LatLng _selectedLocation = LatLng(0, 0);
  Set<Marker> _markers = {};
  CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(0, 0), zoom: 14);

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _initialCameraPosition = position;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    // Set initial marker based on selected location
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('selected_location'),
          position: _selectedLocation,
        ),
      );
    });
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selected_location'),
          position: _selectedLocation,
        ),
      );
    });
  }
    void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';

    QuerySnapshot depotSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    if (depotSnapshot.docs.isNotEmpty) {
      DocumentSnapshot depotDocument = depotSnapshot.docs.first;
      String depotDocumentId = depotDocument.id;

      await FirebaseFirestore.instance
          .collection('user')
          .doc(depotDocumentId)
          .update({
            'lokasi': GeoPoint(_selectedLocation.latitude, _selectedLocation.longitude)
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lokasi berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Lokasi'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                onTap: _onMapTap,
                markers: _markers,
                initialCameraPosition: _initialCameraPosition,
                onCameraMove: _onCameraMove,
              ),
            ),
            ElevatedButton(
              onPressed: (){
                _saveData();
                Navigator.pushNamed(context, HomePageDepot.nameRoute);
              },
              child: Text('Simpan'),
              
            ),
          ],
        ),
      ),
    );
  }
}