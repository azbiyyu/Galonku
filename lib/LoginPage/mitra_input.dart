import 'package:flutter/material.dart';
import 'package:galonku/Models/_heading.dart';
import 'package:galonku/Models/_image_upload.dart';

class MitraInput extends StatefulWidget {
  const MitraInput({super.key});
  static const nameRoute = '/mitrainput';

  @override
  State<MitraInput> createState() => _MitraInputState();
}

class _MitraInputState extends State<MitraInput> {
  bool _isROSelected = false;
  bool _isMineralSelected = false;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
