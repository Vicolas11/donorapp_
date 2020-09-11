import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/modals/constant.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'messages_screen.dart';
import 'package:donorapp/services/database.dart';

class SearchResult extends StatefulWidget {
  SearchResult({
    this.snapshot
  });
  final snapshot;

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchResultSnapshot;
  var awaitChatTime;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, ContentProvider>(
      builder: (context, themeNotifier, contentProvider, child) =>
          InkWell(
            onTap: () => Navigator.push(context,
                CupertinoPageRoute(builder: (context) =>
                    MessagesScreen(
                      peerId: widget.snapshot['uid'],
                      colorIdx: widget.snapshot['ColorIdx'],
                      profileName: widget.snapshot['Full Name'],
                      profilePix: widget.snapshot['PhotoUrl'],
                      initialText: '${widget.snapshot['Full Name'].toString().substring(0,1)}',
                    )
                )
            ),
            child: Container(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        maxRadius: 30.0,
                        backgroundColor: Colors.amber,
                        child: Center(
                          child: CustomText(
                            text: '${widget.snapshot['Full Name'].toString().substring(0,1)}',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: CustomText(
                        text: widget.snapshot['Full Name'],
                        fontSize: 20,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      subtitle: CustomText(
                        text: widget.snapshot["Email"],
                        fontSize: 14,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
                      ),
                      trailing: CustomText(
                        text: awaitChatTime ?? '${DateTime.now().hour}:${DateTime.now().minute}',
                        fontSize: 14,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
                      indent: 80.0,
                    )
                  ],
                )
            ),
          )
    );
  }
}
