import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class pesanan_user extends StatefulWidget {
  const pesanan_user({super.key});

  @override
  State<pesanan_user> createState() => _pesanan_userState();
}

class _pesanan_userState extends State<pesanan_user> {
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
                    backgroundImage: NetworkImage('URL_FOTO_PROFIL'),
                    radius: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  // Berikan konten tambahan di sini
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
