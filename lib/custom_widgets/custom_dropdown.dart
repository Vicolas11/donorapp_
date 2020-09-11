import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:donorapp/constants/constants.dart';
import 'customtext.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    this.onChanged,
    this.value,
    this.items,
    this.flex = 1
  });
  final Function onChanged;
  final value;
  final int flex;
  final List items;
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, ContentProvider>(
      builder: (context, themeNotifier, contentProvider, child) =>
      Expanded(
        flex: flex,
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 1,),
          ),
          value: value,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 35,
          dropdownColor: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03002E),
          style: TextStyle(
            color: themeNotifier.darkTheme ? Colors.black : Colors.white.withOpacity(0.8),
          ),
          onChanged: onChanged,
          items: items,
        ),
      ),
    );
  }
}

class CustomTextFormReg extends StatelessWidget {
  CustomTextFormReg({
    this.isObscureText = false,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.hintText,
    this.regExp,
    this.inputType = TextInputType.text
  });
  final TextEditingController controller;
  final TextInputType inputType;
  final Function validator;
  final String hintText;
  final RegExp regExp;
  final bool isObscureText, readOnly;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, ContentProvider>(
      builder: (context, themeNotifier, contentProvider, child) =>
       TextFormField(
        readOnly: readOnly,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        controller: controller,
        obscureText: isObscureText,
        keyboardType: inputType,
        validator: validator,
        onChanged: onChanged,
        style: TextStyle(
          color: themeNotifier.darkTheme ? Colors.black : Color(0xFFA5D0E6),
        ),
        cursorColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
        decoration: kTextFieldDecoration.copyWith(
          contentPadding: EdgeInsets.only(bottom: 1, left: 10),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6), width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  CustomListTile({
    this.question,
    this.onChanged1,
    this.onChanged2,
    this.value1,
    this.groupValue1,
    this.value2,
    this.groupValue2
  });
  final String question;
  final value1, value2, groupValue1, groupValue2;
  final Function onChanged1, onChanged2;
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, ContentProvider>(
      builder: (context, themeNotifier, contentProvider, child) =>
       SizedBox(
         height: 80,
         child: ListTile(
          dense: true,
          title: CustomText(
            text: question,
            fontSize: 16,
            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: ThemeData(
                        unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Colors.white.withOpacity(0.8)
                    ),
                    child: SizedBox(
                      height: 28,
                      child: Radio(
                          value: value1,
                          groupValue: groupValue1,
                          onChanged: onChanged1,
                          activeColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  CustomText(
                    text: 'Yes',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: ThemeData(
                        unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Colors.white.withOpacity(0.8)
                    ),
                    child: SizedBox(
                      height: 28,
                      child: Radio(
                          value: value2,
                          groupValue: groupValue2,
                          onChanged: onChanged2,
                          activeColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  CustomText(
                    text: 'No',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
                  ),
                ],
              ),
            ],
          ),
      ),
       ),
    );
  }
}

class CustomListTileOrgan extends StatelessWidget {
  CustomListTileOrgan({
    this.value1,
    this.value2,
    this.value3,
    this.value4,
    this.value5,
    this.value6,
    this.groupValue1,
    this.groupValue2,
    this.groupValue3,
    this.groupValue4,
    this.groupValue5,
    this.groupValue6,
    this.onChanged1,
    this.onChanged2,
    this.onChanged3,
    this.onChanged4,
    this.onChanged5,
    this.onChanged6,
  });
  final value1, value2, value3, value4, value5, value6;
  final groupValue1, groupValue2, groupValue3, groupValue4, groupValue5, groupValue6;
  final Function onChanged1, onChanged2, onChanged3, onChanged4, onChanged5, onChanged6;
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, ContentProvider>(
      builder: (context, themeNotifier, contentProvider, child) =>
          SizedBox(
            height: 100,
            child: ListTile(
              dense: true,
              title: CustomText(
                text: 'Organs to be donated',
                fontSize: 16,
                textAlign: TextAlign.center,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Theme(
                        data: ThemeData(
                            unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Colors.white.withOpacity(0.8)
                        ),
                        child: SizedBox(
                          height: 28,
                          child: Radio(
                            value: value1,
                            groupValue: groupValue1,
                            onChanged: onChanged1,
                            activeColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      CustomText(
                        text: 'Liver',
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
                      ),
                      Theme(
                        data: ThemeData(
                            unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Colors.white.withOpacity(0.8)
                        ),
                        child: SizedBox(
                          height: 28,
                          child: Radio(
                            value: value2,
                            groupValue: groupValue2,
                            onChanged: onChanged2,
                            activeColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      CustomText(
                        text: 'Kidney',
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Theme(
                        data: ThemeData(
                            unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Colors.white.withOpacity(0.8)
                        ),
                        child: SizedBox(
                          height: 28,
                          child: Radio(
                            value: value3,
                            groupValue: groupValue3,
                            onChanged: onChanged3,
                            activeColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      CustomText(
                        text: 'Heart',
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
                      ),
                      Theme(
                        data: ThemeData(
                            unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Colors.white.withOpacity(0.8)
                        ),
                        child: SizedBox(
                          height: 28,
                          child: Radio(
                            value: value4,
                            groupValue: groupValue4,
                            onChanged: onChanged4,
                            activeColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      CustomText(
                        text: 'Pancreas',
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Theme(
                        data: ThemeData(
                            unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Colors.white.withOpacity(0.8)
                        ),
                        child: SizedBox(
                          height: 28,
                          child: Radio(
                            value: value5,
                            groupValue: groupValue5,
                            onChanged: onChanged5,
                            activeColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      CustomText(
                        text: 'Bone',
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
                      ),
                      Theme(
                        data: ThemeData(
                            unselectedWidgetColor: themeNotifier.darkTheme ? Colors.grey : Colors.white.withOpacity(0.8)
                        ),
                        child: SizedBox(
                          height: 28,
                          child: Radio(
                            value: value6,
                            groupValue: groupValue6,
                            onChanged: onChanged6,
                            activeColor: themeNotifier.darkTheme ? kPrimaryColor : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      CustomText(
                        text: 'Lungs',
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}



