import 'package:flutter/material.dart';

class CardCarousel extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget image;
  final Color color;

  const CardCarousel({
    Key? key,
    required this.text,
    required this.borderRadius,
    required this.image,
    required this.color,
    this.height = 500,
    this.width = 318,
    this.fontSize = 15,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          margin: EdgeInsets.all(20),
          color: color,
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image,
                Padding(
                  padding: EdgeInsets.only(right: 30, left: 30),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
