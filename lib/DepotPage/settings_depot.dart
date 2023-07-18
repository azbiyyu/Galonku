import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:galonku/DepotPage/EditLocationPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/widgets.dart';
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
  TextEditingController _hargaROController = TextEditingController();
  TextEditingController _hargaAquaController = TextEditingController();

  String depotDocumentId = '';
  String imageUrl = '';
  String imageUrlKatalog = '';
  String currentImageUrl = '';
  String currentImageUrlKatalog = '';
  String currentImageUrlKatalog2 = '';
  String currentImageUrlKatalog3 = '';
  String katalogUrl = '';
  int idx = 0;
  bool isKatalogUploaded = false;
  bool isMineral = false;
  bool isRO = false;

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
          _hargaROController.text = depotData['hargaRO'].toString();
          _hargaAquaController.text = depotData['hargaAqua'].toString();
          currentImageUrl = depotData['images'] ?? imageUrl;
          currentImageUrlKatalog = depotData['katalog1'] ?? '';
          currentImageUrlKatalog2 = depotData['katalog2'] ?? '';
          currentImageUrlKatalog3 = depotData['katalog3'] ?? '';


          isMineral = depotData['Mineral'] ?? false;
          isRO = depotData['RO'] ?? false;
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
        'hargaRO': _hargaROController.text,
        'hargaAqua': _hargaAquaController.text,
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
        .doc(depotDocumentId)
        .get();
    if (depotSnapshot.exists) {
      Map<String, dynamic>? data =
          depotSnapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey(field)) {
        String fieldValue = data[field];
        // Check if fieldValue is a valid URL
        if (fieldValue.startsWith('gs://') ||
            fieldValue.startsWith('https://')) {
          Reference referenceToDelete =
              FirebaseStorage.instance.refFromURL(fieldValue);
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
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (e) {
      print('Error: $e');
    }

    await FirebaseFirestore.instance
        .collection('user')
        .doc(depotDocumentId)
        .update({
      'images': imageUrl,
    });

    setState(() {
      currentImageUrl = imageUrl;
    });
  }

  Future<void> pickImageKatalog(int index) async {
    List<String> katalog = ['katalog1', 'katalog2', 'katalog3'];
    ImagePicker imagePicker2 = ImagePicker();
    XFile? file2 = await imagePicker2.pickImage(source: ImageSource.gallery);
    if (file2 == null) return;
    String field = katalog[index];
    String uniqueFileName2 = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRootKatalog = FirebaseStorage.instance.ref();
    Reference referenceDirImagesKatalog = referenceRootKatalog.child('katalog');
    Reference referenceImageToUploadKatalog =
        referenceDirImagesKatalog.child(uniqueFileName2);

    try {
      await referenceImageToUploadKatalog.putFile(File(file2.path));
      katalogUrl = await referenceImageToUploadKatalog.getDownloadURL();
    } catch (e) {
      print("error : $e");
    }
    DocumentSnapshot depotSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(depotDocumentId)
        .get();

    if (depotSnapshot.exists) {
      Map<String, dynamic>? data =
          depotSnapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey(field)) {
        String fieldValue = data[field];
        // Check if fieldValue is a valid URL
        if (fieldValue.startsWith('gs://') ||
            fieldValue.startsWith('https://')) {
          Reference referenceToDelete =
              FirebaseStorage.instance.refFromURL(fieldValue);
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
    await FirebaseFirestore.instance
        .collection('user')
        .doc(depotDocumentId)
        .update({
      field: katalogUrl,
    });

    setState(() {
      if (index == 0) {
        currentImageUrlKatalog = katalogUrl;
      } else if (index == 1) {
        currentImageUrlKatalog2 = katalogUrl;
      } else if (index == 2) {
        currentImageUrlKatalog3 = katalogUrl;
      }
    });
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
                  backgroundImage: currentImageUrl != ''
                      ? NetworkImage(currentImageUrl)
                      : null,
                  child: currentImageUrl == ''
                      ? Icon(Icons.edit, color: Colors.white)
                      : null,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _hargaROController,
                         keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Harga RO',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        enabled: isEditing && isRO,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _hargaAquaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Harga Aqua',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        enabled: isEditing && isMineral,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditLocationPage(),
                      ),
                    );
                  },
                  child: Text('Edit Lokasi'),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 180,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onLongPress: () => pickImageKatalog(0),
                          child: Container(
                            width: 180,
                            height: 180,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: currentImageUrlKatalog != ''
                                  ? Image.network(
                                      currentImageUrlKatalog,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () => pickImageKatalog(1),
                          child: Container(
                            width: 180,
                            height: 180,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: currentImageUrlKatalog2 != ''
                                  ? Image.network(
                                      currentImageUrlKatalog2,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onLongPress: () => pickImageKatalog(2),
                          child: Container(
                            width: 180,
                            height: 180,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: currentImageUrlKatalog3 != ''
                                  ? Image.network(
                                      currentImageUrlKatalog3,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
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
                    await prefs.remove('data_email');
                    await prefs.remove('data');
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
                    child: Text(isEditing ? 'Logout' : 'Logout'),
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
