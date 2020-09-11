import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:donorapp/screens/login_screen.dart';
import 'package:donorapp/screens/switch_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SplashScreen extends StatefulWidget {
  static final routeName = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showSpinner = false;
  SharedPreferences sharedPref;

  @override
  void initState() {
    super.initState();
    isUserSignedIn();
    //After the Screen Splash for three seconds take me to another Activity
    // Future.delayed(Duration(seconds: 1), () =>
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (content) => Login()))
    // );
  }

  void isUserSignedIn() async {
    setState(() {
      showSpinner = true;
    });
    sharedPref = await SharedPreferences.getInstance();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        saveToLocal(user);
        Navigator.pushReplacement(context,
            CupertinoPageRoute(
                builder: (context) =>
                    SwitchScreen(uid: user.uid ?? sharedPref.getString('id'))
            )
        );
      } else {
        Navigator.pushReplacement(context,
            CupertinoPageRoute(
                builder: (context) => LoginScreen()
            )
        );
      }
    });
    setState(() {
      showSpinner = false;
    });
  }

  saveToLocal(User currentUser) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users').where('uid', isEqualTo: currentUser.uid).get();
    final List<DocumentSnapshot> data = result.docs;
    //Save Locally
    await sharedPref.setBool('isSignIn', true);
    await sharedPref.setString('id', data[0].data()['uid']);
    await sharedPref.setString('Full Name', data[0].data()['Full Name']);
    await sharedPref.setString('Email', data[0].data()['Email']);
    await sharedPref.setString('Phone', data[0].data()['Mobile Number']);
    await sharedPref.setString('PhotoUrl', data[0].data()['PhotoUrl']);
    await sharedPref.setString('Date', data[0].data()['Date']);
    await sharedPref.setInt('ColorIdx', data[0].data()['ColorIdx']);
  }

  @override
  Widget build(BuildContext context) {
    var provides = Provider.of<ThemeNotifier>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: provides.darkTheme ? kPrimaryColor : Color(0xFF03001E),
    ));
    return Scaffold(
        backgroundColor: provides.darkTheme ? kPrimaryColor : Color(0xFF03001E),
        body: Center(
          child: Image.asset('images/launcher_icon.png'),
        )
    );
  }
}