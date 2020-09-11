import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/constants.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/custom_widgets/messages_bubble.dart';
import 'package:donorapp/modals/constant.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:donorapp/screens/chat_screen.dart';
import 'package:donorapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesScreen extends StatefulWidget {
  static final routeName = 'messages_screen';
  MessagesScreen({
    this.peerId,
    this.profilePix,
    this.colorIdx,
    this.chatRoomId,
    this.idx,
    this.profileName,
    this.autoFocus=false,
    this.initialText});
  final int idx, colorIdx;
  final String chatRoomId, peerId, profilePix;
  final String initialText, profileName;
  final bool autoFocus;

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String messageText;
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final _textController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController listScrollController = ScrollController();
  var chatTime;
  int count = 0;
  SharedPreferences sharedPrefs;
  User loginUser;

  String groupChatId;
  String id;
  int _limit = 20;
  final int _limitIncrement = 20;
  bool showSendBtn = false;

  chatTimePushed() {
    Timestamp ts = Timestamp.now();
    DateTime dateTime = ts.toDate();
    var chatTimePush = DateFormat.jm().format(dateTime);
    return chatTimePush;
  }

  scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
        listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(scrollListener);
    groupChatId = '';
    readLocal();
    getNewUser();
    chatTimePushed();
  }

  onSendMessage() async {
    if (_textController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        'idFrom': id,
        'idTo': widget.peerId,
        "messages": _textController.text,
        'time': DateTime.now().millisecondsSinceEpoch.toString(),
        'messageDate': Timestamp.now(),
        'sender': sharedPrefs.getString('Email') ?? loginUser.email,
      };

      var documentReference = FirebaseFirestore.instance.collection('messages')
          .doc(groupChatId).collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async =>
        transaction.set(documentReference, chatMessageMap)
      );
      setState((){
        count += 1;
      });
      FirebaseFirestore.instance.collection('users').doc(loginUser.uid).update({
        'Count': count,
        'ChatTimePushed': chatTimePushed(),
        'RecentChat': _textController.text,
      });
      _textController.text = "";
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  readLocal() async {
    sharedPrefs = await SharedPreferences.getInstance();
    id = sharedPrefs.getString('id') ?? '';
    if (id.hashCode <= widget.peerId.hashCode) {
      groupChatId = '$id-${widget.peerId}';
      ChatScreen(groupChatId: groupChatId);
    } else {
      groupChatId = '${widget.peerId}-$id';
      ChatScreen(groupChatId: groupChatId);
    }
    FirebaseFirestore.instance.collection('users').doc(id).update({'ChattingWith': widget.peerId});
    setState(() { });
  }

  void getNewUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        loginUser = currentUser;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var provide = Provider.of<ContentProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Consumer2<ThemeNotifier, ContentProvider>(
          builder: (context, themeNotifier, contentProvider, child) =>
           Container(
            color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //Customized AppBar
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: IconButton(
                            icon: Icon(
                                Icons.arrow_back_ios,
                                color: themeNotifier.darkTheme ? Colors.white70 : Color(0xFFA5D0E6),
                                size: 25,
                            ),
                            onPressed: () => Navigator.pop(context, chatTime),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: ListTile(
                          leading: widget.profilePix != null ?
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                            child: SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: widget.profilePix,
                                  fit: BoxFit.cover,
                                  width: 25.0,
                                  height: 25.0,
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048)
                                      ),
                                    ),
                                    width: 25.0,
                                    height: 25.0,
                                    padding: EdgeInsets.all(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ) :
                          CircleAvatar(
                            maxRadius: 30.0,
                            backgroundColor: contentProvider.randColors[widget.colorIdx],
                            child: Center(
                              child: CustomText(
                                text: widget.initialText,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: CustomText(
                            text: widget.profileName,
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                          subtitle: CustomText(
                            text: 'Active Now',
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          trailing: CustomText(
                            text: '...',
                            fontSize: 34,
                            color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.3) : Color(0xFFA5D0E6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                //MAIN CONTENT
                Expanded(
                  child: groupChatId == ''
                      ? Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03002E)
                          )
                      )
                  ) :
                  Container(
                    decoration: BoxDecoration(
                      color:  themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StreamBuilder(
                          stream: _fireStore.collection('messages')
                               .doc(groupChatId)
                              .collection(groupChatId)
                              .orderBy('messageDate', descending: true)
                              .limit(_limit).snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Container(),
                              );
                            }
                            List<Widget> messageWidget = [];
                            for (var message in snapshot.data.docs) {
                              final messageText = message.get('messages');
                              final messageSender = message.get('sender');
                              Timestamp t = message.get('messageDate');
                              DateTime date = t.toDate();
                              chatTime = DateFormat.jm().format(date);
                              messageWidget.add(
                                MessageBubble(
                                  text: messageText,
                                  sender: messageSender,
                                  time: chatTime,
                                  isMe: loginUser.email == messageSender
                                )
                              );
                            }
                            return Expanded(
                                child: ListView(
                                  controller: listScrollController,
                                  reverse: true,
                                  children: messageWidget,
                                ));
                          },
                        ),
                        Container(
                          decoration: kMessageContainerDecoration.copyWith(
                            border: Border(
                              top: BorderSide(
                                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                  width: 2.0
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  autofocus: widget.autoFocus,
                                  controller: _textController,
                                  textInputAction: TextInputAction.send,
                                  autocorrect: true,
                                  style: TextStyle(
                                    color: themeNotifier.darkTheme ? Colors.black : Color(0xFFA5D0E6),
                                  ),
                                  onChanged: (value) {
                                    messageText = value;
                                    setState(() {
                                      showSendBtn = true;
                                    });
                                  },
                                  decoration: kMessageTextFieldDecoration.copyWith(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                                    )
                                  ),
                                ),
                              ),
                              showSendBtn ? IconButton(
                                icon: Icon(Icons.send),
                                iconSize: 30.0,
                                color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                onPressed: () => onSendMessage(),
                              ) : Container()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
