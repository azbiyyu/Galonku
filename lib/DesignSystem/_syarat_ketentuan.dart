import 'package:flutter/material.dart';

class SyaratKetentuan extends StatelessWidget {
  static const nameRoute = '/SyaratKetentuan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Syarat dan Ketentuan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Syarat dan Ketentuan',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextSection(
                title:
                    '1. Penggunaan aplikasi ini tunduk pada ketentuan berikut:',
                content: [
                  'a. Pengguna harus setuju untuk tidak menyalahgunakan aplikasi.',
                  'b. Pengguna bertanggung jawab atas informasi yang diberikan.',
                  'c. Pengguna harus mematuhi hukum yang berlaku dalam menggunakan aplikasi.',
                ],
              ),
              SizedBox(height: 16.0),
              TextSection(
                title: '2. Privasi:',
                content: [
                  'a. Aplikasi ini akan menjaga kerahasiaan data pengguna.',
                  'b. Data pribadi pengguna tidak akan dibagikan kepada pihak ketiga.',
                ],
              ),
              SizedBox(height: 16.0),
              TextSection(
                title: '3. Penyedia Layanan:',
                content: [
                  'a. Aplikasi ini disediakan oleh ABC Company.',
                  'b. ABC Company tidak bertanggung jawab atas kerugian yang timbul akibat penggunaan aplikasi ini.',
                ],
              ),
              SizedBox(height: 16.0),
              TextSection(
                title: '4. Perubahan Ketentuan:',
                content: [
                  'a. ABC Company berhak untuk mengubah syarat dan ketentuan tanpa pemberitahuan sebelumnya.',
                  'b. Perubahan akan berlaku segera setelah diposting di aplikasi ini.',
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Dengan menggunakan aplikasi ini, Anda dianggap telah membaca, memahami, dan menyetujui semua syarat dan ketentuan yang berlaku.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  final String title;
  final List<String> content;

  TextSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
