import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/constants.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/custom_alertdialog.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:donorapp/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchScreen extends StatefulWidget {
  static final routeName = 'search_screen';
  SearchScreen({
    this.uid,
    this.scrollController
  });
  final ScrollController scrollController;
  final String uid;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _fireStore = FirebaseFirestore.instance;
  var textController = TextEditingController();
  TextEditingController requestController = TextEditingController();
  Color colorOnChange = Colors.black.withOpacity(0.5);
  bool showCancelBtn = false;
  bool view = false;
  bool isSearching = false;
  bool autoFocus = false;
  var tempSearchStore = [];
  List queryResultSet = [];
  final formKey = GlobalKey<FormState>();

  void showAlertDialog(BuildContext context, themeNotifier) {
    showDialog(
      context: context,
      builder: (context) => CustomRequestDialog(requestController: requestController)
    );
  }

  void showAlertDialogFilter(BuildContext context, themeNotifier) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialogFilter(uid: widget.uid)
    );
  }

  void showCancel() {
    setState(() {
      showCancelBtn = true;
      if (textController.text.isEmpty) {
        showCancelBtn = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provide = Provider.of<ContentProvider>(context);
    searchResult(String value) {
      value.substring(0,1).toUpperCase() == 'B' ?
      FirebaseFirestore.instance.collection('blood')
          .where('SearchKey', isEqualTo: value.substring(0,1).toUpperCase()).get()
          .then((QuerySnapshot value) {
        for (int i = 0; i < value.docs.length; ++i) {
          tempSearchStore.add(value.docs[i].data());
        }
        print(tempSearchStore);
      }
      ):
      FirebaseFirestore.instance.collection('organ')
          .where('SearchKey', isEqualTo: value.substring(0,1).toUpperCase()).get()
          .then((QuerySnapshot value) {
        for (int i = 0; i < value.docs.length; ++i) {
          tempSearchStore.add(value.docs[i].data());
        }
        print(tempSearchStore);
       }
      );
    }
    Stream<QuerySnapshot> userProfile = FirebaseFirestore.instance.collection('users').orderBy('Sort', descending: true).snapshots();
    Stream<QuerySnapshot> bloodStream = FirebaseFirestore.instance.collection('blood').orderBy('messageDate', descending: true).snapshots();
    Stream<QuerySnapshot> organStream = FirebaseFirestore.instance.collection('organ').orderBy('messageDate', descending: true).snapshots();

    return SafeArea(
      child: Consumer2<ThemeNotifier, ContentProvider>(
          builder: (context, themeNotifier, contentProvider, child) =>
          Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 7,
                        child:
                        TextFormField(
                            autofocus: autoFocus,
                            controller: textController,
                            textInputAction: TextInputAction.search,
                            autocorrect: true,
                            onChanged: (value) {
                              setState(() {
                                colorOnChange = themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E);
                                searchResult(value);
                                isSearching = true;
                              });
                              showCancel();
                              tempSearchStore = [];
                              //initiateSearch(value);

                            },
                            style: TextStyle(
                              fontSize: 18
                            ),
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
                              hintText: 'Search for Donors...',
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 25,
                                  color: colorOnChange,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isSearching = false;
                                  });
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                }
                              ),
                              suffixIcon: showCancelBtn ? IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    size: 25,
                                    color: colorOnChange,
                                  ),
                                  onPressed: () {
                                    if (textController.text.isNotEmpty) {
                                      textController.text = '';
                                      setState(() {
                                        showCancelBtn = false;
                                      });
                                    }
                                  }
                              ) : null,
                            )
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                            icon: Icon(
                              Icons.filter_list,
                              size: 25,
                              color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.6) : Color(0xFFA5D0E6),
                            ),
                            onPressed: () => showAlertDialogFilter(context, themeNotifier)
                        ),
                      ),
                    ],
                  )
              ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      color: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
                      padding: EdgeInsets.symmetric(
                        vertical: 4, horizontal: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: isSearching ? '  Search Results' : '',
                            color: themeNotifier.darkTheme ? Colors.black : Colors.white,
                            fontSize: 16,
                          ),
                          isSearching ?
                          Container() :
                          GestureDetector(
                            onTap: () {
                              showAlertDialog(context, themeNotifier);
                            },
                            child: CustomText(
                              text: 'Make Request!',
                              color: themeNotifier.darkTheme ? Colors.black : Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              view ? Icons.view_module: Icons.list,
                              color: themeNotifier.darkTheme ? Colors.black : Color(0xFFA5D0E6),
                            ),
                            onPressed: () {
                              setState(() {
                                view = !view;
                              });
                            },
                          )
                        ],
                      )
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: CombineLatestStream.list([bloodStream, userProfile, organStream]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03002E)
                                  )
                              )
                          );
                        } else {
                          final bloodStr = snapshot.data[0];
                          final userProfileStr = snapshot.data[1];
                          final organStr = snapshot.data[2];
                          if (bloodStr.docs.length == 0 && organStr.docs.length == 0) {
                            return Container(
                              color: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
                              child: Center(
                                child: CustomText(
                                  text: 'No Data...',
                                  fontSize: 20,
                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Color(0xFFA5D0E6),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              color: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
                              child: view ?
                              GridView.builder(
                                controller: widget.scrollController,
                                itemCount: organStr.docs.length,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (cxt, idx) =>
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.2,
                                      child: GestureDetector(
                                        onTap: () =>
                                            Navigator.push(context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        ProfileScreen(
                                                          index: idx,
                                                          profilePix: userProfileStr.docs[idx].get('PhotoUrl'),
                                                          colorIdx: userProfileStr.docs[idx].get('ColorIdx'),
                                                          id: userProfileStr.docs[idx].get('uid'),
                                                          name: organStr.docs[idx].get('Full Name'),
                                                          email: organStr.docs[idx].get('Email'),
                                                          phone: organStr.docs[idx].get('Mobile Number'),
                                                          gender: organStr.docs[idx].get('Gender'),
                                                          height: organStr.docs[idx].get('Height'),
                                                          weight: organStr.docs[idx].get('Weight'),
                                                          address: organStr.docs[idx].get('Address'),
                                                          city: organStr.docs[idx].get('City'),
                                                          country: organStr.docs[idx].get('Country'),
                                                          birthday: organStr.docs[idx].get('Birthday'),
                                                          age: organStr.docs[idx].get('Age').toString(),
                                                          donationType: organStr.docs[idx].get('DonationType'),
                                                          donationTimes: organStr.docs[idx].get('DonationTimes').toString(),
                                                          likes: organStr.docs[idx].get('Likes').toString(),
                                                        )
                                                )
                                            ),
                                        child: Card(
                                            color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.95) : Color(0xFF010048),
                                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12
                                            ),
                                            elevation: 1.0,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [ userProfileStr.docs[idx].get('PhotoUrl') != null ?
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                                  child: SizedBox(
                                                    width: 60.0,
                                                    height: 60.0,
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        imageUrl: userProfileStr.docs[idx].get('PhotoUrl'),
                                                        fit: BoxFit.cover,
                                                        width: 30.0,
                                                        height: 30.0,
                                                        placeholder: (context, url) =>
                                                            Container(
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2.0,
                                                                valueColor: AlwaysStoppedAnimation<Color>(themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048)
                                                                ),
                                                              ),
                                                              width: 30.0,
                                                              height: 30.0,
                                                              padding: EdgeInsets.all(20.0),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ) : CircleAvatar(
                                                  maxRadius: 30.0,
                                                  backgroundColor: contentProvider.randColors[userProfileStr.docs[idx].get('ColorIdx')],
                                                  child: Center(
                                                    child: CustomText(
                                                      text: organStr.docs[idx].get('Full Name').toString().substring(0, 1),
                                                      fontSize: 30,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                CustomText(
                                                    text: organStr.docs[idx].get('Full Name'),
                                                    fontSize: 20,
                                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                                    textAlign: TextAlign.center,
                                                    fontWeight: FontWeight.w400,
                                                 ),
                                                 CustomText(
                                                    text: organStr.docs[idx].get('DonationType') + " Donor",
                                                    fontSize: 18,
                                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
                                                 ),
                                                 Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Icon(
                                                          Icons.favorite,
                                                          size: 15,
                                                          color: Colors.amber),
                                                      CustomText(
                                                        text: organStr.docs[idx].get('Likes').toString(),
                                                        fontSize: 15,
                                                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    ),
                              ) : (
                                isSearching ?
                                ListView(
                                  controller: widget.scrollController,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: tempSearchStore.map((element) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.07,
                                          child: ListTile(
                                              leading: element['PhotoUrl'] != null ?
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                                child: SizedBox(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl: element['PhotoUrl'],
                                                      fit: BoxFit.cover,
                                                      width: 30.0,
                                                      height: 30.0,
                                                      placeholder: (context, url) =>
                                                          Container(
                                                            child: CircularProgressIndicator(strokeWidth: 2.0,
                                                              valueColor: AlwaysStoppedAnimation<Color>(themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048)
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
                                                maxRadius: 30.0,
                                                backgroundColor: contentProvider.randColors[element['ColorIdx']],
                                                child: Center(
                                                  child: CustomText(
                                                    text: element['Full Name'].toString().substring(0, 1),
                                                    fontSize: 30,
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
                                              subtitle: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: element['DonationType'] + " Donor",
                                                    fontSize: 14,
                                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                       CustomText(
                                                        text: element['BloodGroup'] ?? '',
                                                        fontSize: 14,
                                                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
                                                      ) ,
                                                      element['BloodGroup'] != null ? SizedBox(width: MediaQuery.of(context).size.width * 0.05) : Container(),
                                                      Icon(
                                                          Icons.favorite,
                                                          size: 15,
                                                          color: Colors.amber),
                                                      CustomText(
                                                        text: element['Likes'].toString(),
                                                        fontSize: 15,
                                                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              trailing: IconButton(
                                                  icon: Icon(
                                                      Icons.phone,
                                                      color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6)
                                                  ),
                                                  onPressed: () {
                                                    if (element['BloodGroup'] != null) {
                                                      Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  ProfileScreen(
                                                                    uid: widget.uid,
                                                                    profilePix: element['PhotoUrl'],
                                                                    colorIdx: element['ColorIdx'],
                                                                    id: element['id'],
                                                                    name: element['Full Name'],
                                                                    email: element['Email'],
                                                                    phone: element['Mobile Number'],
                                                                    gender: element['Gender'],
                                                                    height: element['Height'],
                                                                    weight: element['Weight'],
                                                                    address: element['Address'],
                                                                    bloodGroup: element['BloodGroup'],
                                                                    city: element['City'],
                                                                    country: element['Country'],
                                                                    birthday: element['Birthday'],
                                                                    age: element['Age'].toString(),
                                                                    donationType: element['DonationType'],
                                                                    donationTimes: element['DonationTimes'].toString(),
                                                                    likes: element['Likes'].toString(),
                                                                  )
                                                          )
                                                      );
                                                    } else {
                                                      Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                              builder: (context) =>
                                                                  ProfileScreen(
                                                                    uid: widget.uid,
                                                                    profilePix: element['PhotoUrl'],
                                                                    colorIdx: element['ColorIdx'],
                                                                    id: element['id'],
                                                                    name: element['Full Name'],
                                                                    email: element['Email'],
                                                                    phone: element['Mobile Number'],
                                                                    gender: element['Gender'],
                                                                    height: element['Height'],
                                                                    weight: element['Weight'],
                                                                    address: element['Address'],
                                                                    city: element['City'],
                                                                    country: element['Country'],
                                                                    birthday: element['Birthday'],
                                                                    age: element['Age'].toString(),
                                                                    donationType: element['DonationType'],
                                                                    donationTimes: element['DonationTimes'].toString(),
                                                                    likes: element['Likes'].toString(),
                                                                  )
                                                          )
                                                      );
                                                    }
                                                  }
                                              )
                                          ),
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                        Divider(
                                          color: themeNotifier.darkTheme ? Colors.black.withOpacity( 0.3) : Colors.white.withOpacity(0.8),
                                          thickness: 0.3,
                                          indent: 80.0,
                                        )
                                      ],
                                    );
                                  }
                                  ).toList()
                                ) :
                                ListView.builder(
                                    controller: widget.scrollController,
                                    itemCount: bloodStr.docs.length,
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (cxt, idx) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03002E)
                                                )
                                            )
                                        );
                                      } else {
                                        if (bloodStr.docs.length == 0 && organStr.docs.length == 0 && userProfileStr.docs.length == 0) {
                                          return Center(
                                            child: CustomText(
                                              text: 'No Data...',
                                              fontSize: 30,
                                              color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                            ),
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.07,
                                                child: ListTile(
                                                    leading: userProfileStr.docs[idx].get('PhotoUrl') != null ?
                                                    CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                                      child: SizedBox(
                                                        width: 60.0,
                                                        height: 60.0,
                                                        child: ClipOval(
                                                          child: CachedNetworkImage(
                                                            imageUrl: userProfileStr.docs[idx].get('PhotoUrl'),
                                                            fit: BoxFit.cover,
                                                            width: 30.0,
                                                            height: 30.0,
                                                            placeholder: (context, url) =>
                                                                Container(
                                                                  child: CircularProgressIndicator(strokeWidth: 2.0,
                                                                    valueColor: AlwaysStoppedAnimation<Color>(themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048)
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
                                                      maxRadius: 30.0,
                                                      backgroundColor: contentProvider.randColors[userProfileStr.docs[idx].get('ColorIdx')],
                                                      child: Center(
                                                        child: CustomText(
                                                          text: bloodStr.docs[idx].get('Full Name').toString().substring(0, 1),
                                                          fontSize: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    title: CustomText(
                                                      text: bloodStr.docs[idx].get('Full Name'),
                                                      fontSize: 20,
                                                      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    subtitle: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        CustomText(
                                                          text: bloodStr.docs[idx].get('DonationType') + " Donor",
                                                          fontSize: 14,
                                                          color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
                                                        ),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            CustomText(
                                                              text: bloodStr.docs[idx].get('BloodGroup'),
                                                              fontSize: 14,
                                                              color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
                                                            ),
                                                            SizedBox(width: MediaQuery.of(context).size.width *0.05),
                                                            Icon(
                                                                Icons.favorite,
                                                                size: 15,
                                                                color: Colors.amber),
                                                            CustomText(
                                                              text: bloodStr.docs[idx].get('Likes').toString(),
                                                              fontSize: 15,
                                                              color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    trailing: IconButton(
                                                      icon: Icon(
                                                          Icons.phone,
                                                          color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6)
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                  builder: (context) =>
                                                                      ProfileScreen(
                                                                        index: idx,
                                                                        uid: widget.uid,
                                                                        profilePix: userProfileStr.docs[idx].get('PhotoUrl'),
                                                                        colorIdx: userProfileStr.docs[idx].get('ColorIdx'),
                                                                        id: userProfileStr.docs[idx].get('uid'),
                                                                        name: bloodStr.docs[idx].get('Full Name'),
                                                                        email: bloodStr.docs[idx].get('Email'),
                                                                        phone: bloodStr.docs[idx].get('Mobile Number'),
                                                                        gender: bloodStr.docs[idx].get('Gender'),
                                                                        height: bloodStr.docs[idx].get('Height'),
                                                                        weight: bloodStr.docs[idx].get('Weight'),
                                                                        address: bloodStr.docs[idx].get('Address'),
                                                                        bloodGroup: bloodStr.docs[idx].get('BloodGroup'),
                                                                        city: bloodStr.docs[idx].get('City'),
                                                                        country: bloodStr.docs[idx].get('Country'),
                                                                        birthday: bloodStr.docs[idx].get('Birthday'),
                                                                        age: bloodStr.docs[idx].get('Age').toString(),
                                                                        donationType: bloodStr.docs[idx].get('DonationType'),
                                                                        donationTimes: bloodStr.docs[idx].get('DonationTimes').toString(),
                                                                        likes: bloodStr.docs[idx].get('Likes').toString(),
                                                                      )
                                                              )
                                                          ),
                                                    )
                                                ),
                                              ),
                                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                              Divider(
                                                color: themeNotifier.darkTheme ? Colors.black.withOpacity( 0.3) : Colors.white.withOpacity(0.8),
                                                thickness: 0.3,
                                                indent: 80.0,
                                              )
                                            ],
                                          );
                                        }

                                      }
                                    }
                                )
                              )
                            );
                          }
                        }
                      }
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
