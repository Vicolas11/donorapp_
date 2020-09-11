import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/constants.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/modals/constant.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:donorapp/screens/messages_screen.dart';
import 'package:donorapp/screens/search_result.dart';
import 'package:donorapp/services/database.dart';
import 'package:donorapp/services/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  static final routeName = 'chat_screen';
  ChatScreen({
    this.scrollController,
    this.chatTime,
    this.showListView = true,
    this.uid,
    this.groupChatId,
  });
  final ScrollController scrollController;
  final bool showListView;
  final String uid, chatTime, groupChatId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController searchController = TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool showSearchBar = true;
  bool showMessage = false;
  bool onSearchBarTapped = true;
  bool isSearching = false;
  bool autoFocus = false;
  SharedPreferences sharedPrefs;
  String recentChat, recentTime, photoUrl;
  int msgCount = 0;
  Stream chatRooms;
  var awaitChatTime;
  Stream<QuerySnapshot> chats;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      FirebaseFirestore.instance.collection("users")
          .where('Search Key', isEqualTo: value.substring(0,1).toUpperCase())
          .get().then((QuerySnapshot docs) {
              for (int i = 0; i < docs.docs.length; ++i) {
                queryResultSet.add(docs.docs[i].data);
                print('QuerySnapshot:- ${docs.docs[i].data}');
              }
          }
       );
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['Full Name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //fetched();
  }

  @override
  Widget build(BuildContext context) {
    var provide = Provider.of<ContentProvider>(context);
    searchResult(String text) {
      FirebaseFirestore.instance.collection('users')
          .where('Search Key', isEqualTo: text.substring(0,1).toUpperCase()).get()
          .then((QuerySnapshot value) {
        for (int i = 0; i < value.docs.length; ++i) {
          tempSearchStore.add(value.docs[i].data());
        }
      }
      );
    }
    return SafeArea(
        child: Consumer2<ThemeNotifier, ContentProvider>(
          builder: (context, themeNotifier, contentProvider, child) =>
           Container(
            color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 13.0
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 800),
                        child: showSearchBar ? CustomText(
                          text: 'Messages',
                          fontSize: 25,
                          color: Colors.white70.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ): null,
                      ),
                      SizedBox(width: showSearchBar ? MediaQuery.of(context).size.width * .51: 0.0),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 800),
                        child: showSearchBar ?
                         CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: IconButton(
                              icon: Icon(
                                Icons.search,
                                size: 30,
                                color: Colors.white70.withOpacity(0.8),),
                              onPressed: () {
                                setState(() {
                                  showSearchBar = false;
                                  showMessage = true;
                                  onSearchBarTapped = false;
                                  autoFocus = true;
                                });
                              }
                          ),
                        ): null,
                      ),
                      Expanded(
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 800),
                          child: showMessage ?
                          TextFormField(
                              autofocus: autoFocus,
                              onChanged: (value) {
                                //Return Search Result
                                //initiateSearch(value);
                                setState((){
                                  searchResult(value);
                                  isSearching = true;
                                });
                                tempSearchStore = [];
                              },
                              textInputAction: TextInputAction.done,
                              decoration: kChatTextFormDecoration.copyWith(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6), width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6), width: 2.0),
                                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                ),
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showSearchBar = true;
                                      showMessage = false;
                                      onSearchBarTapped = true;
                                      isSearching = false;
                                    });
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                  }
                                ),
                                suffixIcon: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    )
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      size: 30,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    onPressed: () {
                                      searchController.text = '';
                                    } //Show Search Result!
                                  ),
                                ),
                              )
                          ) : null,
                        ),
                      )
                    ],
                  ),
                ),
                //MAIN CONTENT
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('users').orderBy('Sort', descending: true).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || snapshot == null) {
                      return Center(
                          child: CircularProgressIndicator(
                                  backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03002E),
                                ),
                      );
                    } else {
                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)
                              )
                          ),
                          child: isSearching ?
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: CustomText(
                                   text: 'Chats Results',
                                   fontSize: 18,
                                   color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                               SizedBox(height: MediaQuery.of(context).size.height * 0.007,),
                               Flexible(
                                 child: ListView(
                                   controller: widget.scrollController,
                                   physics: BouncingScrollPhysics(),
                                   shrinkWrap: true,
                                   children: tempSearchStore.map((element) {
                                     return InkWell(
                                       onTap: () {
                                         if (element['uid'] != widget.uid) {
                                           Navigator.push(context,
                                               CupertinoPageRoute(builder: (context) =>
                                                   MessagesScreen(
                                                     peerId: element['uid'],
                                                     colorIdx: element['ColorIdx'],
                                                     profileName: element['Full Name'],
                                                     profilePix: element['PhotoUrl'],
                                                     initialText: '${element['Full Name'].toString().substring(0,1)}',
                                                   )
                                               )
                                           );
                                         }
                                       } ,
                                       child: Column(
                                         children: [
                                           ListTile(
                                             leading: CircleAvatar(
                                               maxRadius: 30.0,
                                               backgroundColor: contentProvider.randColors[element['ColorIdx']],
                                               child: Center(
                                                 child: CustomText(
                                                   text: '${element['Full Name'].toString().substring(0,1)}',
                                                   fontSize: 20,
                                                   color: Colors.white,
                                                 ),
                                               ),
                                             ),
                                             title: CustomText(
                                               text: element['Full Name'],
                                               fontSize: 20,
                                               color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                               fontWeight: FontWeight.bold,
                                             ),
                                             subtitle: CustomText(
                                               text: element["Email"],
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
                                       ),
                                     );
                                   }).toList(),
                                 ),
                               ),
                             ],
                           ):
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 15.0, left: 10.0,
                                ),
                                child: CustomText(
                                  text: 'Favorite Chats',
                                  fontSize: 25,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.007,),
                              Flexible(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (cxt, idx) =>
                                    snapshot.data.docs[idx].get('uid') == widget.uid ?
                                        Container() :
                                        Container(
                                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      CupertinoPageRoute(builder: (context) =>
                                                          MessagesScreen(
                                                            peerId: snapshot.data.docs[idx].get('uid'),
                                                            colorIdx: snapshot.data.docs[idx].get('ColorIdx'),
                                                            profileName: snapshot.data.docs[idx].get('Full Name'),
                                                            profilePix: snapshot.data.docs[idx].get('PhotoUrl'),
                                                            initialText: '${snapshot.data.docs[idx].get('Full Name').toString().substring(0,1)}',
                                                          )
                                                      )
                                                  );
                                                  FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
                                                    'Count': 0,
                                                  });
                                                },
                                                child: SizedBox(
                                                  child: snapshot.data.docs[idx].get('PhotoUrl') != null ?
                                                  CircleAvatar(
                                                    radius: 35,
                                                    backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                                    child: SizedBox(
                                                      width: 30.0,
                                                      height: 30.0,
                                                      child: ClipOval(
                                                        child: CachedNetworkImage(
                                                          imageUrl: snapshot.data.docs[idx].get('PhotoUrl'),
                                                          fit: BoxFit.cover,
                                                          width: 30.0,
                                                          height: 30.0,
                                                          placeholder: (context, url) => Container(
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2.0,
                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                  themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048)
                                                              ),
                                                            ),
                                                            width: 30.0,
                                                            height: 30.0,
                                                            padding: EdgeInsets.all(20.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ) :
                                                  CircleAvatar(
                                                    maxRadius: 35.0,
                                                    backgroundColor: contentProvider.randColors[snapshot.data.docs[idx].get('ColorIdx')],
                                                    child: Center(
                                                      child: CustomText(
                                                        text: '${snapshot.data.docs[idx].get('Full Name').toString().substring(0,1)}',
                                                        fontSize: 38,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.009),
                                              CustomText(
                                                  text: snapshot.data.docs[idx].get('Full Name'),
                                                  fontSize: 11,
                                                  color: themeNotifier.darkTheme ? Colors.black : Colors.white)
                                            ],
                                          ),
                                        )
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 15.0, left: 10.0,
                                ),
                                child: CustomText(
                                  text: 'Recent Chats',
                                  fontSize: 25,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                child: ListView.builder(
                                    controller: widget.scrollController,
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (cxt, idx) =>
                                    snapshot.data.docs[idx].get('uid') == widget.uid ?
                                    Container() :
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                          CupertinoPageRoute(builder: (context) =>
                                              MessagesScreen(
                                                peerId: snapshot.data.docs[idx].get('uid'),
                                                colorIdx: snapshot.data.docs[idx].get('ColorIdx'),
                                                profileName: snapshot.data.docs[idx].get('Full Name'),
                                                profilePix: snapshot.data.docs[idx].get('PhotoUrl'),
                                                initialText: '${snapshot.data.docs[idx].get('Full Name').toString().substring(0,1)}',
                                              )
                                          )
                                       );
                                        FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
                                          'Count': 0,
                                        });
                                      },
                                      child: Container(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 60,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 8.0),
                                                  child: ListTile(
                                                    leading: snapshot.data.docs[idx].get('PhotoUrl') != null ?
                                                    CircleAvatar(
                                                      radius: 38,
                                                      backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                                      child: SizedBox(
                                                        width: 30.0,
                                                        height: 30.0,
                                                        child: ClipOval(
                                                          child: CachedNetworkImage(
                                                            imageUrl: snapshot.data.docs[idx].get('PhotoUrl'),
                                                            fit: BoxFit.cover,
                                                            width: 30.0,
                                                            height: 30.0,
                                                            placeholder: (context, url) => Container(
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2.0,
                                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                                    themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048)
                                                                ),
                                                              ),
                                                              width: 30.0,
                                                              height: 30.0,
                                                              padding: EdgeInsets.all(20.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ) :
                                                    CircleAvatar(
                                                      maxRadius: 38.0,
                                                      backgroundColor: contentProvider.randColors[snapshot.data.docs[idx].get('ColorIdx')],
                                                      child: Center(
                                                        child: CustomText(
                                                          text: '${snapshot.data.docs[idx].get('Full Name').toString().substring(0,1)}',
                                                          fontSize: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    title: CustomText(
                                                      text: snapshot.data.docs[idx].get('Full Name'),
                                                      fontSize: 20,
                                                      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    subtitle: CustomText(
                                                      text: snapshot.data.docs[idx].get("RecentChat") == '' ? snapshot.data.docs[idx].get("Email") : snapshot.data.docs[idx].get("RecentChat"),
                                                      fontSize: 14,
                                                      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                                                    ),
                                                    trailing: SizedBox(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          CustomText(
                                                            text: snapshot.data.docs[idx].get('ChatTimePushed') ?? '${DateTime.now().hour}:${DateTime.now().minute}',
                                                            fontSize: 14,
                                                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                                                          snapshot.data.docs[idx].get("Count") != 0 ?
                                                          CircleAvatar(
                                                            maxRadius: 15,
                                                            backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.lightBlue,
                                                            child: CustomText(
                                                              text: snapshot.data.docs[idx].get("Count").toString(),
                                                              fontSize: 14,
                                                              color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ) : IgnorePointer(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                              Divider(
                                                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
                                                indent: 80.0,
                                                thickness: 0.3,
                                              )
                                            ],
                                          )
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }
                )
              ],
            ),
          ),
        )
    );
  }
}