import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/bayar_galon.dart';
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
                      Text('Harga: Rp. 5000'),
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
                      Text('Harga: Rp. 7000'),
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
                  Navigator.pushNamed(context, BayarGalon.nameRoute);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
