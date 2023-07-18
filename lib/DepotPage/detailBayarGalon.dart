import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBayarGalon extends StatefulWidget {
  final String email;
  final int mineralCount;
  final int roCount;
  final bool codChecked;
  final bool eWalletChecked;
  final bool rekeningChecked;
  final int hargaRo;
  final int hargaAqua;
  static const nameRoute = '/BayarGalon';

  const DetailBayarGalon({
    Key? key,
    required this.email,
    required this.mineralCount,
    required this.roCount,
    required this.codChecked,
    required this.eWalletChecked,
    required this.rekeningChecked,
    required this.hargaRo,
    required this.hargaAqua,
  }) : super(key: key);

  @override
  _DetailBayarGalonState createState() => _DetailBayarGalonState();
}

class _DetailBayarGalonState extends State<DetailBayarGalon> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanned = false;
  bool isPaymentCompleted = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanned && scanData != null) {
        _handleScanResult(scanData.code!);
        isScanned = true;
      }
    });
  }

  void _handleScanResult(String scanData) async {
  // Lakukan logika pemrosesan hasil pemindaian QR di sini
  // Misalnya, verifikasi pembayaran, alihkan ke aplikasi yang sesuai

  // Contoh: Alihkan ke aplikasi Shopee jika QR code berisi skema "shopee://"
  if (scanData.startsWith('shopee://')) {
    // ignore: deprecated_member_use
    if (await canLaunch(scanData)) {
      // ignore: deprecated_member_use
      await launch(scanData);
      setState(() {
        isPaymentCompleted = true;
      });
    } else {
      print('Tidak dapat membuka URL: $scanData');
    }
  }
}


  Widget buildOrderButton() {
    if (isPaymentCompleted) {
      return ElevatedButton(
        onPressed: () {
          // Tambahkan fungsi yang akan dijalankan saat tombol ditekan
        },
        child: Text('Detail Pesanan'),
      );
    } else {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          primary: Colors.yellow,
        ),
        child: Text('Menunggu Pembayaran'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bukti Pembayaran'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: buildOrderButton(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan QR Code untuk Pembayaran',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
