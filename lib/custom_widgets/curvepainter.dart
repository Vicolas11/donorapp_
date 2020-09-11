import 'package:donorapp/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CurvePainter extends CustomPainter {
  CurvePainter({this.context});
  final BuildContext context;
  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;

    var paint = Paint();
    var provide = Provider.of<ThemeNotifier>(context, listen: false);
    paint.color = provide.darkTheme ? Color(0xfff9f8fd) : Color(0xFF010048);
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.10);
    path.quadraticBezierTo(width * 0.04, height * 0.05, width * 0.15, height * 0.05);
    path.lineTo(width * .85, height * 0.05);
    path.quadraticBezierTo(width * 0.96, height * 0.05, width, height * 0.01);
    path.lineTo(width, height);
    path.lineTo(0, height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}