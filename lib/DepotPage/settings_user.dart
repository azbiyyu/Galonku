import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:galonku/DesignSystem/_appBar.dart';
import 'package:galonku/LandingPage/login_role.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsUser extends StatefulWidget {
  const SettingsUser({Key? key});
  static const nameRoute = '/SettingsUser';

  @override
  State<SettingsUser> createState() => _SettingDepotState();
}

class _SettingDepotState extends State<SettingsUser> {
  bool isEditing = false;
  String documentId = '';
  String currentImageUrl = '';
  String imageUrl = '';
  int idx = 0;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();


  @override
  void initState() {
    super.initState();
    loadUserData();
  }
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? '';
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot document = snapshot.docs.first;
      Map<String, dynamic>? data = 
        document.data() as Map<String, dynamic>?;

      if(data != null){
        setState(() {
          documentId = document.id;
        _usernameController.text = data['username'] ?? '';
        _emailController.text = prefs.getString('email') ?? '';
        _alamatController.text = data['alamat'] ?? '';
        currentImageUrl = data['images'] ?? imageUrl;
        });
      }
    }
    
  }

  void toggleEditing() async {
    if (isEditing) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(documentId)
          .update({
        'username': _usernameController.text,
        'email': _emailController.text,
        'alamat': _alamatController.text,
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
      List<String> profil = ['images'];
      String field = profil[idx];
      DocumentSnapshot depotSnapshot = await FirebaseFirestore.instance
      .collection('user')
      .doc(documentId)
      .get();
      if (depotSnapshot.exists) {
      Map<String, dynamic>? data = depotSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey(field)) {
          String fieldValue = data[field];
          // Check if fieldValue is a valid URL
          if (fieldValue.startsWith('gs://') || fieldValue.startsWith('https://')) {
            Reference referenceToDelete = FirebaseStorage.instance.refFromURL(fieldValue);
            try {
              await referenceToDelete.delete();
              print('Data berhasil dihapus dari Firebase Storage');
            } catch (e) {
              print('Error saat menghapus data dari Firebase Storage: $e');
            }
          } else {
            print('Invalid URL: $fieldValue');
          }
        }
      }

      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file == null) return;
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      try {
        await referenceImageToUpload.putFile(File(file.path));
        imageUrl = await referenceImageToUpload.getDownloadURL();
      } catch (e) {
        print('Error: $e');
      }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(documentId)
        .update({
          'images': imageUrl,
      });

    setState(() {
      currentImageUrl = imageUrl;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Cari Depot"),
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
                      enabled: false,
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
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    currentImageUrl = '';
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove('email');
                    prefs.remove('role');
                    prefs.setBool('isLoggedIn', false);
                    signOutFromGoogle();
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
