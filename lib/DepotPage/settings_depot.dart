import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:galonku/DesignSystem/_appBar.dart';
import 'package:galonku/LandingPage/login_role.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class SettingsDepot extends StatefulWidget {
  const SettingsDepot({Key? key});
  static const nameRoute = '/settingsdepot';

  @override
  State<SettingsDepot> createState() => _SettingDepotState();
}

class _SettingDepotState extends State<SettingsDepot> {
  List<String> images = [
    'images/test_foto.png',
    'images/test_foto.png',
    'images/test_foto.png',
  ];
  

  bool isEditing = false;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _produkController = TextEditingController();
  TextEditingController _bukaController = TextEditingController();
  TextEditingController _tutupController = TextEditingController();

  String depotDocumentId = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';

    QuerySnapshot depotSnapshot = await FirebaseFirestore.instance.collection('user').where('email', isEqualTo: email).get();
    if (depotSnapshot.docs.isNotEmpty) {
      DocumentSnapshot depotDocument = depotSnapshot.docs.first;
    Map<String, dynamic>? depotData = depotDocument.data() as Map<String, dynamic>?;
    if (depotData != null) {
      setState(() {
        depotDocumentId = depotDocument.id;
        _usernameController.text = depotData['username'] ?? '';
        _emailController.text = depotData['email'] ?? '';
        _alamatController.text = depotData['alamat'] ?? '';
        _produkController.text = depotData['produk'] ?? '';
        _bukaController.text = depotData['buka'] ?? '';
        _tutupController.text = depotData['tutup'] ?? '';
      });
    }
  }
  }

  void toggleEditing() async {
    if (isEditing) {
      // Mengupdate data depot di Firebase Firestore
      await FirebaseFirestore.instance.collection('user').doc(depotDocumentId).update({
        'username': _usernameController.text,
        'email': _emailController.text,
        'alamat': _alamatController.text,
        'produk': _produkController.text,
        'buka': _bukaController.text,
        'tutup': _tutupController.text,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil disimpan')),
      );
    }

    setState(() {
      isEditing = !isEditing;
    });
  }


  Future<void> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if(file == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();



    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print(imageUrl);
    // ignore: empty_catches
    } catch (e) {
      print(e);
    }
    

    
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
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
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
                  ...images.map(
                    (image) {
                      return Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
                    // ignore: use_build_context_synchronously
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
