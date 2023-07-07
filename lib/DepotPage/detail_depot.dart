import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailDepot extends StatelessWidget {
  static const nameRoute = '/detaildepot';

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
        builder: (BuildContext context, AsyncSnapshot<String> usernameSnapshot) {
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

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Foto Katalog',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                  image: DecorationImage(
                                    image: NetworkImage(katalog3),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Username',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(username),
                        SizedBox(height: 16),
                        Text(
                          'Jam Buka - Tutup',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('$buka - $tutup'),
                        SizedBox(height: 16),
                        Text(
                          'Alamat',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(alamat),
                      ],
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
