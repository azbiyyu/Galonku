// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galonku/DepotPage/home_page_user.dart';
import 'package:galonku/LoginPage/mitra_input.dart';

class Verifikasi extends StatefulWidget {
  final bool isFromUserSignIn;
  static const nameRoute = '/verifikasi';

  const Verifikasi({Key? key, required this.isFromUserSignIn})
      : super(key: key);

  @override
  State<Verifikasi> createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
  String _phoneNumber = "";
  String _otpCode = "";
  String _verificationId = "";
  bool _isPhoneNumberInputted = false;
  Timer? _timer;
  Duration _timerDuration = const Duration(minutes: 2);
  bool _isOtpCodeInputted = false;


  Future<void> _verifyPhoneNumber() async {
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (widget.isFromUserSignIn) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MitraInput()),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageUser()),
        );
      }
    };

    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      print(
          'Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number verification failed')),
      );
    };

    // ignore: prefer_function_declarations_over_variables
    PhoneCodeSent codeSent = (String verificationId, int? resendToken) async {
      setState(() {
        _verificationId = verificationId;
        _timerDuration = const Duration(minutes: 2); // Reset ulang durasi
      });
    };
    _timer?.cancel(); //jika timer sudah berjalan
    // Mulai timer untuk pengiriman ulang kode
  _timer = Timer(_timerDuration, () {
    // Lakukan tindakan yang Anda inginkan saat waktu pengiriman ulang berakhir
    // Contoh: Menampilkan dialog atau memberi tahu pengguna untuk meminta pengiriman ulang kode.
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Resend OTP"),
        content: Text("The OTP code has expired. Do you want to resend the verification code?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              _verifyPhoneNumber(); // Kirim ulang kode verifikasi
              },
              child: Text("Resend"),
            ),
          ],
        ),
      );
    });
    // ignore: prefer_function_declarations_over_variables
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      setState(() {
        _verificationId = verificationId;
      });
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: _phoneNumber,
    verificationCompleted: verificationCompleted,
    verificationFailed: verificationFailed,
    codeSent: codeSent,
    codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    timeout: const Duration(minutes: 2), // Ubah durasi sesi menjadi 5 menit
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify phone number. Error: $e')),
      );
    }
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (widget.isFromUserSignIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MitraInput()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageUser()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to sign in with phone number. Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Color.fromARGB(69, 158, 231, 246),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Phone Authentication",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Enter your phone number to verify:",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Phone Number (+62)",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              _phoneNumber = value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_phoneNumber.isNotEmpty) {
                              setState(() {
                                _isPhoneNumberInputted = true;
                              });
                              _verifyPhoneNumber();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Please enter a phone number')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 52, 83, 209),
                          ),
                          child: Text("Verify Phone Number"),
                        ),
                        SizedBox(height: 16.0),
                        Visibility(
                          visible: _isPhoneNumberInputted,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Enter the OTP code:",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "OTP Code",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                onChanged: (value) {
                                  setState(() {
                                    _otpCode = value;
                                    _isOtpCodeInputted = value.length == 6; // Set nilai _isOtpCodeInputted berdasarkan panjang kode OTP
                                  });
                                },
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: _isOtpCodeInputted
                                    ? () {
                                        // _signInWithPhoneNumber();
                                        Navigator.pushNamed(context, MitraInput.nameRoute);
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 52, 83, 209),
                                ),
                                child: Text("Verify OTP"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
