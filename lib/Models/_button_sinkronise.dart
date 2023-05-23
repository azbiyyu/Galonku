import 'package:flutter/material.dart';

class BtnSinkronise extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback? onPressed;

  const BtnSinkronise({
    Key? key,
    required this.image,
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
          Color.fromARGB(255, 255, 255, 255),
        ),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: Colors.blue),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(double.infinity, 50),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                text,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
