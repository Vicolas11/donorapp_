import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText({this.text, this.color, this.textAlign, this.fontWeight, this.fontSize});
  final String text;
  final Color color;
  final TextAlign textAlign;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

