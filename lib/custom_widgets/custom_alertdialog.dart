import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/constants.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:donorapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'customtext.dart';
import 'package:provider/provider.dart';

capitalize(String value) {
  return value.splitMapJoin(
      RegExp(r' '),
      onMatch: (m) => '${m.group(0)}',
      onNonMatch: (n) => '${n.substring(0,1).toUpperCase() + n.substring(1).toLowerCase()}'
  );
}

class CustomAlertDialogName extends StatelessWidget {
  CustomAlertDialogName({
    this.uid,
    this.controller,
    this.inputType = TextInputType.text
  });
  final TextEditingController controller;
  final TextInputType inputType;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    SharedPreferences sharedPref;
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) =>
      AlertDialog(
        backgroundColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        title: CustomText(
          text: 'Update Full Name',
          textAlign: TextAlign.center,
          fontSize: 18,
          color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                autofocus: true,
                controller: controller,
                keyboardType: inputType,
                validator: (value) {
                  if (controller.text.isEmpty) {
                    return 'Enter Full Name';
                  } else {
                    return null;
                  }
                },
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
                  hintText: 'Full Name',
                  hintStyle: TextStyle(
                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: themeNotifier.darkTheme ? Colors.grey : Color(0xFFA5D0E6),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await FirebaseFirestore.instance.collection('users').doc(uid).update({
                    'Full Name' : capitalize(controller.text)
                  }).then((value) async {
                    //Save Locally
                    sharedPref = await SharedPreferences.getInstance();
                    await sharedPref.setString('Full Name', capitalize(controller.text));
                    controller.clear();
                    Navigator.pop(context);
                    Toast.show(
                        'Updated successfully!',
                        context, duration: Toast.LENGTH_LONG,
                        gravity:  Toast.BOTTOM
                    );
                  }
                  ).catchError((err) => print(err));
                }
              },
              child: CustomText(
                  text: 'Update',
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8)
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialogUpdatePhone extends StatelessWidget {
  CustomAlertDialogUpdatePhone({
    this.uid,
    this.controller,
    this.inputType = TextInputType.text
  });
  final TextEditingController controller;
  final TextInputType inputType;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    SharedPreferences sharedPref;
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) =>
          AlertDialog(
            backgroundColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            title: CustomText(
              text: 'Update Mobile Number',
              textAlign: TextAlign.center,
              fontSize: 18,
              color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    controller: controller,
                    keyboardType: inputType,
                    validator: (value) {
                      if (controller.text.isEmpty) {
                        return 'Enter Mobile Number';
                      } else {
                        return null;
                      }
                    },
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
                      hintText: 'Mobile Number',
                      hintStyle: TextStyle(
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                      ),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: themeNotifier.darkTheme ? Colors.grey : Color(0xFFA5D0E6),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await FirebaseFirestore.instance.collection('users').doc(uid).update({
                        'Mobile Number' : controller.text
                      }).then((value) async {
                        //Save Locally
                        sharedPref = await SharedPreferences.getInstance();
                        await sharedPref.setString('Mobile Number', controller.text);
                        controller.clear();
                        Navigator.pop(context);
                        Toast.show(
                            'Updated successfully!',
                            context, duration: Toast.LENGTH_LONG,
                            gravity:  Toast.BOTTOM
                        );
                      }
                      ).catchError((err) => print(err));
                    }
                  },
                  child: CustomText(
                      text: 'Update',
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8)
                  ),
                )
              ],
            ),
          ),
    );
  }
}

class CustomAlertDialogPassword extends StatelessWidget {
  CustomAlertDialogPassword({ this.uid, this.title,
    this.controller, this.controllerConfirm, this.oldController,
    this.inputType = TextInputType.text});
  final TextEditingController controller, controllerConfirm, oldController;
  final TextInputType inputType;
  final String uid, title;

