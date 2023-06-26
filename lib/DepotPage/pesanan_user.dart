import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

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
                    "Riwayat",
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
                  color: Color.fromARGB(108, 231, 229, 221),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hari ini",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: 10,
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (context, index) {
                            return ChatItem(
                              imageUrl:
                                  "https://picsum.photos/id/$index/200/300",
                              title: faker.person.name(),
                              subtitle: faker.lorem.sentence(),
                              trailing: faker.date.justTime(),
                              isAccepted: index % 2 == 0,
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
  final bool isAccepted;

  const ChatItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.isAccepted,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconDataYes = Icons.check;
    IconData iconDataNo = Icons.clear;
    Color iconColorYes = Colors.green;
    Color iconColorNo = Colors.red;
    Color hexToColor(String code) {
      return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    Color succes_label = hexToColor("#2AA746");
    return InkWell(
      onTap: () {
        // Handle item click event here
      },
      child: Container(
        decoration: BoxDecoration(
          color: succes_label
              .withOpacity(0.2), // Ganti warna background sesuai kebutuhan
          borderRadius:
              BorderRadius.circular(10), // Atur border radius sesuai kebutuhan
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  // Handle yes icon click event here
                },
                child: Icon(
                  iconDataYes,
                  color: iconColorYes,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  // Handle no icon click event here
                },
                child: Icon(
                  iconDataNo,
                  color: iconColorNo,
                ),
              ),
            ],
          ),
          trailing: Text(
            trailing,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
