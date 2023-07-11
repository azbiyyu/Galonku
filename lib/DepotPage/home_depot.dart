import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:galonku/DesignSystem/_appBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDepot extends StatefulWidget {
  static const nameRoute = '/homedepot';

  @override
  // ignore: library_private_types_in_public_api
  _HomeDepotState createState() => _HomeDepotState();
}

class _HomeDepotState extends State<HomeDepot> {
  bool isROSelected = false;
  bool isMineralSelected = false;
  bool isBukaTutup = false;

  @override
  void initState() {
    super.initState();
  }

  void _saveData(bool status) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? mail = sharedPreferences.getString('email');

  String? emailfield = mail;

  final collectionUser = FirebaseFirestore.instance.collection('user');
  final querySnapshot = await collectionUser.where('email', isEqualTo: emailfield).limit(1).get();

  if (querySnapshot.docs.isNotEmpty) {
    final docUser = querySnapshot.docs.first;
    final docId = docUser.id;

    bool updatedIsBukaTutup = !docUser.data()['is_buka']; // Toggle nilai is_buka

    await collectionUser.doc(docId).update({
      'is_buka': updatedIsBukaTutup,
    });
    setState(() {
      isBukaTutup = updatedIsBukaTutup;
    });
  } else {
    print("data tidak ada");
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Depot"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pesanan",
                      style: TextStyle(fontSize: 20),
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage('images/page_1.png'),
                      radius: 20,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.asset('images/Depot_Uang.png'),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pendapatan saat ini'),
                        Text(
                          'Rp.5.542.000',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('1 Juli- 25 Juli'),
                      ],
                    ),
                    Spacer(),
                    Switch(
                      value: isBukaTutup,
                      onChanged: (value) {
                        setState(() {
                          var status = !isBukaTutup;
                          _saveData(status);
                          // isBukaTutup = true;
                        });  
                      },
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Stock Ready.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                child: Row(
                  children: [
                    Switch(
                      value: isROSelected,
                      onChanged: (value) {
                        setState(() {
                          isROSelected = value;
                        });
                        // Logika ketika tombol RO diubah
                      },
                      activeColor: Colors.blue,
                    ),
                    Text('RO'),
                    SizedBox(width: 10),
                    Switch(
                      value: isMineralSelected,
                      onChanged: (value) {
                        setState(() {
                          isMineralSelected = value;
                        });
                        // Logika ketika tombol Mineral diubah
                      },
                      activeColor: Colors.orange,
                    ),
                    Text('Mineral'),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset('images/grafik_profit.png'),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('images/rata_pendapatan.png'),
                          SizedBox(width: 10),
                          Text("Rata-rata pendapatan/bulan"),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "RP.",
                            style: TextStyle(fontSize: 40),
                          ),
                          Text(
                            "6.820.000",
                            style: TextStyle(fontSize: 40),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('images/arrow_profit.png'),
                          Text('10% dari 6.138.000, 30 hari sebelumnya'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ChatItem(
                    imageUrl: "https://picsum.photos/id/$index/200/300",
                    title: faker.person.name(),
                    subtitle: faker.lorem.sentence(),
                    trailing: faker.date.justTime(),
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

class ChatItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String trailing;

  const ChatItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(context, UserLogin.nameRoute);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(trailing),
      ),
    );
  }
}