  @override
  Widget build(BuildContext context) {
    final __formKey = GlobalKey<FormState>();
    RegExp passwordRegExp = RegExp(strongPassword);
    String oldPassword, errorMsg;
    SharedPreferences sharedPref;
    FirebaseFirestore.instance.collection('users').doc(uid).get()
        .then((value) => oldPassword = value.get("Password"));

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) =>
       AlertDialog(
        backgroundColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        title: CustomText(
          text: title,
          textAlign: TextAlign.center,
          fontSize: 18,
          color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: __formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: oldController,
                    keyboardType: inputType,
                    validator: (value) {
                      if (oldController.text.isEmpty) {
                        return 'Enter Old Password';
                      } else if (oldController.text != oldPassword) {
                        return 'Password MisMatched. Please Check';
                      } else {
                        return null;
                      }
                    },
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
                      hintText: 'Old Password',
                      hintStyle: TextStyle(
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: themeNotifier.darkTheme ? Colors.grey : Color(0xFFA5D0E6),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: controller,
                    keyboardType: inputType,
                    validator: (value) {
                      if (controller.text.isEmpty) {
                        return 'Enter New Password';
                      } else if (!passwordRegExp.hasMatch(value)) {
                        return 'Include at least a lowercase, \nuppercase, numbers or symbols.'
                            '\nUse 6 characters or more for your password.';
                      } else if (value.length < 6) {
                        return 'Use 6 characters or more for your password.';
                      } else {
                        return null;
                      }
                    },
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
                      hintText: 'New Password',
                      hintStyle: TextStyle(
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: themeNotifier.darkTheme ? Colors.grey : Color(0xFFA5D0E6),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: controllerConfirm,
                    keyboardType: inputType,
                    validator: (value) {
                      if (controller.text.isEmpty) {
                        return 'Enter Confirmed Password';
                      } else if (controller.text != controllerConfirm.text) {
                        return 'Those passwords didn\'t match. Try again.';
                      } else {
                        return null;
                      }
                    },
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
                      hintText: 'Confirm New Password',
                      hintStyle: TextStyle(
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                      ),
                      errorText: errorMsg,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: themeNotifier.darkTheme ? Colors.grey : Color(0xFFA5D0E6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                    onPressed: () async {
                      if (__formKey.currentState.validate()) {
                        final _auth = FirebaseAuth.instance.currentUser;
                        _auth.updatePassword(controller.text).then((_) {
                          Navigator.pop(context);
                          Toast.show(
                              'Password updated successfully!',
                              context, duration: Toast.LENGTH_LONG,
                              gravity:  Toast.BOTTOM
                          );
                          controller.clear();
                          controllerConfirm.clear();
                          oldController.clear();
                        }).catchError((err) {
                          if (err is PlatformException) {
                            PlatformException exception = err;
                            errorMsg = exception.message;
                          }
                        });
                      }
                    },
                    child: CustomText(
                        text: 'Update',
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8)
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                Expanded(
                  child: FlatButton(
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
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialogDelAcc extends StatelessWidget {
  CustomAlertDialogDelAcc({ this.uid, this.controller,
    this.inputType = TextInputType.text});
  final TextEditingController controller;
  final TextInputType inputType;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final __formKey = GlobalKey<FormState>();
    String currentPassword, errorMsg;
    SharedPreferences sharedPref;
    /*bool isBloodProfileCreated, isOrganProfileCreated, hasChat;
    FirebaseFirestore.instance.collection('blood')
        .doc(uid).get().then((value) => isBloodProfileCreated = value.exists);
    FirebaseFirestore.instance.collection('organ')
        .doc(uid).get().then((value) => isOrganProfileCreated = value.exists);
   FirebaseFirestore.instance.collection('messages')
        .doc('$uid-$peerId').get().then((value) => hasChat = value.exists);*/
    FirebaseFirestore.instance.collection('users').doc(uid).get()
        .then((value) {
      currentPassword = value.get("Password");
    });

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) =>
       AlertDialog(
        backgroundColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        title: CustomText(
          text: 'Remove Account Completely',
          textAlign: TextAlign.center,
          fontSize: 18,
          color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: __formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: 'To delete your account, confirm with your password.',
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Color(0xFFA5D0E6),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: controller,
                    keyboardType: inputType,
                    validator: (value) {
                      if (controller.text.isEmpty) {
                        return 'Enter password';
                      } else if (controller.text != currentPassword) {
                        return 'Wrong password. Please Check';
                      } else {
                        return null;
                      }
                    },
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
                      hintText: 'Current Password',
                      hintStyle: TextStyle(
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                      ),
                      errorText: errorMsg,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: themeNotifier.darkTheme ? Colors.grey : Color(0xFFA5D0E6),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                    onPressed: () async {
                      //Remove Profile Details Permanently
                      if (__formKey.currentState.validate()) {
                        await FirebaseFirestore.instance.collection('users').doc(uid).delete().then((value) {
                           final _auth = FirebaseAuth.instance.currentUser;
                           _auth.delete().then((value) async {
                            controller.clear();
                            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                            Toast.show(
                                    'Account deleted successfully!',
                                    context, duration: Toast.LENGTH_LONG,
                                    gravity:  Toast.BOTTOM);
                              });
                            }).catchError((err) => print(err));
                            /*await FirebaseFirestore.instance.collection('organ').doc(uid).delete().catchError((err) => print(err));
                            await FirebaseFirestore.instance.collection('blood').doc(uid).delete().catchError((err) => print(err));
                            //Remove items saved locally
                            sharedPref = await SharedPreferences.getInstance();
                            await sharedPref.remove('id');
                            await sharedPref.remove('Full Name');
                            await sharedPref.remove('Email');
                            await sharedPref.remove('Mobile Number');
                            await sharedPref.remove('PhotoUrl');
                            await sharedPref.remove('Date');
                            await sharedPref.remove('ColorIdx');*/
                          }
                     },
                    child: CustomText(
                        text: 'Delete',
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8)
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                Expanded(
                  child: FlatButton(
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
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomRequestDialog extends StatelessWidget {
  CustomRequestDialog({this.requestController});
  final TextEditingController requestController;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var provides = Provider.of<ThemeNotifier>(context);
    var provided = Provider.of<ContentProvider>(context);
    return AlertDialog(
      backgroundColor: provides.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03001E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: CustomText(
          text: 'Make Request',
          textAlign: TextAlign.center,
          color: provides.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: 'Did not get the type of donor you want?'
                ' Please make request below:',
            color: provides.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              controller: requestController,
              maxLines: 8,
              maxLength: 250,
              keyboardType: TextInputType.multiline,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter request!';
                }
                return null;
              },
              style: TextStyle(
                color: provides.darkTheme ? Colors.black : Color(0xFFA5D0E6),
              ),
              cursorColor: provides.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
              decoration: kTextFieldDecoration.copyWith(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: provides.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: provides.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6), width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                hintText: 'Describe Your Type of Donor',
                hintStyle: TextStyle(color: provides.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6))
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            color: provides.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
            onPressed: () async {
              if (formKey.currentState.validate()) {
                String emailId = 'donorapp11@gmail.com';
                String subjectId = 'Request for Donor';
                var urlString = "mailto:$emailId?subject=$subjectId?body=${requestController.text}";
                if (await canLaunch(urlString)) {
                  await launch(urlString);
                } else {
                  throw 'Could not send E-mail';
                }
              }
            },
            child: CustomText(
                text: 'Request',
                fontSize: 16,
                color: Colors.white.withOpacity(0.8)
            ),
          )
        ],
      ),
    );
  }
}

class NotificationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scroll = ScrollController();
    var provides = Provider.of<ThemeNotifier>(context);
    var provided = Provider.of<ContentProvider>(context);
    return AlertDialog(
                backgroundColor: provides.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03001E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                content: NotificationListener<ScrollNotification>(
                  onNotification: (action) {
                    if (action is ScrollStartNotification) {
                      print('Scroll Start\n${action.metrics}');
                    } else if (action is ScrollEndNotification) {
                      print('Scroll Stop\n${action.metrics}');
                    } else if (action is ScrollUpdateNotification) {
                      print('Scroll Updating\n${action.metrics}');
                    }
                    return true;
                  },
                  child: SingleChildScrollView(
                    controller: scroll,
                    physics: BouncingScrollPhysics(),
                    child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd).withOpacity(0.7),
                              ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'DONATE PLASMA\n',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),
                              ),
                              TextSpan(text: provided.textSpan_1),
                              TextSpan(
                                text: 'What is Convalescent Plasma? \n',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                              ),
                              TextSpan(text: provided.textSpan_2),
                              TextSpan(
                                text: 'Donate Organs and Tissues\n',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              TextSpan(text: provided.textSpan_5),
                              TextSpan(text: provided.textSpan_6),
                              TextSpan(text: provided.textSpan_7),
                              TextSpan(text: provided.textSpan_8),
                              TextSpan(
                                text: 'What Will Happen?\n',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Examining Organ and Tissue Donation\n',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              TextSpan(text: provided.textSpan_9),
                              TextSpan(text: provided.textSpan_10),
                              TextSpan(text: provided.textSpan_11),
                              TextSpan(
                                text: 'Keeping the Organs and Tissues Healthy for Transplantation\n',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: provided.textSpan_12),
                              TextSpan(text: provided.textSpan_13),
                              TextSpan(
                                text: 'Keeping the Organs and Tissues Healthy for Transplantation\n',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: provided.textSpan_14),
                              TextSpan(text: provided.textSpan_15),
                            ]
                           )
                    ),
                  ),
                ),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                    CustomText(
                      text: 'OK',
                      fontSize: 16,
                      color: provides.darkTheme
                          ? Color(0xFF03001E)
                          : Color(0xfff9f8fd),
                    ),
                  ),
                ],
              );
  }
}

