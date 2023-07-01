import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:galonku/DesignSystem/_appBar.dart';
import 'package:galonku/LandingPage/login_role.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _alamatController.text = prefs.getString('alamat') ?? '';
      _produkController.text = prefs.getString('produk') ?? '';
      _bukaController.text = prefs.getString('buka') ?? '';
      _tutupController.text = prefs.getString('tutup') ?? '';
    });
  }

  void toggleEditing() async {
    if (isEditing) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = _usernameController.text;
      String email = _emailController.text;
      String alamat = _alamatController.text;
      String produk = _produkController.text;
      String buka = _bukaController.text;
      String tutup = _tutupController.text;

      await prefs.setString('username', username);
      await prefs.setString('email', email);
      await prefs.setString('alamat', alamat);
      await prefs.setString('produk', produk);
      await prefs.setString('buka', buka);
      await prefs.setString('tutup', tutup);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil disimpan')),
      );
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

  void addImage(String imagePath) {
    setState(() {
      images.add(imagePath);
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      addImage(imageFile.path);
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
                onTap: () {
                  // Logika ketika tombol edit foto ditekan
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
