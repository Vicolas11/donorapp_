import 'package:donorapp/constants/constants.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe, this.time});
  final String text, sender;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeNotifier>(
      builder: (BuildContext context, themeNotifier, child) =>
       Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$sender',
                style: TextStyle(
                    color: themeNotifier.darkTheme ? Colors.black45 : Colors.white70
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
              Material(
                borderRadius: isMe ? kBorderRadiusRight : kBorderRadiusLeft,
                color: isMe ? (themeNotifier.darkTheme ? kPrimaryColor : Colors.lightBlue) : Colors.white,
                elevation: 2.0,
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children:  [
                        Text(
                          '$text',
                          style: TextStyle(
                            fontSize: 16,
                            color: isMe? Colors.white: Colors.black,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                        Text(
                          '$time',
                          textAlign: isMe? TextAlign.right : TextAlign.left,
                          style: TextStyle(
                              fontSize: 12,
                              color: isMe? Colors.white70: Colors.black38),
                        ),
                      ]
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}