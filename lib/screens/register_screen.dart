import 'dart:io';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/constants.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/curvepainter.dart';
import 'package:donorapp/custom_widgets/custom_textform.dart';
import 'package:donorapp/custom_widgets/roundbutton.dart';
import 'package:donorapp/screens/switch_screen.dart';
import 'package:donorapp/services/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static final routeName = 'registration_screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String fullNames, email, phoneNumber, password, confirmPwd;
  String errorMsgName, errorMsgPsd, errorMsgOthers;
  int randNum = Random.secure().nextInt(3);
  bool isVisibleCon = true;
  bool showCancelBtn = false;
  bool autoValidate = false;
  bool showSpinner = false;
  bool isVisible = true;
  bool checkedTAndC = false;
  RegExp emailRegExp = RegExp(patternQuery);
  RegExp passwordRegExp = RegExp(strongPassword);
  RegExp nameRegExp = RegExp(nameQuery);
  final _formKey = GlobalKey<FormState>();
  SharedPreferences sharedPref;
  TextEditingController nameController, emailController, phoneController,
   psdController, confirmPsdController;

  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Enter Email';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Please Enter a Valid Email.';
    } else {
      return null;
    }
  }

  String validatePhone(String value) {
    if (value.isEmpty) {
      return 'Enter Mobile Number';
    } else {
      return null;
    }
  }

  String validateFullName(String value) {
    if (value.isEmpty) {
      return 'Enter Full Name';
    } else if (!nameRegExp.hasMatch(value)) {
      return 'Please Enter a Valid Name.';
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Enter Password';
    } else if (!passwordRegExp.hasMatch(value)) {
      return 'Include at least a lowercase, uppercase, \nnumbers or symbols like @#\$%^&*.'
          '\nAnd Use 6 characters or more for your password.';
    } else if (value.length < 6) {
      return 'Use 6 characters or more for your password.';
    } else {
      return null;
    }
  }

  String validateConfirmPwd(String value) {
    if (value.isEmpty) {
      return 'Confirm Password';
    } else if (password != confirmPwd) {
      return 'Those passwords didn\'t match. Try again.';
    } else {
      return null;
    }
  }

  termsAndConditions(context, provides) {
    showDialog(
        context: context,
        builder: (context) => Platform.isAndroid ?
        AlertDialog(
          backgroundColor: provides.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03001E),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          content: CustomText(
            text: 'DONOR APP is a platform where you can find organ and blood donors. '
                'If you want to sign up, grant permission by checking mark terms and condition '
                'and by doing so you have agreed to it. Thanks.',
            textAlign: TextAlign.center,
            fontSize: 18,
            color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: CustomText(
                text: 'OK',
                fontSize: 16,
                color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
              ),
            ),
          ],
        ): CupertinoAlertDialog(
          content: CustomText(
            text: 'DONOR APP is a platform where you can find organ and blood donors. '
                'If you want to sign up, grant permission by checking mark terms and condition '
                'and by doing so you have agreed to it. Thanks.',
            textAlign: TextAlign.center,
            fontSize: 18,
            color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: CustomText(
                  text: 'OK',
                  fontSize: 16,
                  color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd)
              ),
            ),
          ],
        )
    );
  }

  capitalize(String value) {
    return value.splitMapJoin(
        RegExp(r' '),
        onMatch: (m) => '${m.group(0)}',
        onNonMatch: (n) => '${n.substring(0,1).toUpperCase() + n.substring(1).toLowerCase()}'
    );
  }

  @override
  void dispose() {
    super.dispose();
    showSpinner = false;
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    psdController.dispose();
    confirmPsdController.dispose();
  }

  @override
  void initState()  {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    psdController = TextEditingController();
    confirmPsdController = TextEditingController();
    sharedPreference();
  }

  sharedPreference() async {
    return sharedPref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _fireStore = FirebaseFirestore.instance;
    var provides = Provider.of<ThemeNotifier>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: provides.darkTheme ? kPrimaryColor : Color(0xFF03001E),
    ));
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) => CircularProgressIndicator(
            backgroundColor:
                provides.darkTheme ? kPrimaryColor : Color(0xFF03001E),
          ),
        ),
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) => Container(
              decoration: BoxDecoration(
                  color: themeNotifier.darkTheme
                      ? kPrimaryColor
                      : Color(0xFF03001E),
                  image: DecorationImage(
                      image: AssetImage('images/texturebg.png'),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          themeNotifier.darkTheme
                              ? kPrimaryColor
                              : Color(0xFF03001E),
                          BlendMode.overlay))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.width * 0.07,
                      bottom: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: TyperAnimatedTextKit(
                      text: ['Welcome', 'Register new account.'],
                      pause: Duration(milliseconds: 1000),
                      textStyle: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: CustomPaint(
                      painter: CurvePainter(context: context),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.03,
                            right: MediaQuery.of(context).size.height * 0.03,
                            top: MediaQuery.of(context).size.height * 0.07),
                        child: Column(
                          children: [
                            CustomText(
                                text: 'Create New Account',
                                fontSize: 22,
                                color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6)),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            Form(
                                key: _formKey,
                                autovalidate: autoValidate,
                                child: Expanded(
                                  child: ListView(
                                    children: <Widget>[
                                      CustomTextForm(
                                        textController: nameController,
                                        hintText: 'Full Name',
                                        icon: Icons.person,
                                        inputType: TextInputType.text,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        onChange: (value) {
                                          fullNames = value;
                                          setState(() {
                                            showCancelBtn = true;
                                          });
                                        },
                                        validator: (value) => validateFullName(value),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                                      CustomTextForm(
                                        textController: emailController,
                                        inputType: TextInputType.emailAddress,
                                        hintText: 'Email Address',
                                        icon: Icons.email,
                                        errorText: errorMsgName,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        onChange: (value) {
                                          email = value;
                                        },
                                        validator: (value) => validateEmail(value),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                                      CustomTextForm(
                                        textController: phoneController,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        inputType: TextInputType.phone,
                                        hintText: 'Mobile Number',
                                        errorText: errorMsgPsd,
                                        icon: Icons.phone,
                                        onChange: (value) {
                                          phoneNumber = value;
                                        },
                                        validator: (value) => validatePhone(value),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                                      CustomTextForm(
                                        textController: psdController,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        isObscureText: isVisible,
                                        hintText: 'Password',
                                        icon: Icons.lock,
                                        inputType: TextInputType.text,
                                        onChange: (value) {
                                          password = value;
                                        },
                                        suffixIcon:  IconButton(
                                            icon: Icon(
                                              isVisible ? Icons.visibility : Icons.visibility_off,
                                              color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                            ),
                                            onPressed: () => setState(() {
                                              isVisible = !isVisible;
                                            })
                                        ),
                                        validator: (value) => validatePassword(value),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                                      CustomTextForm(
                                        textController: confirmPsdController,
                                        textInputAction: TextInputAction.done,
                                        onEditingComplete: () => FocusScope.of(context).unfocus(),
                                        hintText: 'Confirm Password',
                                        icon: Icons.lock,
                                        isObscureText: isVisibleCon,
                                        inputType: TextInputType.text,
                                        errorText: errorMsgPsd,
                                        onChange: (value) {
                                          confirmPwd = value;
                                        },
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              isVisibleCon ? Icons.visibility : Icons.visibility_off,
                                              color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                            ),
                                            onPressed: () => setState(() {
                                              isVisibleCon = !isVisibleCon;
                                            })
                                        ),
                                        validator: (value) => validateConfirmPwd(value),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                                      Padding(
                                        padding: EdgeInsets.only(left: 12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 30.0,
                                              height: 24.0,
                                              child: Theme(
                                                data: ThemeData(
                                                    unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Color(0xFFA5D0E6)),
                                                child: Checkbox(
                                                  activeColor:
                                                      themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                                  value: checkedTAndC,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      checkedTAndC =
                                                          !checkedTAndC;
                                                      }
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                    text: ' I agree to the',
                                                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6)),
                                                GestureDetector(
                                                  onTap: () => termsAndConditions(context, provides),
                                                  child: CustomText(
                                                    text: ' Terms and condition',
                                                    fontWeight: FontWeight.bold,
                                                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      RoundButton(
                                          buttonColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                          buttonTitle: 'Sign up',
                                          onPressed: () async {
                                            try {
                                              if (_formKey.currentState.validate() && checkedTAndC == true) {
                                                setState(()  {
                                                  showSpinner = true;
                                                });
                                                await _auth.createUserWithEmailAndPassword(email: email, password: password)
                                                    .then((currentUser) async {
                                                  setState(() {
                                                    showSpinner = true;
                                                  });
                                                  if (currentUser.user != null) {
                                                      await sharedPref.setBool('isSignIn', true);
                                                  }//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                                  //Add to FireStore
                                                  _fireStore.collection('users').doc(currentUser.user.uid).set({
                                                    'uid': currentUser.user.uid,
                                                    'Full Name': capitalize(fullNames), //Make the Initial Letters Capital,
                                                    'Search Key': fullNames.substring(0,1).toUpperCase(),
                                                    'Email': email.toLowerCase(),
                                                    'Mobile Number': phoneNumber,
                                                    'Password': password,
                                                    'Date': DateFormat.yMMMMEEEEd().format(DateTime.now()),
                                                    'PhotoUrl': null,
                                                    'Sort': DateTime.now().millisecondsSinceEpoch,
                                                    'ChattingWith': null,
                                                    'ColorIdx': randNum,
                                                    'Count': 0,
                                                    'ChatTimePushed': null,
                                                    'RecentChat': '',
                                                  }).then((result) async {
                                                    //Saved Locally
                                                    await sharedPref.setString('id', currentUser.user.uid);
                                                    await sharedPref.setString('Full Name', capitalize(fullNames));
                                                    await sharedPref.setString('Email', email);
                                                    await sharedPref.setString('Mobile Number', phoneNumber);
                                                    await sharedPref.setString('PhotoUrl', '');
                                                    await sharedPref.setInt('ColorIdx', randNum);
                                                    await sharedPref.setString('Date', DateFormat.yMMMMEEEEd().format(DateTime.now()));
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        CupertinoPageRoute(
                                                            builder: (context) => SwitchScreen(uid: currentUser.user.uid)
                                                        ),(route) => false);
                                                    Toast.show(
                                                        'Sign up successfully!',
                                                        context,
                                                        gravity: Toast.BOTTOM,
                                                        duration: Toast.LENGTH_LONG);
                                                  }).catchError((onError) => print(onError));
                                                }).catchError((error) {
                                                  setState(() {
                                                    showSpinner = false;
                                                  });
                                                  var provides = Provider.of<ThemeNotifier>(
                                                      context, listen: false);
                                                  if (error is FirebaseException) {
                                                    FirebaseException exception = error;
                                                    if (exception.code == 'email-already-in-use') {
                                                      errorMsgName = 'Sorry \'$email\' already exit!\nPlease Create new account.';
                                                    } else if (exception.code == 'weak-password') {
                                                      errorMsgPsd = 'Weak Password.';
                                                      setState(() {
                                                        showSpinner = false;
                                                      });
                                                    } else {
                                                      //errorMsgPsd = exception.message;
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) => Platform.isAndroid ?
                                                            AlertDialog(
                                                                      backgroundColor: provides.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03001E),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(15)
                                                                      ),
                                                                      content:
                                                                        CustomText(
                                                                        text: exception.code == 'unknown'
                                                                            ? 'Network time out. Please check Internet Connection\nand try again.'
                                                                            : exception.message,
                                                                        textAlign: TextAlign.center,
                                                                        fontSize: 18,
                                                                        color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                                                                      ),
                                                                      actions: [
                                                                        FlatButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                            setState(() {showSpinner = false;});
                                                                          },
                                                                          child: CustomText(
                                                                            text: 'OK',
                                                                            fontSize: 16,
                                                                            color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ) :
                                                            CupertinoAlertDialog(
                                                                      content:
                                                                          CustomText(
                                                                        text: exception.code == 'unknown'
                                                                            ? 'Network time out. Please check Internet Connection\nand try again.'
                                                                            : exception.message,
                                                                        textAlign: TextAlign.center,
                                                                        fontSize: 18,
                                                                        color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                                                                      ),
                                                                      actions: [
                                                                        FlatButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                            setState(() {
                                                                              showSpinner = false;
                                                                            });
                                                                          },
                                                                          child:
                                                                              CustomText(
                                                                                text: 'OK',
                                                                                fontSize: 16,
                                                                                color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                                                                          ),
                                                                        ),
                                                                      ],
                                                            )
                                                      );
                                                    }
                                                    print(exception.code);
                                                    setState(() {
                                                      showSpinner = false;
                                                    });
                                                  }
                                                });
                                              } else {
                                                setState(() {autoValidate = true;});
                                                //Show Toast Message
                                                if (checkedTAndC == false) {
                                                  Toast.show(
                                                      'Check Terms & Condition',
                                                      context,
                                                      gravity: Toast.BOTTOM,
                                                      duration: Toast.LENGTH_LONG);
                                                }
                                              }
                                            } on PlatformException catch (error) {
                                              print(error.toString());
                                            }
                                          }
                                         ),
                                      SizedBox(
                                        child: Row(
                                          children: [
                                            Flexible(
                                                child: Divider(
                                                        thickness: 1.5,
                                                        height: 1.5,
                                                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.4) : Color(0xFFA5D0E6),
                                              )
                                            ),
                                            CustomText(
                                                text: ' Or Sign up with ',
                                                color: themeNotifier.darkTheme ? Colors.black45 : Color(0xFFA5D0E6)
                                            ),
                                            Flexible(
                                                child: Divider(
                                                  thickness: 1.5,
                                                  height: 1.5,
                                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.4) : Color(0xFFA5D0E6),
                                             )
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: RoundButton(
                                              icon: FontAwesomeIcons.facebook,
                                              iconColor: Colors.white,
                                              iconSize: 15,
                                              buttonColor: Color(0xFF039be5),
                                              buttonTitle: 'acebook',
                                              onPressed: null,
                                            ),
                                          ),
                                          SizedBox(width: MediaQuery.of(context).size.width * 0.013),
                                          Expanded(
                                            child: RoundButton(
                                              icon: FontAwesomeIcons.google,
                                              iconColor: Colors.white,
                                              iconSize: 15,
                                              buttonColor: themeNotifier.darkTheme ? Colors.black87 : Colors.white70,
                                              buttonTitle: 'oogle',
                                              onPressed: null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                                      //DON'T HAVE AND ACCOUNT?
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: 'Have an account? ',
                                            color: themeNotifier.darkTheme
                                                ? Colors.black45
                                                : Colors.white,
                                          ),
                                          GestureDetector(
                                              onTap: () => Navigator.pushReplacementNamed(context, LoginScreen.routeName),
                                              child: CustomText(
                                                text: 'LOGIN',
                                                fontSize: 18,
                                                color: themeNotifier.darkTheme ? kPrimaryColor : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}