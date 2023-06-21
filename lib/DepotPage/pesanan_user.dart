import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:faker/faker.dart';
import 'package:galonku/LoginPage/user_login.dart';

class PesananUser extends StatefulWidget {
  static const nameRoute = '/PesananUser';
  @override
  State<PesananUser> createState() => _PesananUserState();
}

class _PesananUserState extends State<PesananUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pelanggan",
                    style: TextStyle(fontSize: 20),
                  ),
                  CircleAvatar(
                    // backgroundImage: NetworkImage('URL_FOTO_PROFIL'),
                    radius: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: Color.fromARGB(147, 186, 185, 181),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hari ini",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigasi ke halaman riwayat
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => RiwayatPage()));
                              },
                              child: Text(
                                "Cek riwayat",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ChatItem(
                              imageUrl:
                                  "https://picsum.photos/id/$index/200/300",
                              title: faker.person.name(),
                              subtitle: faker.lorem.sentence(),
                              trailing: faker.date.justTime(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
        //Navigator.pushNamed(context, UserLogin.nameRoute);
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
