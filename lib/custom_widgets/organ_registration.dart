import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/constants.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:donorapp/custom_widgets/custom_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'customtext.dart';

enum Allergies { Yes, No }
enum TakeMedication { Yes, No }
enum MedicalCondition { Yes, No }
enum Organs {Liver, Kidney, Pancreas, Heart, Bone, Lungs }

class RegistrationFormOrgan extends StatefulWidget {
  RegistrationFormOrgan(
      {this.uid,
      this.title,
      this.inputType = TextInputType.text});
  final TextInputType inputType;
  final String uid, title;

  @override
  _RegistrationFormOrganState createState() => _RegistrationFormOrganState();
}

class _RegistrationFormOrganState extends State<RegistrationFormOrgan> {
  final __formKey = GlobalKey<FormState>();
  TextEditingController addController = TextEditingController();
  TextEditingController psdController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  capitalize(String value) {
    return value.splitMapJoin(
        RegExp(r' '),
        onMatch: (m) => '${m.group(0)}',
        onNonMatch: (n) => '${n.substring(0,1).toUpperCase() + n.substring(1).toLowerCase()}'
    );
  }
  bool showSpinner = false;
  bool autoValidate = false;
  Allergies allergies = Allergies.No;
  TakeMedication takeMedication = TakeMedication.No;
  MedicalCondition medicalCondition = MedicalCondition.No;
  Organs organs = Organs.Kidney;
  SharedPreferences sharedPref;

