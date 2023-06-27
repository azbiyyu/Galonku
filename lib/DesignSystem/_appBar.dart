import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(child: Text(title)),
      backgroundColor: Color.fromARGB(255, 52, 83, 209),
      toolbarHeight: 70, // Ubah ukuran AppBar sesuai kebutuhan
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(70.0); // Sesuaikan dengan ukuran AppBar yang telah diubah
}
