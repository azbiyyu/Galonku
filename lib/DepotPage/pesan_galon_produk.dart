import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/detailBayarGalon.dart';
import 'package:galonku/Models/_button_primary.dart';

class PesanGalonProduk extends StatefulWidget {
  final String email;
  const PesanGalonProduk({Key? key, required this.email});
  static const nameRoute = '/PesanGalonProduk';

  @override
  State<PesanGalonProduk> createState() => _PesanGalonProdukState();
}

class _PesanGalonProdukState extends State<PesanGalonProduk> {
  int _mineralCount = 0;
  int _roCount = 0;
  bool _codChecked = false;
  bool _eWalletChecked = false;
  bool _rekeningChecked = false;
  String harga_ro = '';
  String harga_aqua = '';
  String kirimEmail = '';
  String total = '';
  @override
  void initState() {
    super.initState();
    _loadData();
    kirimEmail = widget.email;
  }
  void _loadData() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('user')
      .where('email', isEqualTo: widget.email)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Retrieve the document snapshot
    DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

    // Get the field values from the document
    Map<String, dynamic>? userData = documentSnapshot.data() as Map<String, dynamic>;
    if (userData != null) {
      String hargaAqua = userData['harga_aqua'] ?? '';
      String hargaRO = userData['harga_ro'] ?? '';

      setState(() {
        harga_aqua = hargaAqua;
        harga_ro = hargaRO;
      });
    }
  } else {
    print("Data tidak ditemukan");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Produk'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 30,
              ),
              Card(
                child: ListTile(
                  title: Text('Air Mineral'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Harga: Rp. $harga_aqua'),
                      Text(_mineralCount > 0 ? 'Ready' : 'Habis'),
                    ],
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(113, 136, 166,
                          251), // Ubah warna background Row menjadi kuning
                      borderRadius: BorderRadius.circular(
                          20.0), // Tambahkan border radius pada Row
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_mineralCount > 0) {
                                _mineralCount--;
                              }
                            });
                          },
                          icon: Icon(Icons.remove),
                          color: Colors.red, // Ubah warna ikon menjadi merah
                        ),
                        Text(
                          '$_mineralCount',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _mineralCount++;
                            });
                          },
                          icon: Icon(Icons.add),
                          color: Colors.green, // Ubah warna ikon menjadi hijau
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                child: ListTile(
                  title: Text('Air RO'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Harga: Rp. $harga_ro'),
                      Text(_roCount > 0 ? 'Ready' : 'Habis'),
                    ],
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(113, 136, 166,
                          251), // Ubah warna background Row menjadi biru
                      borderRadius: BorderRadius.circular(
                          20.0), // Tambahkan border radius pada Row
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_roCount > 0) {
                                _roCount--;
                              }
                            });
                          },
                          icon: Icon(Icons.remove),
                          color: Colors.red, // Ubah warna ikon menjadi merah
                        ),
                        Text(
                          '$_roCount',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _roCount++;
                            });
                          },
                          icon: Icon(Icons.add),
                          color: Colors.green, // Ubah warna ikon menjadi hijau
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckboxListTile(
                title: Text('COD'),
                value: _codChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _codChecked = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text('E-Wallet'),
                value: _eWalletChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _eWalletChecked = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text('Rekening'),
                value: _rekeningChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _rekeningChecked = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 16.0),
              Text(
                'Biaya',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '1. Air mineral:',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Text(
                    'Rp. ${_mineralCount * 5000}',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '2. Air RO:',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Text(
                    'Rp. ${_roCount * 7000}',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '3. Akomodasi:',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Text(
                    'Rp. 1000',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '4. Admin:',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Text(
                    'Rp. 500',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Divider(
                thickness: 2.0,
                height: 20.0,
                color: Colors.black,
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Rp. ${(_mineralCount * 5000) + (_roCount * 7000) + 1000 + 500}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              BtnPrimary(
                text: "Bayar",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailBayarGalon(
                            email: kirimEmail, 
                            codChecked: _codChecked, 
                            eWalletChecked: _eWalletChecked, 
                            hargaAqua: harga_aqua, 
                            hargaRo: harga_ro, 
                            mineralCount: _mineralCount, 
                            rekeningChecked: _rekeningChecked, 
                            roCount: _roCount), // Ganti dengan halaman DetailDepot yang sesuai
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
