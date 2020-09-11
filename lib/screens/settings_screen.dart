import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/custom_alertdialog.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:donorapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({this.uid, this.scrollController});
  final String uid;
  final ScrollController scrollController;
  static final routeName = 'settings_screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final oldPsdController = TextEditingController();
  final delController = TextEditingController();
  final controller = TextEditingController();
  final confirmPsdController = TextEditingController();
  final imagePicker = ImagePicker();
  SharedPreferences sharedPref;
  File _imageSelected;
  File avatarImageFile;
  PickedFile pickedFile;
  bool _inProcess = false;
  var userInfo;

  String id = '';
  String fullName = '';
  String photoUrl = '';
  String email = '';
  String phone = '';
  String date = '';
  int colorIdx = 0;

  readLocally () async {
    sharedPref = await SharedPreferences.getInstance();
    id = sharedPref.getString('id') ?? '';
    fullName = sharedPref.getString('Full Name') ?? '';
    photoUrl =  sharedPref.getString('PhotoUrl') ?? '';
    email = sharedPref.getString('Email') ?? '';
    phone = sharedPref.getString('Mobile Number') ?? '';
    date = sharedPref.getString('Date') ?? '';
    colorIdx = sharedPref.getInt('ColorIdx') ?? 0;
    setState(() {});
  }

  void signOut(context) async {
    sharedPref = await SharedPreferences.getInstance();
    _auth.signOut().then((value) async {
        await sharedPref.remove('id');
        await sharedPref.remove('Full Name');
        await sharedPref.remove('Email');
        await sharedPref.remove('Mobile Number');
        await sharedPref.remove('PhotoUrl');
        await sharedPref.remove('ColorIdx');
        await sharedPref.remove('Date');
        Navigator.popAndPushNamed(context, LoginScreen.routeName);
        Toast.show('Sign out successfully!', context,
            gravity:  Toast.BOTTOM, duration: Toast.LENGTH_LONG);
      }
    );
  }

  void showAlertDialog(context) {
    showDialog(
        context: context,
        builder: (context) =>
          CustomAlertDialogName(
            uid: widget.uid,
            controller: nameController,
          )
      );
    }

  void showAlertDialogPhone(context) {
    showDialog(
        context: context,
        builder: (context) =>
            CustomAlertDialogUpdatePhone(
              uid: widget.uid,
              controller: phoneController,
              inputType: TextInputType.phone,
            )
    );
  }

  void showAlertDialogPassword(context) {
    showDialog(
        context: context,
        builder: (context) =>
            CustomAlertDialogPassword(
              uid: widget.uid,
              oldController: oldPsdController,
              controller: controller,
              controllerConfirm: confirmPsdController,
              title: 'Update Password',
            )
    );
  }

  void showAlertDialogDelAcc(context) {
    showDialog(
        context: context,
        builder: (context) =>
            CustomAlertDialogDelAcc(
              uid: widget.uid,
              controller: delController,
            )
    );
  }

  void showAlertDialogDelete(context) {
    showDialog(
        context: context,
        builder: (context) =>
            Consumer<ThemeNotifier>(
               builder: (BuildContext context, themeNotifier, child) =>
               AlertDialog(
                backgroundColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                title: CustomText(
                  text: 'Delete Account',
                  textAlign: TextAlign.center,
                  fontSize: 19,
                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFFA5D0E6),
                ),
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                      size: 30,),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                    Expanded(
                      child: CustomText(
                        text: 'Deleting you DONOR App will erase all your RECORDS\n'
                            'Are you sure you want to delete it?',
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Color(0xFFA5D0E6),
                      ),
                    ),
                  ],
                ),
                  actions: [
                    FlatButton(
                      onPressed: ()  {
                        showAlertDialogDelAcc(context);
                        //Navigator.pop(context);
                      },
                      child: CustomText(
                          text: 'Yes',
                          fontSize: 16,
                          color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6)
                      ),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: CustomText(
                          text: 'No',
                          fontSize: 16,
                          color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6)
                      ),
                    )
                  ]
              ),
            )
    );
  }

  void getImaged(ImageSource source) async {
    try {
      this.setState((){
        _inProcess = true;
      });
      PickedFile image = await imagePicker.getImage(source: source);
      if(image != null){
        _imageSelected = File(image.path);
        File cropped = File(image.path);
        cropped = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatioPresets: Platform.isAndroid
                ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
                : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: kPrimaryColor,
                toolbarWidgetColor: kAccentColor,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              title: 'Cropper',
            )
        );
        this.setState((){
          _imageSelected = cropped;
          _inProcess = false;
        });
      } else {
        this.setState((){
          _inProcess = false;
        });
      }
    } catch (e) {
      print('ImagePicker ${e.toString}');
    }
  }

  Future getImage(ImageSource source) async {
    pickedFile = await imagePicker.getImage(source: source);
    _imageSelected = File(pickedFile.path);
    if (_imageSelected != null) {
      setState(() {
        avatarImageFile = _imageSelected;
        _inProcess = true;
      });
    }
    uploadAndUpdatePhoto();
  }

  Future uploadAndUpdatePhoto() async {
    try {
      String fileName = id;
      StorageReference storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      StorageUploadTask uploadTask = storageRef.putFile(avatarImageFile);
      StorageTaskSnapshot takeSnapshot;
      uploadTask.onComplete.then((value) {
        if (value.error == null) {
          takeSnapshot = value;
          takeSnapshot.ref.getDownloadURL().then((downloadLink) {
            photoUrl = downloadLink;
            FirebaseFirestore.instance.collection('users').doc(widget.uid)
            .update({
              "PhotoUrl": photoUrl,
            }).then((value) async {
              await sharedPref.setString('PhotoUrl', photoUrl);
              Toast.show(
                  'Photo Updated successfully!',
                  context, duration: Toast.LENGTH_LONG,
                  gravity:  Toast.BOTTOM
              );
              setState(() {
                _inProcess = false;
              });
            }
            ).catchError((err) {
              setState(() {
                _inProcess = false;
              });
            });
          });
        } else {
          setState(() {
            _inProcess = false;
          });
          Toast.show(
              'This file is not an image',
              context, duration: Toast.LENGTH_LONG,
              gravity:  Toast.BOTTOM
          );
        }
       }
      );
    } catch (e) {
      print(e.toString);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
  }

  @override
  void initState() {
    super.initState();
    readLocally();
  }

  @override
  Widget build(BuildContext context) {
    var databaseRef = _fireStore.collection('users').doc(widget.uid);
    return StreamBuilder<DocumentSnapshot>(
      stream: databaseRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !(snapshot.hasData)) {
          return Center(
            child: Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) =>
              CircularProgressIndicator(
                backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03002E),
              ),
            )
          );
        } else {
          userInfo = snapshot.data;
          return SafeArea(
            child: Consumer2<ThemeNotifier, ContentProvider>(
              builder: (context, themeNotifier, contentProvider, child) =>
                  Container(
                    color: themeNotifier.darkTheme ? kAccentColor : Color(0xFF03002E),
                    child: ListView(
                      controller: widget.scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 2.0
                      ),
                      children: [
                        Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                            SizedBox(
                              height: 250,
                              width: 200,
                              child: Stack(
                                overflow: Overflow.visible,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: (avatarImageFile == null) ?
                                    (photoUrl != '' ?
                                      CircleAvatar(
                                        radius: 90,
                                        backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                        child: SizedBox(
                                          width: 170.0,
                                          height: 170.0,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: photoUrl,
                                              fit: BoxFit.cover,
                                              width: 90.0,
                                              height: 90.0,
                                              placeholder: (context, url) => Container(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.0,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                      themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048)
                                                  ),
                                                ),
                                                width: 100.0,
                                                height: 100.0,
                                                padding: EdgeInsets.all(20.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ) : CircleAvatar(
                                      maxRadius: 70.0,
                                      backgroundColor: contentProvider.randColors[colorIdx],
                                      child: Center(
                                        child: CustomText(
                                          text: fullName.substring(0,1).toUpperCase() ?? userInfo.get("Full Name").substring(0,1).toUpperCase(),
                                          fontSize: 90,
                                          color: Colors.white,
                                        ),
                                       ),
                                      )
                                     ) : CircleAvatar(
                                      radius: 90,
                                      backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                      child: SizedBox(
                                        width: 170.0,
                                        height: 170.0,
                                        child: ClipOval(
                                          child: Image.file(
                                            //userInfo.get("PhotoUrl"),
                                            avatarImageFile,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 110,
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.photo,
                                              color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.95) : Color(0xFFA5D0E6),
                                            ),
                                            onPressed: () =>
                                                getImage(ImageSource.gallery)
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 110,
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: CircleAvatar(
                                        backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF010048),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.camera_enhance,
                                              color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.95) : Color(0xFFA5D0E6),
                                            ),
                                            onPressed: () => getImage(ImageSource.camera)
                                        ),
                                      ),
                                    ),
                                  ),
                                  (_inProcess) ? Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 180,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            backgroundColor: kPrimaryColor
                                        ),
                                      ),
                                    ),
                                  ) : Align(
                                      alignment: Alignment.center,
                                      child: Center()
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Card(
                          color: themeNotifier.darkTheme ? Colors.white: Color(0xFF010048),
                          elevation: 1,
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: CustomText(
                                  text: 'Personal Details',
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: CustomText(
                                  text: 'Edit Personal Details',
                                  fontSize: 16,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Divider(color: themeNotifier.darkTheme ? null : Color(0xFF090088),),
                              ListTile(
                                title: CustomText(
                                  text: 'Full Name',
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: CustomText(
                                  text: fullName ?? userInfo.get("Full Name"),
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                ),
                                trailing: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                    ),
                                    onPressed: () =>
                                        showAlertDialog(context) //Show Search Result!
                                ),
                              ),
                              ListTile(
                                title: CustomText(
                                  text: 'Email Address',
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: CustomText(
                                  text: email ?? userInfo.get("Email"),
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                ),
                              ),
                              ListTile(
                                title: CustomText(
                                  text: 'Mobile Number',
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: CustomText(
                                  text: userInfo.get("Mobile Number") ?? phone ,
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                ),
                                trailing: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                    ),
                                    onPressed: () =>
                                        showAlertDialogPhone(
                                            context) //Show Search Result!
                                ),
                              ),
                              ListTile(
                                title: CustomText(
                                  text: 'Date Joined',
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: CustomText(
                                  text: date ?? userInfo.get("Date"),
                                  fontSize: 18,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: themeNotifier.darkTheme ? Colors.white: Color(0xFF010048),
                          elevation: 1,
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ListTile(
                                title: CustomText(
                                  text: 'Settings',
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: CustomText(
                                  text: 'Set your APP to your choice',
                                  fontSize: 14,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Divider(color: themeNotifier.darkTheme ? null : Color(0xFF090088),),
                              ListTile(
                                  leading: Icon(
                                    Icons.brightness_6,
                                    size: 30,
                                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                  ),
                                  title: CustomText(
                                    text: 'Theme',
                                    fontSize: 20,
                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  subtitle: CustomText(
                                    text: themeNotifier.darkTheme ? 'Light' : 'Dark',
                                    fontSize: 16,
                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  trailing: Switch(
                                    activeColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.white,
                                    value: themeNotifier.darkTheme,
                                    onChanged: (value) {
                                      themeNotifier.toggleTheme();
                                    },
                                  )
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.language,
                                  size: 30,
                                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                ),
                                title: CustomText(
                                  text: 'Language',
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: CustomText(
                                  text: 'English',
                                  fontSize: 16,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                                trailing: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                    ),
                                    onPressed: () {} //Show Search Result!
                                ),
                              ),
                              InkWell(
                                onTap: () => showAlertDialogDelete(context),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                  ),
                                  title: CustomText(
                                    text: 'Delete Account',
                                    fontSize: 20,
                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  subtitle: CustomText(
                                    text: 'Remove account completely',
                                    fontSize: 16,
                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: themeNotifier.darkTheme ? Colors.white: Color(0xFF010048),
                          elevation: 1,
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: CustomText(
                                  text: 'Security',
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: CustomText(
                                  text: 'Update or Change Password',
                                  fontSize: 16,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Divider(color: themeNotifier.darkTheme ? null : Color(0xFF090088),),
                              ListTile(
                                leading: Icon(
                                  Icons.vpn_key,
                                  size: 30,
                                  color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                                ),
                                title: CustomText(
                                  text: 'Password',
                                  fontSize: 20,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                subtitle: CustomText(
                                  text: 'change your password',
                                  fontSize: 16,
                                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                                trailing: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                                    ),
                                    onPressed: () =>
                                        showAlertDialogPassword(
                                            context) //Show Search Result!
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          child: CustomText(
                            text: 'Sign Out',
                            fontSize: 20,
                            color: themeNotifier.darkTheme ? kPrimaryColor : Colors.white,
                          ),
                          onPressed: () {
                            signOut(context);
                          },
                        ),
                      ],
                    ),
                  ),
            ),
          );
        }
      }
    );
  }
}
