import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galonku/DesignSystem/_button_primary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentCard extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;

  const CommentCard({
    Key? key,
    required this.isLiked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text('Nama'),
        subtitle: Text('Komentar'),
        trailing: InkWell(
          onTap: onTap,
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}

class DetailDepot extends StatefulWidget {
  static const nameRoute = '/detaildepot';

  @override
  State<DetailDepot> createState() => _DetailDepotState();
}

class _DetailDepotState extends State<DetailDepot> {
  bool _isLiked = false;

  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('data') ?? '';
  }

  Future<Map<String, dynamic>> _getDepotData(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Depot'),
      ),
      body: FutureBuilder<String>(
        future: _getUsername(),
        builder:
            (BuildContext context, AsyncSnapshot<String> usernameSnapshot) {
          if (usernameSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (usernameSnapshot.hasError) {
            return Center(
              child: Text('Error: ${usernameSnapshot.error}'),
            );
          } else {
            String username = usernameSnapshot.data ?? '';
            return FutureBuilder<Map<String, dynamic>>(
              future: _getDepotData(username),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> depotDataSnapshot) {
                if (depotDataSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (depotDataSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${depotDataSnapshot.error}'),
                  );
                } else {
                  Map<String, dynamic> depotData = depotDataSnapshot.data ?? {};
                  String katalog1 = depotData['katalog1'] ?? '';
                  String katalog2 = depotData['katalog2'] ?? '';
                  String katalog3 = depotData['katalog3'] ?? '';
                  String alamat = depotData['alamat'] ?? '';
                  String buka = depotData['buka'] ?? '';
                  String tutup = depotData['tutup'] ?? '';

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                      'images/google_logo.png',
                                    ), //ganti ambil, pp dari database
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          username,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text('Rating'),
                                        Text(
                                          'Keterangan Buka/Tutup',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Tambahkan logika navigasi ke halaman tujuan di sini
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      backgroundImage: AssetImage(
                                        'images/logo_chat.png',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Foto Katalog',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 16),
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(katalog1),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 16),
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(katalog2),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 16),
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(katalog3),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Jam Buka - Tutup',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('$buka - $tutup'),
                          SizedBox(height: 20),
                          Text(
                            'Alamat',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(alamat),
                          SizedBox(height: 20),
                          Text(
                            'Kolom Komentar',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // ...
                          CommentCard(
                            isLiked: _isLiked,
                            onTap: () {
                              setState(() {
                                _isLiked = !_isLiked;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          BtnPrimary(text: "Pesan Galon"),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
