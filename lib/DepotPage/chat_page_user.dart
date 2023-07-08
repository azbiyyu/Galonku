import 'package:flutter/material.dart';

class ChatPageUser extends StatefulWidget {
  const ChatPageUser({Key? key}) : super(key: key);
  static const String nameRoute = '/chatpageuser';

  @override
  _ChatPageUserState createState() => _ChatPageUserState();
}

class _ChatPageUserState extends State<ChatPageUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _chatMessages = [];

  void _sendMessage() {
    String message = _messageController.text;

    // Kirim logika pesan

    // Tambahkan pesan baru ke daftar chatMessages
    setState(() {
      _chatMessages.add({'role': 'A', 'message': message});
    });

    // Tampilkan pop-up
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesan terkirim: $message'),
      ),
    );

    // Bersihkan input teks
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                String role = _chatMessages[index]['role']!;
                String message = _chatMessages[index]['message']!;

                return ListTile(
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: Text('Nama user', textAlign: TextAlign.right),
                  ),
                  subtitle: Align(
                    alignment: Alignment.centerRight,
                    child: Text(message, textAlign: TextAlign.right),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
