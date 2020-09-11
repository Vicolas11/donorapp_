import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/constants.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/curvepainter.dart';
import 'package:donorapp/custom_widgets/custom_textform.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/custom_widgets/roundbutton.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:donorapp/services/database.dart';
import 'package:donorapp/services/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'package:toast/toast.dart';
import 'switch_screen.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';

class LoginScreen extends StatefulWidget {
  static final routeName = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password, errorMsgUser, errorMsgPsd, errorRecoveryEmail;
  bool isVisible = true;
  bool showSpinner = false;
  bool check = false;
  bool hasSentResetPsd = false;
  bool hasRemembered = false;
  bool autoValidate = false;
  RegExp emailRegExp = RegExp(patternQuery);
  RegExp passwordRegExp = RegExp(strongPassword);
  TextEditingController emailController = TextEditingController();
  TextEditingController psdController = TextEditingController();
  TextEditingController recoveryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final formKeyy = GlobalKey<FormState>();
  User currentUsers;
  SharedPreferences sharedPref;

  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Enter Email';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Please Enter a Valid Email.';
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Enter Password';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    showSpinner = false;
    emailController.dispose();
    psdController.dispose();
  }

  @override
  void initState() {
    super.initState();
    //readLocal();
  }
  //If there's no current User Login when is app launched

  readLocal() {
    hasRemembered = sharedPref.getBool("REM") ?? false;
    if (hasRemembered != null) {
      if(hasRemembered == true) {
        setState((){
          emailController.text = sharedPref.getString('StoreEmail');
          psdController.text = sharedPref.getString('StorePwd');
        });
      } else {
        setState((){
          emailController.text = sharedPref.getString('StoreEmail');
          psdController.text = sharedPref.getString('StorePwd');
        });
      }
    }
    setState((){});
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

  rememberMe(context, provides) {
    if (hasRemembered == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
          AlertDialog(
            backgroundColor: provides.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03001E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: CustomText(
              text: 'Save Login Details',
              textAlign: TextAlign.center,
              fontSize: 18,
              color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
            ),
            content: CustomText(
              text: 'Do you want to save login details?',
              textAlign: TextAlign.center,
              fontSize: 16,
              color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  await sharedPref.setString('StoreEmail', emailController.text);
                  await sharedPref.setString('StorePwd', psdController.text);
                  await sharedPref.setBool('REM', true);
                  Navigator.pop(context);
                },
                child: CustomText(
                  text: 'Yes',
                  fontSize: 16,
                  color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState((){
                    hasRemembered = false;
                    sharedPref.setString('StoreEmail', '');
                    sharedPref.setString('StorePwd', '');
                    sharedPref.setBool('REM', false);
                  });
                },
                child: CustomText(
                  text: 'No',
                  fontSize: 16,
                  color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                ),
              ),
            ],
          )
      );
    } else {
      sharedPref.setString('StoreEmail', '');
      sharedPref.setString('StorePwd', '');
      sharedPref.setBool('REM', false);
    }
  }

  forgetPassword(themeNotifier, provides) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              backgroundColor: provides.darkTheme ?
              Color(0xfff9f8fd) : Color(0xFF03001E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: CustomText(
                text: 'Password Recovery',
                textAlign: TextAlign.center,
                fontSize: 18,
                color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
              ),
              content: hasSentResetPsd ?
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: 'A reset link has been sent to this email \n${recoveryController.text}',
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                      onPressed: () => Navigator.pop(context),
                      child: CustomText(
                          text: 'Close',
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8)
                      ),
                    )
                  ],
                ) :
                Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: 'Please enter your registered email',
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                  Form(
                    key: formKeyy,
                    child: TextFormField(
                      autofocus: true,
                      controller: recoveryController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => validateEmail(value),
                      style: TextStyle(
                        color: themeNotifier.darkTheme ? Colors.black : Color(0xFFA5D0E6),
                      ),
                      cursorColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                      decoration: kTextFieldDecoration.copyWith(
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
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                        ),
                        errorText: errorRecoveryEmail,
                        prefixIcon: Icon(
                          Icons.email,
                          color: themeNotifier.darkTheme ? Colors.grey : Color(0xFFA5D0E6),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                    onPressed: () async {
                      if (formKeyy.currentState.validate()) {
                        setState(() {showSpinner = true;});
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: recoveryController.text)
                            .whenComplete(() {
                              setState(() {
                                hasSentResetPsd = true;
                                showSpinner = false;
                              });}
                          ).catchError((err) {
                        if (err is FirebaseException) {
                          FirebaseException exception = err;
                          if (exception.code == 'user-not-found') {
                            errorRecoveryEmail = 'Couldn\'t find this account\n${recoveryController.text}';
                            setState(() {showSpinner = false;});
                           }
                          }
                        });
                        setState(() { showSpinner = false; });
                      }
                    },
                    child: CustomText(
                        text: 'Reset',
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8)
                    ),
                  )
                ],
              ),
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    var provides = Provider.of<ThemeNotifier>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: provides.darkTheme ? kPrimaryColor : Color(0xFF03001E),
    ));
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        dismissible: false,
        progressIndicator: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) =>
           CircularProgressIndicator(
            backgroundColor: provides.darkTheme ? kPrimaryColor : Color(0xFF03001E),
          ),
        ),
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, widget) =>
             Container(
              decoration: BoxDecoration(
                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
                  image: DecorationImage(
                      image: AssetImage('images/texturebg.png'),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
                          BlendMode.overlay
                      )
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.width * 0.07,
                      bottom: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: TyperAnimatedTextKit(
                      text:['Welcome Back.','Login Your Account.'],
                      pause: Duration(milliseconds:  1000),
                      textStyle: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: CustomPaint(
                      painter: CurvePainter(context: context),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.03,
                            right: MediaQuery.of(context).size.height * 0.03,
                            top: MediaQuery.of(context).size.height * 0.08
                        ),
                        child: Column(
                          children: [
                            CustomText(
                              text: 'Sign In Account',
                              fontSize: 22,
                              color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                            //FORM >>>>>>
                            Form(
                                key: _formKey,
                                autovalidate: autoValidate,
                                child: Expanded(
                                  child: ListView(
                                    children: <Widget>[
                                      CustomTextForm(
                                        textController: emailController,
                                        inputType: TextInputType.emailAddress,
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        validator: (value) => validateEmail(value),
                                        errorText: errorMsgUser,
                                        onChange: (value) {
                                          email = value;
                                        },
                                        hintText: 'Email Address',
                                        icon: Icons.email,
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.013,),
                                      CustomTextForm(
                                        textController: psdController,
                                        isObscureText: isVisible,
                                        inputType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        onEditingComplete: () => FocusScope.of(context).unfocus(),
                                        onChange: (value) {
                                          password = value;
                                        },
                                        hintText: 'Password',
                                        icon: Icons.lock,
                                        errorText: errorMsgPsd,
                                        validator: (value) => validatePassword(value),
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              isVisible ? Icons.visibility : Icons.visibility_off,
                                              color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                            ),
                                            onPressed: () => setState(() {
                                              isVisible = !isVisible;
                                            })
                                        ),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.013,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 12.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                width: 30.0,
                                                height: 24.0,
                                                child: Theme(
                                                  data: ThemeData(
                                                      unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Color(0xFFA5D0E6)
                                                  ),
                                                  child: Checkbox(
                                                    activeColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                                    value: hasRemembered,
                                                    onChanged: (value) {
                                                      setState((){
                                                        hasRemembered = sharedPref.getBool('REM');
                                                        rememberMe(context, provides);
                                                      });
                                                    },
                                                  ),
                                                )
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CustomText(
                                                    text: ' Remember me',
                                                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6)
                                                ),
                                                SizedBox(width: MediaQuery.of(context).size.width * 0.15,),
                                                GestureDetector(
                                                    onTap: () => forgetPassword(themeNotifier, provides),//Reset Password,
                                                    child: CustomText(
                                                      text: 'Forget Password?',
                                                      fontWeight: FontWeight.bold,
                                                      color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                                    )
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      //SIGN IN BUTTON
                                      RoundButton(
                                        buttonColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                        buttonTitle: 'Sign in',
                                        onPressed: () async {
                                          //Navigator.pushNamed(context, SwitchScreen.routeName);
                                          try {
                                            if (_formKey.currentState.validate()) {
                                              setState(() {
                                                showSpinner = true;
                                              });
                                              await _auth.signInWithEmailAndPassword(
                                                  email: email, password: password).then((currentUser) async {
                                                      setState(() {showSpinner = true;});
                                                      //rememberMe(email, password, context, provides);
                                                      /*final QuerySnapshot result = await FirebaseFirestore.instance
                                                          .collection('users').where('uid', isEqualTo: currentUser.user.uid).get();
                                                      final List<DocumentSnapshot> data = result.docs;
                                                      //Save Locally
                                                      await sharedPref.setBool('isSignIn', true);
                                                      await sharedPref.setString('id', data[0].data()['uid']);
                                                      await sharedPref.setString('Full Name', data[0].data()['Full Name']);
                                                      await sharedPref.setString('Email', data[0].data()['Email']);
                                                      await sharedPref.setString('Mobile Number', data[0].data()['Mobile Number']);
                                                      await sharedPref.setString('PhotoUrl', data[0].data()['PhotoUrl']);
                                                      await sharedPref.setString('Date', data[0].data()['Date']);
                                                      await sharedPref.setInt('ColorIdx', data[0].data()['ColorIdx']);*/
                                                      Navigator.pushReplacement(context,
                                                          CupertinoPageRoute(
                                                              builder: (context) => SwitchScreen(uid: currentUser.user.uid)
                                                          )
                                                      );
                                                      Toast.show(
                                                          'Sign in successfully!',
                                                          context, duration: Toast.LENGTH_LONG,
                                                          gravity:  Toast.BOTTOM);
                                                      FocusScope.of(context).requestFocus(new FocusNode());
                                              }).catchError((err) {
                                                if (err is FirebaseException) {
                                                  FirebaseException exception = err;
                                                  if (exception.code == 'user-not-found') {
                                                    errorMsgUser = 'Couldn\'t find this account ${emailController.text}';
                                                  } else if (exception.code == 'wrong-password') {
                                                    errorMsgPsd = 'Wrong Password. Try again or click forget password \nto reset.';
                                                  } else {
                                                    //errorMsgPsd = exception.message;
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => Platform.isAndroid ?
                                                        AlertDialog(
                                                          backgroundColor: provides.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03001E),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                          content: CustomText(
                                                            text: exception.code == 'unknown' ? 'Network time out. Please check Internet Connection\nand try again.'
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
                                                              child: CustomText(
                                                                text: 'OK',
                                                                fontSize: 16,
                                                                color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                                                              ),
                                                            ),
                                                          ],
                                                        ) :
                                                        CupertinoAlertDialog(
                                                          content: CustomText(
                                                            text: exception.code == 'unknown'
                                                                ? 'Network time out. Please check Internet Connection\nand try again.' : exception.message,
                                                            textAlign:
                                                            TextAlign.center,
                                                            fontSize: 18,
                                                            color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd),
                                                          ),
                                                          actions: [
                                                            FlatButton(
                                                              onPressed:() {
                                                                Navigator.pop(context);
                                                                setState(() {
                                                                  showSpinner = false;
                                                                });
                                                              },
                                                              child:
                                                              CustomText(
                                                                text: 'OK',
                                                                fontSize: 16,
                                                                color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd)
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                    );
                                                  }
                                                  setState(() {
                                                    showSpinner = false;
                                                  });
                                                }
                                              });

                                            } else {
                                              setState(() {
                                                autoValidate = true;
                                              });
                                            }
                                          } on PlatformException catch(e) {
                                            print(e);
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
                                              text: ' Or Sign in with ',
                                              color: themeNotifier.darkTheme ? Colors.black45 : Color(0xFFA5D0E6)
                                            ),
                                            Flexible(
                                              child: Divider(
                                                thickness: 1.5,
                                                height: 1.5,
                                                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.4) : Color(0xFFA5D0E6),
                                              )),
                                          ],
                                        ),
                                      ),
                                      //FACEBOOK AND GOOGLE BUTTON
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
                                          SizedBox(width: MediaQuery.of(context).size.width * 0.013,),
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
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.012,),
                                      //DON'T HAVE AND ACCOUNT?
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: 'Don\'t have an account? ',
                                            color: themeNotifier.darkTheme ? Colors.black45 : Colors.white,
                                          ),
                                          GestureDetector(
                                              onTap: () => Navigator.pushNamed(context, RegisterScreen.routeName),
                                              child: CustomText(
                                                text: 'Create Now',
                                                fontSize: 20,
                                                color: themeNotifier.darkTheme ? kPrimaryColor : Colors.white,
                                                fontWeight: FontWeight.bold,
                                              )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.010,),
                                      //IMAGES BELOW >>>>>>>>>>>>>>>
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Image.asset(
                                              'images/bloodtrans.png',
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          Expanded(
                                            child: Image.asset(
                                              'images/bloodcenter.png',
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
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