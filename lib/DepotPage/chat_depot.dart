import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:galonku/LoginPage/user_signin.dart';

class ChatDepot extends StatefulWidget {
  const ChatDepot({super.key});
  static const nameRoute = '/chatdepot';

  @override
  State<ChatDepot> createState() => _CHatDepotState();
}

class _CHatDepotState extends State<ChatDepot> {
  var faker = Faker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          return ChatItem(
            imageUrl: "https://picsum.photos/id/$index/200/300",
            title: faker.person.name(),
            subtitle: faker.lorem.sentence(),
            trailing: faker.date.justTime(),
          );
        },
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, UserSignIn.nameRoute);
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
