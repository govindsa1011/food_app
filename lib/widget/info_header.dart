import 'package:flutter/material.dart';

class InfoHeader extends StatelessWidget {
  final String title;
  final Color textColor;
  final double fontSize;

  InfoHeader(
      {@required this.title,
      this.textColor = Colors.black,
      this.fontSize = 25});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: textColor,
        ));
  }
}
