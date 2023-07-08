import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/pesan_galon_produk.dart';
import 'package:galonku/Models/_button_primary.dart';

class PesanGalonLokasi extends StatefulWidget {
  const PesanGalonLokasi({Key? key});
  static const nameRoute = '/PesanGalonLokasi';
  @override
  State<PesanGalonLokasi> createState() => _PesanGalonLokasiState();
}

class _PesanGalonLokasiState extends State<PesanGalonLokasi> {
  TextEditingController _alamatController = TextEditingController();

  List<String> _historyAlamat = [
    'Alamat 1',
    'Alamat 2',
    'Alamat 3',
    'Alamat 4',
  ];

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Lokasi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.place),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _alamatController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan alamat',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Action when dropdown icon is clicked
                      },
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Action when "Pilih Peta" button is clicked
                },
                child: Text('Pilih Peta'),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'History Alamat',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _historyAlamat.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(_historyAlamat[index]),
                      onTap: () {
                        // Action when history address is tapped
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 50,
              ),
              BtnPrimary(
                text: "Order",
                onPressed: () {
                  Navigator.pushNamed(context, PesanGalonProduk.nameRoute);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
