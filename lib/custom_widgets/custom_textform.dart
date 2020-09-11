import 'package:donorapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:donorapp/constants/theme_colors.dart';

class CustomTextForm extends StatelessWidget {
  CustomTextForm({
    this.textController,
    this.regExp,
    this.onChange,
    this.inputType,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.onEditingComplete,
    this.errorText,
    this.validator,
    this.hintText,
    this.icon,
    this.suffixIcon,
  });
  final TextEditingController textController;
  final Widget suffixIcon;
  final TextInputType inputType;
  final Function validator;
  final RegExp regExp;
  final bool isObscureText;
  final Function onChange;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final String hintText, errorText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    var provide = Provider.of<ThemeNotifier>(context);
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) =>
       TextFormField(
        controller: textController,
        obscureText: isObscureText,
        keyboardType: inputType,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        onChanged: onChange,
        validator: validator,
        decoration: customInputDecoration(themeNotifier, hintText, icon, errorText, suffixIcon),
        style: TextStyle(
          color: provide.darkTheme ? Colors.black : Color(0xFFA5D0E6),
        ),
        cursorColor: provide.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
      ),
    );
  }
}

InputDecoration customInputDecoration(themeNotifier, hintText, icon, errorText, Widget suffix) {
  return kTextFieldDecoration.copyWith(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
          width: 1.0
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
          width: 2.0
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(32.0)),
    ),
    errorText: errorText,
    hintText: hintText,
    hintStyle: TextStyle(
      color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
    ),
    prefixIcon: Icon(
      icon,
      color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
    ),
    suffixIcon: suffix,
  );
}
