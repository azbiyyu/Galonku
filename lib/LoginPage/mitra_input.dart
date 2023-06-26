import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/home_page_depot.dart';
import 'package:galonku/Models/_heading.dart';
import 'package:galonku/Models/_image_upload.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MitraInput extends StatefulWidget {
  const MitraInput({super.key});
  static const nameRoute = '/mitrainput';

  @override
  State<MitraInput> createState() => _MitraInputState();
}

class _MitraInputState extends State<MitraInput> {
  bool _isROSelected = false;
  bool _isMineralSelected = false;
  final usernameController = TextEditingController();
  final alamatController = TextEditingController();
  final bukaController = TextEditingController();
  final tutupController = TextEditingController();
  
  
  LatLng _selectedLocation = LatLng(0, 0);
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 14);

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
  String namaDepot = usernameController.text;
  String alamatDepot = alamatController.text;
  String bukaDepot = bukaController.text;
  String tutupDepot = tutupController.text;

  final docUser = FirebaseFirestore.instance.collection('user').doc('id');
  final json = {
    'username': namaDepot,
    'alamat': alamatDepot,
    'buka': bukaDepot,
    'tutup': tutupDepot,
    'lokasi': GeoPoint(_selectedLocation.latitude, _selectedLocation.longitude),
    'Mineral': _isROSelected,
    'RO': _isMineralSelected,
  };

  try {
    await docUser.set(json);
    Navigator.pushReplacementNamed(context, HomePageDepot.nameRoute);
  } catch (error) {
    print("Failed to save data: $error");
    // Show error message or handle error accordingly
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Heading(role: "Depot Air", action: "Masuk"),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Berikan Data Depot anda yang telah terdaftar sebelumnya",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.blue[600],
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: "masukkan Nama",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(66, 37, 37, 37),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: alamatController,
                    keyboardType: TextInputType.streetAddress,
                    cursorColor: Colors.blue[600],
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: "masukkan Alamat",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(66, 37, 37, 37),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: bukaController,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.blue[600],
                          decoration: InputDecoration(
                            labelText: 'Buka',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: "Jam Buka",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(66, 37, 37, 37),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: tutupController,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.blue[600],
                          decoration: InputDecoration(
                            labelText: 'Tutup',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: "Jam Tutup",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(66, 37, 37, 37),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 52, 83, 209),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CheckboxListTile(
                            title: const Text(
                              'RO',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: _isROSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                _isROSelected = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.white, // Warna centang
                            checkColor: Colors.black, // Warna centang
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 153, 0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: CheckboxListTile(
                            title: const Text(
                              'Mineral',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: _isMineralSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                _isMineralSelected = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.white, // Warna centang
                            checkColor: Colors.black, // Warna centang
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: ImageUploadCard(),
                ),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      _onMapCreated(controller);
                    },
                    initialCameraPosition: _initialCameraPosition,
                    onCameraMove: _onCameraMove,
                    markers: _markers,
                    onTap: _onMapTap,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
