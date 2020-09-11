import 'package:donorapp/constants/theme_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';

class ProfilePaint extends CustomPainter {
  ProfilePaint({this.context});
  final BuildContext context;
  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    var paint = Paint();
    var provide = Provider.of<ThemeNotifier>(context, listen: false);
    paint.color = provide.darkTheme ? Color(0xfff9f8fd) : Color(0xFFA5D0E6);
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(width * 0.3, height * 0.10, width * 0.50, height * 0.10);
    path.quadraticBezierTo(width * 0.7, height * 0.10, width, height * 0.0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}