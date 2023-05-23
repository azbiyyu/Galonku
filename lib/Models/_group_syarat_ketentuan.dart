import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class GroupSyaratKetentuan extends StatelessWidget {
  final VoidCallback? onTap;
  const GroupSyaratKetentuan({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 5),
              child: RichText(
                text: TextSpan(
                  text: 'Dengan menekan tombol daftar, maka kamu menyetujui ',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'syarat dan ketentuan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.blue[700],
                      ),
                      recognizer: TapGestureRecognizer()..onTap = onTap,
                    ),
                    TextSpan(
                      text: '.',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
