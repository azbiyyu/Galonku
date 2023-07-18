import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/chat_page.dart';
import 'package:galonku/DepotPage/pesan_galon_lokasi.dart';

import '../DesignSystem/_button_primary.dart';

class CommentCard extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onTap;
  final String email;

  const CommentCard({
    Key? key,
    required this.isLiked,
    required this.onTap,
    required this.email,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(widget.email),
        subtitle: Text('Komentar'),
        trailing: InkWell(
          onTap: widget.onTap,
          child: Icon(
            widget.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.isLiked ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}

class DetailDepot extends StatefulWidget {
  static const nameRoute = '/detaildepot';

  final String email;

  const DetailDepot({required this.email});

  @override
  State<DetailDepot> createState() => _DetailDepotState();
}

class _DetailDepotState extends State<DetailDepot> {
  bool _isLiked = false;
  String text_buka = '';

  Future<Map<String, dynamic>> _getDepotData(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getDepotData(widget.email),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> depotDataSnapshot) {
          if (depotDataSnapshot.connectionState == ConnectionState.waiting) {
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
            String username = depotData['username'] ?? '';
            // String email = depotData['email'] ?? '';
            bool isBuka = depotData['is_buka'] ?? false;

            // ignore: unrelated_type_equality_checks
            if(isBuka == true){
              text_buka = 'Buka';
            }else{
              text_buka = 'Tutup';
            }
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                'images/google_logo.png',
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$username Depot",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Rating'),
                                  Text(
                                    text_buka,
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatPage(email: widget.email), // Ganti dengan halaman DetailDepot yang sesuai
                                  ),
                                );
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
                      email: widget.email,
                    ),
                    SizedBox(height: 20),
                    BtnPrimary(
                      text: "Pesan Galon",
                      onPressed: () {
                        Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PesanGalonLokasi(email: widget.email),
                                  ),
                                );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
