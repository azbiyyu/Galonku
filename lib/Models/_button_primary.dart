import 'package:flutter/material.dart';

class BtnPrimary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const BtnPrimary({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 20),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Color.fromARGB(255, 52, 83, 209),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(double.infinity, 50),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
