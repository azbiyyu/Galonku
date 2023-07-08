import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPageDepot extends StatefulWidget {
  const ChatPageDepot({Key? key, required this.email}) : super(key: key);
  static const String nameRoute = '/chatpageuser';

  final String email;

  @override
  _ChatPageDepotState createState() => _ChatPageDepotState();
}

class _ChatPageDepotState extends State<ChatPageDepot> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _chatMessages = [];

  String _username = '';

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')  // Ganti dengan koleksi yang sesuai
          .where('email', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _username = querySnapshot.docs[0]['username'];
        });
      } else {
        setState(() {
          _username = 'Username tidak ditemukan';
        });
      }
    } catch (error) {
      setState(() {
        _username = 'Error: $error';
      });
    } 
  }

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
          Container(
            color: Colors.lightBlue,
            padding: EdgeInsets.all(16),
            child: Text(
              'Username: $_username',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
