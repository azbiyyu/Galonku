import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

class HomeDepot extends StatefulWidget {
  static const nameRoute = '/homedepot';

  @override
  _HomeDepotState createState() => _HomeDepotState();
}

class _HomeDepotState extends State<HomeDepot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    // backgroundImage: NetworkImage('URL_FOTO_PROFIL'),
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
                      Text('Teks 1'),
                      Text('Teks 2'),
                      Text('Teks 3'),
                    ],
                  ),
                  Spacer(),
                  Switch(
                    value: true,
                    onChanged: (value) {
                      // logika ketika switch button diubah
                    },
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
                  child: ListView.builder(
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
