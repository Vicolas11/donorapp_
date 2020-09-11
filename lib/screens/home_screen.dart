import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:donorapp/custom_widgets/custom_alertdialog.dart';
import 'package:donorapp/custom_widgets/registration_form.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = 'home_screen';
  HomeScreen({this.scrollController});
  final ScrollController scrollController;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController addController = TextEditingController();
  TextEditingController psdController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  int _current = 0;
  int _currentTest = 0;
  List<T> indicator<T>(List itemList, Function handler) {
    List<T> result = [];
    for (int i = 0; i < itemList.length; i++) {
      result.add(handler(i, itemList[i]));
    }
    return result;
  }

  void showInformationDialog(context) {
    showDialog(
        context: context,
        builder: (context) => NotificationDialog()
    );
  }

  void showInformationEligible(context) {
    showDialog(
        context: context,
        builder: (context) => NotificationEligible()
    );
  }

  void showRegistrationForm(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RegistrationForm()
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.50;
    var provide = Provider.of<ContentProvider>(context);
    return SafeArea(
      child: Consumer2<ThemeNotifier, ContentProvider>(
        builder: (context, themeNotifier, contentProvider, child) =>
            Container(
            color: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFFA9D0FF),
            child:
            ListView(controller: widget.scrollController,
              children: <Widget>[
            //MAIN HEADER
              Container(
                width: double.infinity,
                height: height,
                decoration: BoxDecoration(
                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0)),
                    image: DecorationImage(
                      image: AssetImage('images/doctors_promoting.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.dstATop),
                    )),
                padding: EdgeInsets.only(top: 20.0, left: 20.0),
                child: Row(
                  children: [
                    Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: 5,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.3,
                      child: FadeAnimatedTextKit(
                        repeatForever: true,
                        text: contentProvider.text,
                        textAlign: TextAlign.start,
                        textStyle: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    )
                  ],
                )
            ),
            //GET ADVISED
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              child: Column(
                children: [
                  Text(
                    'Get Advice',
                    style: TextStyle(fontSize: 30, color: Colors.black87),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Want to Donate for the first time?',
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.007,
                              ),
                              CustomText(
                                text: 'important information for new donors',
                                color: Colors.black87,
                                fontSize: 30,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.012,
                              ),
                              SizedBox(
                                  width: 150.0,
                                  height: 40.0,
                                  child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: CustomText(
                                          text: 'LEARN MORE',
                                          color: Colors.white),
                                      color: themeNotifier.darkTheme
                                          ? Colors.green
                                          : Color(0xFF010048),
                                      onPressed: () => showInformationDialog(context)
                                   ),
                              )
                            ],
                          ),
                        ),
                        Expanded(child: Image.asset('images/blooddude.png')),
                      ]),
                ],
              ),
            ),
            //AM I ELIGIBLE TO DONATE
            Container(
              color:
                  themeNotifier.darkTheme ? Colors.white10 : Color(0xFF010048),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              child: Column(
                children: [
                  Text(
                    '',
                    style: TextStyle(fontSize: 30, color: Colors.black87),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Am I Eligible to Donate?',
                                color: themeNotifier.darkTheme
                                    ? Colors.black.withOpacity(0.8)
                                    : Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.007,
                              ),
                              CustomText(
                                text:
                                    'Are you eligible for donation? Find out about the eligibility '
                                    'requirements to donate today. Learn about general health, travel, medications and more.',
                                color: themeNotifier.darkTheme
                                    ? Colors.black87
                                    : Colors.white,
                                fontSize: 25,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.012,
                              ),
                              SizedBox(
                                  width: 150.0,
                                  height: 40.0,
                                  child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: CustomText(
                                          text: 'LEARN MORE',
                                          color: themeNotifier.darkTheme
                                              ? Colors.white
                                              : Color(0xFF010048)),
                                      color: themeNotifier.darkTheme
                                          ? Colors.green
                                          : Color(0xFFA9D0FF),
                                      onPressed: () => showInformationEligible(context)
                                  )
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Image.asset(
                          'images/bloodstain.png',
                          fit: BoxFit.fill,
                        )),
                      ]),
                ],
              ),
            ),
            //BECOME A DONOR >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            Container(
              color: themeNotifier.darkTheme
                  ? Color(0xfff9f8fd)
                  : Color(0xFFA9D0FF),
              width: double.infinity,
              height: height,
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              child: Column(
                children: [
                  Text(
                    'Donate Now',
                    style: TextStyle(fontSize: 30, color: Colors.black87),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.012,
                  ),
                  CustomText(
                    text: 'Become a Donor',
                    color: Colors.black87,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    text:
                        'If you are completely new to blood or organ donation. Register now to donate.',
                    color: Colors.black87,
                    fontSize: 30,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  SizedBox(
                      width: 180.0,
                      height: 50.0,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: CustomText(
                              text: 'REGISTER NOW', color: Colors.white),
                          color: themeNotifier.darkTheme
                              ? Colors.green
                              : Color(0xFF010048),
                          onPressed: () => showRegistrationForm(context)
                          )
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  Expanded(
                    child: Image.asset(
                      'images/blooddonation.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            //NEWS AND UPDATE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            Container(
              color:
                  themeNotifier.darkTheme ? Colors.white10 : Color(0xFF010048),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              child: Column(
                children: [
                  CustomText(
                    text: 'News And Updates',
                    fontSize: 30,
                    color:
                        themeNotifier.darkTheme ? Colors.black87 : Colors.white,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  CarouselSlider.builder(
                    itemCount: provide.testimonies.length,
                    options: CarouselOptions(
                      viewportFraction: 0.45,
                      initialPage: 0,
                      disableCenter: false,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 1000),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (int index, reason) {
                        _current = index;
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (BuildContext context, int itemIndex) =>
                        Container(
                            width: MediaQuery.of(context).size.width * 0.33,
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.005),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    provide.news[itemIndex].picture,
                                    color: themeNotifier.darkTheme
                                        ? Colors.black.withOpacity(0.8)
                                        : Colors.white,
                                    colorBlendMode: BlendMode.dstATop,
                                  ),
                                ),
                                CustomText(
                                    text: provide.news[itemIndex].title,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    color: themeNotifier.darkTheme
                                        ? Colors.black.withOpacity(0.8)
                                        : Colors.white),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.009,
                                ),
                                CustomText(
                                    text: provide.news[itemIndex].article
                                            .substring(0, 50) +
                                        '...',
                                    textAlign: TextAlign.center,
                                    color: themeNotifier.darkTheme
                                        ? Colors.black.withOpacity(0.8)
                                        : Colors.white),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.009,
                                ),
                                GestureDetector(
                                  child: CustomText(
                                    text: 'Read More >>',
                                    color: themeNotifier.darkTheme
                                        ? kPrimaryColor
                                        : Color(0xFFA9D0FF),
                                  ),
                                ),
                              ],
                            )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: indicator<Widget>(
                          provide.news,
                          (idx, img) => Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeNotifier.darkTheme
                                    ? (_current == idx
                                        ? Color.fromRGBO(0, 0, 0, 1)
                                        : Color.fromRGBO(0, 0, 0, 0.2))
                                    : (_current == idx
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5)),
                              ))))
                ],
              ),
            ),
            //TESTIMONIES >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            Container(
                color: themeNotifier.darkTheme
                    ? Color(0xfff9f8fd)
                    : Color(0xFFA9D0FF),
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                ),
                child: Column(children: [
                  Text(
                    'Testimonies',
                    style: TextStyle(fontSize: 30, color: Colors.black87),
                  ),
                  CarouselSlider(
                      items: provide.testimonies
                          .map((testimony) => Builder(
                              builder: (BuildContext context) => Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.08,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          testimony.condition,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.9),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                        ),
                                        Text(
                                          '"${testimony.story}"',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.9),
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                        ),
                                        Text(testimony.testifier,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                fontSize: 12)),
                                      ],
                                    ),
                                  )))
                          .toList(),
                      options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 10),
                        autoPlayAnimationDuration: Duration(milliseconds: 1000),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        onPageChanged: (int index, reason) {
                          _currentTest = index;
                        },
                        scrollDirection: Axis.horizontal,
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: indicator<Widget>(
                          provide.testimonies,
                          (idx, img) => Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 2),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentTest == idx
                                        ? Color.fromRGBO(0, 0, 0, 1)
                                        : Color.fromRGBO(0, 0, 0, 0.4)),
                              )))
                ])),
            //FOOTER >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 8.0,
                ),
                color: Colors.black.withOpacity(0.90),
                child: Column(
                  children: [
                    Text(
                      'Contact Us | Accessibility | Cookies | \n'
                      'Privacy | Terms and Conditions '
                      '| Using Online Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      'You can call us on',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      '0810 787 4622',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: contentProvider.socialMediaIcon
                            .map(
                              (icon) => CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.black,
                                child: IconButton(
                                  icon: Icon(
                                    icon,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            )
                            .toList()),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Divider(
                      color: Colors.white.withOpacity(0.20),
                      indent: 15.0,
                      endIndent: 15.0,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/donorlogo.png',
                          width: 80.0,
                          height: 80.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Image.asset(
                          'images/coatofarm.png',
                          width: 80.0,
                          height: 80.0,
                        ),
                      ],
                    )
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
