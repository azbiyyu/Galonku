import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:galonku/DesignSystem/_appBar.dart';
import 'package:galonku/LandingPage/login_role.dart';

class SettingsDepot extends StatefulWidget {
  const SettingsDepot({Key? key});
  static const nameRoute = '/settingsdepot';

  @override
  State<SettingsDepot> createState() => _SettingDepotState();
}

class _SettingDepotState extends State<SettingsDepot> {
  bool isEditing = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _produkController = TextEditingController();
  TextEditingController _bukaController = TextEditingController();
  TextEditingController _tutupController = TextEditingController();

  String depotDocumentId = '';
  String imageUrl = '';
  String currentImageUrl = '';
  String katalogUrl = '';
  int idx = 0;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';

    QuerySnapshot depotSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    if (depotSnapshot.docs.isNotEmpty) {
      DocumentSnapshot depotDocument = depotSnapshot.docs.first;
      Map<String, dynamic>? depotData =
          depotDocument.data() as Map<String, dynamic>?;

      if (depotData != null) {
        setState(() {
          depotDocumentId = depotDocument.id;

          _usernameController.text = depotData['username'] ?? '';
          _emailController.text = depotData['email'] ?? '';
          _alamatController.text = depotData['alamat'] ?? '';
          _produkController.text = depotData['produk'] ?? '';
          _bukaController.text = depotData['buka'] ?? '';
          _tutupController.text = depotData['tutup'] ?? '';
          currentImageUrl = depotData['images'] ?? imageUrl;
        });
      }
    }
  }

  void toggleEditing() async {
    if (isEditing) {
      // Update depot data in Firebase Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(depotDocumentId)
          .update({
        'username': _usernameController.text,
        'email': _emailController.text,
        'alamat': _alamatController.text,
        'produk': _produkController.text,
        'buka': _bukaController.text,
        'tutup': _tutupController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil disimpan')),
      );
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> pickImage() async {
    if (currentImageUrl.isNotEmpty) {
      Reference referenceToDelete =
          FirebaseStorage.instance.refFromURL(currentImageUrl);
      await referenceToDelete.delete();
    }

    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload =
        referenceDirImages.child(uniqueFileName);

    Reference referenceKatalog = FirebaseStorage.instance.ref();
    Reference referenceDirKatalog = referenceKatalog.child('katalog');
    Reference referenceKatalogUpload =
        referenceDirKatalog.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      await referenceKatalogUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      katalogUrl = await referenceKatalogUpload.getDownloadURL();
    } catch (e) {
      print('Error: $e');
    }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(depotDocumentId)
        .update({
      'images': imageUrl,
      'katalog1': katalogUrl,
    });

    setState(() {
      currentImageUrl = imageUrl;
    });
  }

  List<String> katalogFields = [
    'katalog1',
    'katalog2',
    'katalog3',
  ];

  Future<void> pickImageKatalog(int index) async {
    if (currentImageUrl.isNotEmpty) {
      Reference referenceToDelete =
          FirebaseStorage.instance.refFromURL(currentImageUrl);
      await referenceToDelete.delete();
    }

    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('katalog');
    Reference referenceImageToUpload =
        referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (e) {
      print('Error: $e');
    }

    if (index < katalogFields.length) {
      String fieldToUpdate = katalogFields[index];
      await FirebaseFirestore.instance
          .collection('user')
          .doc(depotDocumentId)
          .update({
        fieldToUpdate: imageUrl,
      });

      setState(() {
        currentImageUrl = imageUrl;
      });
    }
  }

  Widget _buildCarouselItem(String text) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Mitra Galonku"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onLongPress: () {
                  pickImage();
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      currentImageUrl != '' ? NetworkImage(currentImageUrl) : null,
                  child:
                      currentImageUrl == '' ? Icon(Icons.edit, color: Colors.white) : null,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: toggleEditing,
                    child: Text(
                      isEditing ? "Simpan" : "Edit Data",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      enabled: isEditing,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      enabled: isEditing,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _alamatController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      enabled: isEditing,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _produkController,
                      decoration: InputDecoration(
                        labelText: 'Produk',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      enabled: isEditing,
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
                        controller: _bukaController,
                        decoration: InputDecoration(
                          labelText: 'Buka',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        enabled: isEditing,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _tutupController,
                        decoration: InputDecoration(
                          labelText: 'Tutup',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        enabled: isEditing,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              CarouselSlider(
                items: [
                  if (_produkController.text.isNotEmpty)
                    ...[
                      _buildCarouselItem(_produkController.text),
                      _buildCarouselItem(_produkController.text),
                      _buildCarouselItem(_produkController.text),
                    ],
                  InkWell(
                    onTap: () {
                      pickImageKatalog(idx);
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.8,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('email');
                    await prefs.remove('password');
                    await prefs.remove('role');
                    prefs.setBool('isLoggedIn', false);
                    Navigator.pushNamed(context, LoginRole.nameRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(isEditing ? 'Simpan' : 'Logout'),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
