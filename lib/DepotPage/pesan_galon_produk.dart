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
  int harga_ro = 0;
  int harga_aqua = 0;
  String kirimEmail = '';
  String total = '';
  bool sedia_ro = false;
  bool sedia_mineral = false;
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
    int hargaAqua = userData['hargaAqua'];
    int hargaRO = userData['hargaRO'];
    bool? mineral = userData['Mineral'] ?? false;
    bool? ro = userData['RO'] ?? false;

    setState(() {
      harga_aqua = hargaAqua;
      harga_ro = hargaRO;
      sedia_mineral = mineral!;
      sedia_ro = ro!;

    });
  } else {
    print("Data tidak ditemukan");
  }
}
  void _mineralIncrement() {
    if (sedia_mineral == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produk Air Mineral tidak tersedia.'),
        ),
      );
    } else {
      setState(() {
        _mineralCount++;
      });
    }
  }

  void _roIncrement() {
    if (sedia_ro == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produk Air RO tidak tersedia.'),
        ),
      );
    } else {
      setState(() {
        _roCount++;
      });
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
                            !sedia_mineral ? null : (){
                              setState(() {
                                _mineralCount--;
                              });
                            };
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
                            _mineralIncrement();
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
                            _roIncrement();
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
                onChanged: _eWalletChecked || _rekeningChecked ? null : 
                (bool? value) {
                  setState(() {
                    _codChecked = value!;
                    if (_codChecked) {
                      _eWalletChecked = false;
                      _rekeningChecked = false;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: _codChecked ? Colors.blue : null,
                secondary: _eWalletChecked || _rekeningChecked ? Icon(Icons.block) : null,
              ),
              CheckboxListTile(
                title: Text('E-Wallet'),
                value: _eWalletChecked,
                onChanged: _codChecked || _rekeningChecked ? null :
                (bool? value) {
                  setState(() {
                    _eWalletChecked = value!;
                    if (_eWalletChecked) {
                      _codChecked = false;
                      _rekeningChecked = false;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: _eWalletChecked ? Colors.blue : null,
                secondary: _codChecked || _rekeningChecked ? Icon(Icons.block) : null,
              ),
              CheckboxListTile(
                title: Text('Rekening'),
                value: _rekeningChecked,
                onChanged: _codChecked || _eWalletChecked ? null :
                (bool? value) {
                  setState(() {
                    _rekeningChecked = value!;
                    if (_rekeningChecked) {
                      _codChecked = false;
                      _eWalletChecked = false;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: _rekeningChecked ? Colors.blue : null,
                secondary: _codChecked || _eWalletChecked ? Icon(Icons.block) : null,
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
                    'Rp. ${harga_aqua * _mineralCount}',
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
                    'Rp. ${harga_ro * _roCount}',
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
                    'Rp. ${(harga_aqua * _mineralCount) + (harga_ro * _roCount) + 1000 + 500}',
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
                text: "Bayar Disini",
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
