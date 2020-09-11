import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/custom_widgets/profilepaint.dart';
import 'package:donorapp/modals/constant.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:donorapp/screens/messages_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_maininfo.dart';

class ProfileScreen extends StatefulWidget {
  static final routeName = 'profile_screen';
  ProfileScreen({
    this.index,
    this.colorIdx,
    this.id,
    this.uid,
    this.name,
    this.bloodGroup,
    this.birthday,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.donationTimes,
    this.donationType,
    this.donationType1,
    this.address,
    this.city,
    this.country,
    this.phone,
    this.email,
    this.likes,
    this.profilePix,
  });
  final int index, colorIdx;
  final String name, birthday, address, city, country, email, phone, likes, id, profilePix, uid;
  final String bloodGroup, gender, age, height, weight, donationTimes, donationType, donationType1;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _makePhoneCall(String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  int updateLikes = 0;
  SharedPreferences sharedPref;
  final _auth = FirebaseAuth.instance;
  bool hasClicked = false;
  User loginUser;

  @override
  void initState() {
    super.initState();
    getNewUser();
    initSharedPref();
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

  initSharedPref() async {
    return sharedPref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    var provides = Provider.of<ThemeNotifier>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: provides.darkTheme ? kPrimaryColor : Color(0xFF03001E),
    ));
    var provide = Provider.of<ContentProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer2<ThemeNotifier, ContentProvider>(
          builder: (context, themeNotifier, contentProvide, child) =>
           Container(
            decoration: BoxDecoration(
                color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
                image: DecorationImage(
                  image: widget.profilePix != null ? NetworkImage(
                    widget.profilePix,
                  ) : AssetImage('images/launcher_icon.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.dstATop),
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //APP Bar
                Container(
                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                            Icons.arrow_back_ios,
                            size: 28,
                            color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.7) : Color(0xFFA5D0E6)
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CustomText(
                        text: 'Donor Profile',
                        fontSize: 20,
                        color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.7) : Color(0xFFA5D0E6),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                            Icons.favorite,
                            color: hasClicked ? Colors.amber : Colors.white.withOpacity(0.6)),
                            onPressed: () async {
                              setState(() {
                                hasClicked = !hasClicked;
                                if (hasClicked == true) {
                                  updateLikes += 1;
                                } else {
                                  updateLikes -= 1;
                                }
                            });
                              hasClicked = await sharedPref.setBool('isFavourite', hasClicked);
                              widget.donationType == 'Blood' ?
                              FirebaseFirestore.instance.collection('blood').doc(widget.id).update({
                                'Likes': updateLikes,
                                'isFavourite': hasClicked
                              }) : FirebaseFirestore.instance.collection('organ').doc(widget.id).update({
                                'Likes': updateLikes,
                                'isFavourite': hasClicked
                              });
                            },
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.002,),
                          CustomText(
                            text: widget.likes,
                            fontWeight: FontWeight.w300,
                            fontSize: 25,
                            color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.7) : Color(0xFFA5D0E6),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.009,),
                //Profile Pictures
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Align(
                              child: CircleAvatar(
                                  maxRadius: 90.0,
                                  backgroundColor: themeNotifier.darkTheme ? Colors.black.withOpacity(0.15) : Color(0x5503001E),
                              ),
                            ),
                            Align(
                              heightFactor: 1.1,
                              child: CircleAvatar(
                                  maxRadius: 80.0,
                                  backgroundColor: themeNotifier.darkTheme ? Colors.black.withOpacity(0.2) : Color(0x2203001E),
                              ),
                            ),
                            Align(
                              heightFactor: 1.2,
                              child: widget.profilePix != null ?
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                child: SizedBox(
                                  width: 140.0,
                                  height: 140.0,
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
                              ) : CircleAvatar(
                                  maxRadius: 70.0,
                                  backgroundColor: contentProvide.randColors[widget.colorIdx],
                                  child: Center(
                                  child: CustomText(
                                    text: widget.name.substring(0,1),
                                    fontSize: 90,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          CustomText(
                            text: widget.name,
                            fontWeight: FontWeight.w500,
                            fontSize: 35,
                            color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.7) : Color(0xFFA5D0E6),
                          ),
                          CustomText(
                            text: '${widget.donationType} Donor',
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                            color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.7) : Color(0xFFA5D0E6),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Phone And Chat IconButtons
                Flexible(
                  child: Stack(
                    fit: StackFit.expand,
                    overflow: Overflow.visible,
                    children: [
                      //MAIN CONTENT
                      CustomPaint(
                        painter: ProfilePaint(context: context),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 50.0, left: 10.0, right: 10.0),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProfileMainInfo(
                                  gender: widget.gender,
                                  age: widget.age,
                                  birthday: widget.birthday,
                                  address: widget.address,
                                  city: widget.city,
                                  country: widget.country,
                                  email: widget.email,
                                  phone: widget.phone,
                                  height: widget.height,
                                  weight: widget.weight,
                                  bloodGroup: widget.donationType == 'Blood' ? widget.bloodGroup : '',
                                  donationTimes: widget.donationTimes,
                                ),
                                Divider(color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.ideographic,
                                  children:<Widget>[
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: SizedBox.shrink(
                                              child: Icon(
                                                  FontAwesomeIcons.quoteLeft))),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: CustomText(
                                        text: widget.donationType == 'Blood' ? provide.profileQuote: provide.profileQuote2,
                                        textAlign: TextAlign.center,
                                        color: Colors.black.withOpacity(0.7),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(FontAwesomeIcons.quoteRight),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
                                  indent: 80.0,
                                ),
                                //TIMELINE
                                CustomText(
                                  text: 'Timeline',
                                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
                                  fontSize: 30,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * .153,
                                              width: 7,
                                              decoration: BoxDecoration(
                                                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E)
                                              ),
                                            ),
                                          ),
                                          Align(
                                            child: Container(
                                              height: 15,
                                              width: 15,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E)
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 9,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: 'Saturday, Apr 20, 2020',
                                            textAlign: TextAlign.start,
                                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Color(0xFF03001E),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 25,
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: ListTile(
                                              leading: Icon(FontAwesomeIcons.mars),
                                              title: CustomText(
                                                text: '290ml of blood',
                                                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: ListTile(
                                              leading: Icon(FontAwesomeIcons.locationArrow),
                                              title: CustomText(
                                                text: 'Jos University Hospital, Jos',
                                                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Divider(
                                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
                                            indent: 80.0,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Align(
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * .153,
                                              width: 7,
                                              decoration: BoxDecoration(
                                                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E)
                                              ),
                                            ),
                                          ),
                                          Align(
                                            child: Container(
                                              height: 15,
                                              width: 15,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E)
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 9,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: 'Saturday, Apr 20, 2020',
                                            textAlign: TextAlign.start,
                                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Color(0xFF03001E),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 25,
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: ListTile(
                                              leading: Icon(FontAwesomeIcons.mars),
                                              title: CustomText(
                                                text: '290ml of blood',
                                                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: ListTile(
                                              leading: Icon(FontAwesomeIcons.locationArrow),
                                              title: CustomText(
                                                text: 'Jos University Hospital, Jos',
                                                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Divider(
                                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
                                            indent: 80.0,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //PHONE AND CHAT ICONS
                      Positioned(
                        top: -10,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Card(
                                color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.8) : Color(0xFFA5D0E6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.phone,
                                      size: 40,
                                      color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
                                    ),
                                    onPressed: () => _makePhoneCall(widget.phone),//Dial Donor Number
                                  ),
                                ),
                              ),
                              Card(
                                color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.8) : Color(0xFFA5D0E6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.chat,
                                      size: 40,
                                      color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
                                    ),
                                    onPressed: () {
                                      if (widget.id == widget.uid) {
                                        Toast.show('Sorry can\'t chat with yourself',
                                            context, duration: Toast.LENGTH_LONG,
                                            gravity:  Toast.BOTTOM
                                        );
                                      } else {
                                        Navigator.push(context,
                                          CupertinoPageRoute(builder: (context) {
                                            print(widget.id);
                                            return MessagesScreen(
                                              peerId: widget.id,
                                              colorIdx: widget.colorIdx,
                                              profileName: widget.name,
                                              profilePix: widget.profilePix,
                                              initialText: '${widget.name.toString().substring(0,1)}',
                                            );
                                          }
                                          ),
                                        );
                                      }
                                    } // Say Hi to the Donor in a chat
                                    //Dial Donor Number
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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