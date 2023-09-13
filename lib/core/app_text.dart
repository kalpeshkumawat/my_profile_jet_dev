import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final dynamic size;
  final FontWeight fontWeight;

  const AppText({super.key,
    required this.text,
    required this.size,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
            text,
            style:  TextStyle(
                          fontSize: size,
                          fontWeight: fontWeight,
                          color: Colors.black87),
          );
  }
}