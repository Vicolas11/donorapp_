import 'package:donorapp/constants/theme_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class RoundButton extends StatelessWidget {
  RoundButton({this.buttonTitle, this.buttonColor = kPrimaryColor,
    this.onPressed, this.icon, this.iconColor, this.iconSize});
  final String buttonTitle;
  final Color buttonColor;
  final Function onPressed;
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 1.5,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, size: iconSize, color: iconColor,),
              SizedBox(width: MediaQuery.of(context).size.width * 0.005,),
              Text(
                  buttonTitle,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}