import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/pesan_galon_produk.dart';
import 'package:galonku/Models/_button_primary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class PesanGalonLokasi extends StatefulWidget {
  final String email;
  const PesanGalonLokasi({Key? key, required  this.email});
  static const nameRoute = '/PesanGalonLokasi';
  @override
  State<PesanGalonLokasi> createState() => _PesanGalonLokasiState();
}

class _PesanGalonLokasiState extends State<PesanGalonLokasi> {
  TextEditingController _alamatController = TextEditingController();

  List<String> _historyAlamat = [];
  int _selectedAddressIndex = -1;
  String kirimEmail = '';
  @override
  void initState() {
    super.initState();
    _loadHistoryData();
    kirimEmail = widget.email;
  }

  void _loadHistoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('email') ?? '';

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('history')
        .where('email', isEqualTo: userEmail)
        .orderBy('timestamp', descending: true)
        .limit(4)
        .get();

    List<String> loadedHistory = [];
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        loadedHistory.add(doc['address']);
      }
    }

    setState(() {
      _historyAlamat = loadedHistory;
      
    });
  }



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
                        onChanged: (value) {
                          setState(() {
                            _selectedAddressIndex = -1;
                          });
                        },
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
                        _selectedAddressIndex = index;
                        _alamatController.text = _historyAlamat[_selectedAddressIndex];
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
                onPressed: () async {
                  String enteredAddress = _alamatController.text.trim();
                  if(enteredAddress.isNotEmpty && !_historyAlamat.contains(enteredAddress)){
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String email = prefs.getString('email') ?? '';

                    DocumentReference docRef = FirebaseFirestore.instance.collection('history').doc();
                    docRef.set({
                      'documentId': docRef.id,
                      'address': enteredAddress,
                      'timestamp': Timestamp.now(),
                      'email': email,
                    });

                    setState(() {
                      if (_historyAlamat.length >= 4) {
                        _historyAlamat.removeLast();
                      }
                      _historyAlamat.insert(0, enteredAddress);
                      _alamatController.clear();
                    });
                  }  
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PesanGalonProduk(email: kirimEmail), // Ganti dengan halaman DetailDepot yang sesuai
                                  ),
                                );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
