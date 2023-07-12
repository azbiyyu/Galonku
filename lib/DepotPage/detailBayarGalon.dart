import 'package:flutter/material.dart';

class DetailBayarGalon extends StatefulWidget {
  final String email;
  final int mineralCount;
  final int roCount;
  final bool codChecked;
  final bool eWalletChecked;
  final bool rekeningChecked;
  final String hargaRo;
  final String hargaAqua;
  static const nameRoute = '/BayarGalon';

  const DetailBayarGalon({
    super.key,
    required this.email,
    required this.mineralCount,
    required this.roCount,
    required this.codChecked,
    required this.eWalletChecked,
    required this.rekeningChecked,
    required this.hargaRo,
    required this.hargaAqua,
    });

  @override
  State<DetailBayarGalon> createState() => _DetailBayarGalonState();
}

class _DetailBayarGalonState extends State<DetailBayarGalon> {
  String emailDetail  = '';
  int mineralCount = 0;
  int roCount = 0;
  bool codChecked = false;
  bool eWalletChecked = false;
  bool rekeningChecked = false;
  String hargaRo = '';
  String hargaAqua = '';

  @override
  void initState() {
    super.initState();
    emailDetail = widget.email;
    mineralCount = widget.mineralCount;
    roCount = widget.roCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bukti Pembayaran'),
        ),
      body: Container(
        child: Text(emailDetail),
      ),
    );
  }
}