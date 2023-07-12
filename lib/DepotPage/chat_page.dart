import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.email}) : super(key: key);
  static const String nameRoute = '/chatpage';

  final String email;

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
    String emailChat = widget.email;
    // ignore: unnecessary_null_comparison
    if(emailChat != null){
      setState(() {
        _username = "$emailChat Depot";
      });
    }else{
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('user')  // Ganti dengan koleksi yang sesuai
            .where('email', isEqualTo: emailChat)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            _username = querySnapshot.docs[0].get('username');
          });
        } else {
          setState(() {
            _username = '';
          });
        }
      } catch (error) {
        setState(() {
          _username = 'Error: $error';
        });
      } 
    }
  }

  void _sendMessage() {
    String message = _messageController.text;

    // Kirim logika pesan

    // Tambahkan pesan baru ke daftar chatMessages
    setState(() {
      _chatMessages.add({'role': 'A', 'message': message});
    });
   
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
        centerTitle: true,
        title: Text('Chat'),
        actions: [
          IconButton(
            onPressed: (){
          }, icon: Icon(Icons.search)),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.more_vert))
        ],
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

                return Align(
                  alignment: role == 'A' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: role == 'A' ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            )

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
