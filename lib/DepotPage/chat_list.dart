import 'package:flutter/material.dart';
import 'package:galonku/DepotPage/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  static const nameRoute = '/chatpagelist';

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late List<ChatItem> chatItems;
  String? selectedUsername;
  String? selectedEmail;

  @override
  void initState() {
    super.initState();
    chatItems = List.generate(
      2,
      (index) => ChatItem(
        imageUrl: 'https://example.com/image.jpg',
        username: 'John Doe',
        text: 'Hello, how are you?',
        unreadCount: 2,
      ),
    );
    getEmailFromSharedPreferences();
  }

  Future<void> getEmailFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? email = sharedPreferences.getString('data_email');
    String? userName = sharedPreferences.getString('data_username');
    if (email != null && userName != null) {
      setState(() {
        selectedUsername = userName;
        selectedEmail = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatItems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(chatItems[index].imageUrl),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedUsername ?? ''),
                  SizedBox(width: 8),
                  Text(
                    'Timestamp Am',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              subtitle: Text(chatItems[index].text),
              trailing: chatItems[index].unreadCount > 0
                  ? CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 10,
                      child: Text(
                        chatItems[index].unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : null,
              onTap: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                String? selectedUsername = chatItems[index].username;
                sharedPreferences.setString('data', selectedUsername);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(email: selectedUsername),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add_comment_rounded),
        ),
      ),
    );
  }
}

class ChatItem {
  final String imageUrl;
  final String username;
  final String text;
  final int unreadCount;

  ChatItem({
    required this.imageUrl,
    required this.username,
    required this.text,
    required this.unreadCount,
  });
}