class NotificationEligible extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scroll = ScrollController();
    var provides = Provider.of<ThemeNotifier>(context);
    var provided = Provider.of<ContentProvider>(context);
    return AlertDialog(
            backgroundColor: provides.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03001E),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)),
            content: NotificationListener<ScrollNotification>(
            onNotification: (action) {
              if (action is ScrollStartNotification) {
                print('Scroll Start\n${action.metrics}');
              } else if (action is ScrollEndNotification) {
                print('Scroll Stop\n${action.metrics}');
              } else if (action is ScrollUpdateNotification) {
                print('Scroll Updating\n${action.metrics}');
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: scroll,
              physics: BouncingScrollPhysics(),
              child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        color: provides.darkTheme ? Color(0xFF03001E) : Color(0xfff9f8fd).withOpacity(0.7),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'I Have Fully Recovered From COVID-19. Am I Eligible to Donate Plasma?\n\n',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(text: provided.textSpan_3),
                        TextSpan(
                          text: 'I Haven\'t Had COVID-19. What Can I Do to Help?\n\n',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(text: provided.textSpan_4),
                        TextSpan(
                          text: 'NOTE*\n\n',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(
                          text: 'Age\n',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(text: provided.textSpan_16),
                        TextSpan(
                          text: 'Weight\n',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(text: provided.textSpan_17),
                        TextSpan(
                          text: 'Transfusions\n',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(text: provided.textSpan_18),
                        TextSpan(
                          text: 'Cancer\n',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(text: provided.textSpan_19),
                      ]
                  )
              ),
            ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child:
          CustomText(
            text: 'OK',
            fontSize: 16,
            color: provides.darkTheme
                ? Color(0xFF03001E)
                : Color(0xfff9f8fd),
          ),
        ),
      ],
    );
  }
}

class CustomAlertDialogFilter extends StatelessWidget {
  CustomAlertDialogFilter({
    this.uid,
  });
  final String uid;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    SharedPreferences sharedPref;
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) =>
          AlertDialog(
            backgroundColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            title: CustomText(
              text: 'Filter',
              textAlign: TextAlign.center,
              fontSize: 18,
              color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
            ),
            content: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                CustomText(
                  text: 'Gender',
                  textAlign: TextAlign.left,
                  fontSize: 18,
                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Color(0xFFA5D0E6),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'Male',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'Female',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CustomText(
                  text: 'Blood Group',
                  textAlign: TextAlign.left,
                  fontSize: 18,
                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Color(0xFFA5D0E6),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'A+',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'A-',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'B+',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'B-',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'AB+',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'AB-',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'O+',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: CustomText(
                            text: 'O-',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.6) : Color(0xFFA5D0E6)
                        ),
                        onPressed: ()  {},
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
    );
  }
}