  pref() async {
    return sharedPref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    pref();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth user = FirebaseAuth.instance;
    String currentPassword, name, email, phone, photoUrl;
    int colorIdx;
    bool existedSnapshot;
    FirebaseFirestore.instance.collection('organ')
        .doc(user.currentUser.uid).get().then((value) => existedSnapshot = value.exists);
    FirebaseFirestore.instance.collection('users').doc(user.currentUser.uid).get()
        .then((value) {
      currentPassword = value.get("Password");
      name = value.get('Full Name');
      email = value.get('Email');
      phone = value.get('Mobile Number');
      colorIdx = value.get('ColorIdx');
      photoUrl = value.get('PhotoUrl');
    });

    return Consumer2<ThemeNotifier, ContentProvider>(
        builder: (context, themeNotifier, contentProvider, child) =>
         ModalProgressHUD(
           inAsyncCall: showSpinner,
           child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    CustomText(
                      text: 'Donate an Organ Today and Save Lives',
                      textAlign: TextAlign.center,
                      fontSize: 17,
                      color: themeNotifier.darkTheme
                          ? Colors.black.withOpacity(0.7)
                          : Color(0xFFA5D0E6),
                    ),
                    Form(
                      key: __formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Address
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          CustomTextFormReg(
                            controller: addController,
                            validator: (value) {
                              if (addController.text.isEmpty) {
                                return 'Street*';
                              } else {
                                return null;
                              }
                            },
                            hintText: 'Street Address',
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          //City and Country
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormReg(
                                  controller: cityController,
                                  hintText: 'City',
                                  validator: (value) {
                                    if (cityController.text.isEmpty) {
                                      return 'City*';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              CustomDropDown(
                                value: contentProvider.defaultValue,
                                onChanged: (value) {
                                  contentProvider.newDefaultValue(value);
                                },
                                items: contentProvider.countryList
                                    .map<DropdownMenuItem<String>>(
                                        (String country) {
                                  return DropdownMenuItem<String>(
                                    value: country,
                                    child: SizedBox(
                                      width: 100,
                                      child: CustomText(
                                        text: country,
                                        textAlign: TextAlign.start,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          //Date of Birthday
                          Flex(
                            direction: Axis.horizontal,
                            children: [
                              CustomDropDown(
                                flex: 2,
                                value: contentProvider.day,
                                onChanged: (value) {
                                  contentProvider.dayValue(value);
                                },
                                items: List.generate(31, (index) => index + 1)
                                    .map<DropdownMenuItem<int>>((int day) {
                                  return DropdownMenuItem<int>(
                                    value: day,
                                    child: SizedBox(
                                      width: 100,
                                      child: CustomText(
                                        text: '$day',
                                        textAlign: TextAlign.right,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              CustomDropDown(
                                flex: 4,
                                value: contentProvider.month,
                                onChanged: (value) {
                                  contentProvider.monthValue(value);
                                },
                                items: contentProvider.months
                                    .map<DropdownMenuItem<String>>(
                                        (String month) {
                                  return DropdownMenuItem<String>(
                                    value: month,
                                    child: SizedBox(
                                      width: 80,
                                      child: CustomText(
                                        text: '$month',
                                        textAlign: TextAlign.right,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                              CustomDropDown(
                                flex: 3,
                                value: contentProvider.year,
                                onChanged: (value) =>
                                    contentProvider.yearValue(value),
                                items: List.generate(84, (index) => index + 1920)
                                    .map<DropdownMenuItem<int>>((int year) {
                                  return DropdownMenuItem<int>(
                                    value: year,
                                    child: Text('$year'),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                          //Height, Weight, Age
                          Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomDropDown(
                                value: contentProvider.gender,
                                onChanged: (value) {
                                  contentProvider.genderValue(value);
                                },
                                items: contentProvider.genders
                                    .map<DropdownMenuItem<String>>(
                                        (String blood) {
                                  return DropdownMenuItem<String>(
                                    value: blood,
                                    child: SizedBox(
                                      width: 50,
                                      child: CustomText(
                                        text: '$blood',
                                        textAlign: TextAlign.center,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              Expanded(
                                child: CustomTextFormReg(
                                  controller: heightController,
                                  inputType: TextInputType.number,
                                  hintText: 'Height(ft)',
                                  validator: (value) {
                                    if (heightController.text.isEmpty) {
                                      return 'Height(ft)*';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: CustomTextFormReg(
                                  controller: weightController,
                                  inputType: TextInputType.number,
                                  hintText: 'Weight(kg)',
                                  validator: (value) {
                                    if (weightController.text.isEmpty) {
                                      return 'Weight(kg)*';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                          //All Field are required
                          CustomListTile(
                            question: 'Are you currently taking medications?',
                            value1: TakeMedication.Yes,
                            value2: TakeMedication.No,
                            groupValue1: takeMedication,
                            groupValue2: takeMedication,
                            onChanged1: (value) => setState(() {takeMedication = value;}),
                            onChanged2: (value) => setState(() {takeMedication = value;}),
                          ),
                          CustomListTile(
                            question: 'Do you have any allergies?',
                            value1: Allergies.Yes,
                            value2: Allergies.No,
                            groupValue1: allergies,
                            groupValue2: allergies,
                            onChanged1: (value) => setState(() {allergies = value;}),
                            onChanged2: (value) => setState(() {allergies = value;}),
                          ),
                          CustomListTile(
                            question: 'What is you current medical condition? Do you have any communicable disease,'
                                ' cardiovascular problem, diabetes, asthma etc.?',
                            value1: MedicalCondition.Yes,
                            value2: MedicalCondition.No,
                            groupValue1: medicalCondition,
                            groupValue2: medicalCondition,
                            onChanged1: (value) => setState(() {medicalCondition = value;}),
                            onChanged2: (value) => setState(() {medicalCondition = value;}),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          CustomListTileOrgan(
                            value1: Organs.Liver,
                            value2: Organs.Kidney,
                            value3: Organs.Heart,
                            value4: Organs.Pancreas,
                            value5: Organs.Bone,
                            value6: Organs.Lungs,
                            groupValue1: organs,
                            groupValue2: organs,
                            groupValue3: organs,
                            groupValue4: organs,
                            groupValue5: organs,
                            groupValue6: organs,
                            onChanged1: (value) => setState(() {organs = value;}),
                            onChanged2: (value) => setState(() {organs = value;}),
                            onChanged3: (value) => setState(() {organs = value;}),
                            onChanged4: (value) => setState(() {organs = value;}),
                            onChanged5: (value) => setState(() {organs = value;}),
                            onChanged6: (value) => setState(() {organs = value;}),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                          CustomText(
                            text: 'Please enter your password to confirm registration.',
                            fontSize: 16,
                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
                          ),
                          CustomTextFormReg(
                            controller: psdController,
                            isObscureText: true,
                            hintText: 'Password',
                            validator: (value) {
                              if (psdController.text.isEmpty) {
                                return 'Enter Password*';
                              } else if (psdController.text != currentPassword) {
                                return 'Wrong Password please check.';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    //Submit Button
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: FlatButton(
                            child: CustomText(
                                text: 'Submit',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                            onPressed: () async {
                              //Submit
                              try {
                                if (__formKey.currentState.validate() && int.parse(weightController.text) > 50
                                    && medicalCondition == MedicalCondition.No && takeMedication == TakeMedication.No
                                    && ((DateTime.now().year - contentProvider.year) > 16)) {
                                  setState(() {showSpinner = true;});
                                  if (existedSnapshot) { //Does Exit
                                    //If User has Registered before then show warning
                                    setState(() {showSpinner = false;});
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          backgroundColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                          content: CustomText(
                                            text: 'Hello $name. You are already a registered organ donor.',
                                            textAlign: TextAlign.center,
                                            fontSize: 18,
                                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
                                          ),
                                          actions: [
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
                                        ));
                                  } else {
                                    FirebaseFirestore.instance.collection('organ').doc(user.currentUser.uid)
                                        .set({
                                      'id': user.currentUser.uid,
                                      'Full Name' : capitalize(name),
                                      'Search Key': name.substring(0,1).toUpperCase(), //Take the first letter and convert it to capital letter
                                      'Email' : email.toLowerCase(),
                                      'Mobile Number' : phone,
                                      'ColorIdx': colorIdx,
                                      'PhotoUrl': photoUrl,
                                      'Address' : addController.text,
                                      'City' : capitalize(cityController.text),
                                      'Country' : contentProvider.defaultValue,
                                      'Birthday' : '${contentProvider.month} ${contentProvider.day}, ${contentProvider.year}',
                                      'Age' : DateTime.now().year - contentProvider.year,
                                      'Gender' : contentProvider.gender,
                                      'Height': heightController.text,
                                      'Weight' : weightController.text,
                                      'Likes' : 0,
                                      'DonationType': '$organs'.replaceAll('Organs.',''),
                                      'SearchKey': '$organs'.replaceAll('Organs.','').substring(0,1).toUpperCase(),
                                      'DonationTimes' : 0,
                                      'isFavourite': false,
                                      'messageDate': Timestamp.now(),
                                    }).then((value) async {
                                      //If successful remove the clear
                                      addController.clear();
                                      cityController.clear();
                                      heightController.clear();
                                      weightController.clear();
                                      psdController.clear();
                                      setState(() {showSpinner = false;});
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                              backgroundColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                              content: CustomText(
                                                text: 'Dear $name, Your donation application has been received successfully, but you need '
                                                    'to visit any registered hospital to confirm your application. Thank you for saving lives',
                                                textAlign: TextAlign.center,
                                                fontSize: 18,
                                                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
                                              )
                                          )
                                      );
                                      Toast.show(
                                          'Registered successfully.',
                                          context, duration: Toast.LENGTH_LONG,
                                          gravity:  Toast.BOTTOM
                                      );
                                    }).catchError((e) => print(e));
                                  }
                                } else  {
                                  setState(() {
                                    autoValidate = true;
                                    showSpinner = false;
                                  });
                                  //Make Sure the textFormField are not empty before applying the condition below
                                  if (medicalCondition == MedicalCondition.Yes || takeMedication == TakeMedication.Yes
                                      || ((DateTime.now().year - contentProvider.year) < 16) || int.parse(weightController.text) < 50) {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          backgroundColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                          ),
                                          content: CustomText(
                                            text: 'Sorry $name unfortunately, you can\'t donate at the moment. Please Checkout the eligibility.',
                                            textAlign: TextAlign.center,
                                            fontSize: 18,
                                            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
                                          ),
                                          actions: [
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
                                        )
                                    );
                                  }
                                }
                              } catch(e) {
                                setState(() {showSpinner = false;});
                                print(e);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                            onPressed: () => Navigator.pop(context),
                            child: CustomText(
                                text: 'Close',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
         )
    );
  }
}
