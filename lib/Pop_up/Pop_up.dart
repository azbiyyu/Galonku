import 'package:flutter/material.dart';

class PopupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Tampilkan pop-up dialog ketika tombol ditekan
        _showDialog(context);
      },
      child: Text('Tampilkan Pop-up'),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Kembalikan dialog
      return AlertDialog(
        title: Text('Judul Pop-up'),
        content: Text('Ini adalah isi dari pop-up dialog.'),
        actions: [
          // Tambahkan tombol "Tutup" pada pop-up dialog
          TextButton(
            child: Text('Tutup'),
            onPressed: () {
              // Tutup pop-up dialog ketika tombol ditekan
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Popup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contoh Pop-up'),
        ),
        body: Center(
          child: PopupButton(),
        ),
      ),
    );
  }
}

