import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileMainInfo extends StatelessWidget {
  ProfileMainInfo({
    this.email,
    this.gender,
    this.bloodGroup,
    this.height,
    this.weight,
    this.age,
    this.birthday,
    this.donationTimes,
    this.address,
    this.city,
    this.country,
    this.phone
  });
  final String email, gender, bloodGroup, height, weight, age;
  final String birthday, donationTimes, address, city, country, phone;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) =>
       Column(
        children: [
          CustomText(
            text: 'Basic Info',
            color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
            fontSize: 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListTile(
              leading: CustomText(
                text: 'Gender:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: gender,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
          Divider(
            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
            indent: 80.0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListTile(
              leading: CustomText(
                text: 'Birthday:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: birthday,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
          Divider(
            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
            indent: 80.0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListTile(
              leading: CustomText(
                text: 'Age:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: age,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
          Divider(color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8)),

          ///ADDRESS INFO
          CustomText(
            text: 'Address',
            color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
            fontSize: 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: ListTile(
              leading: CustomText(
                text: 'Steet:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: address,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
              subtitle: CustomText(
                text: '$city, $country',
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
          Divider(color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8)),

          ///CONTACT INFO
          CustomText(
            text: 'Contact Info',
            color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
            fontSize: 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListTile(
              leading: CustomText(
                text: 'Email:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: email,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
          Divider(
            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
            indent: 80.0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListTile(
              leading: CustomText(
                text: 'Mobile Number:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: phone,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
          Divider(color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8)),

          ///MEDICAL INFORMATION
          CustomText(
            text: 'Medical Info',
            color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFF03001E),
            fontSize: 30,
          ),
          bloodGroup == '' ?
          Container() :
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListTile(
              leading: CustomText(
                text: 'Blood Group:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: bloodGroup,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
          bloodGroup == '' ?
          Container() :
          Divider(
            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
            indent: 80.0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListTile(
              leading: CustomText(
                text: 'Height:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: '$height ft',
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
          Divider(
            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
            indent: 80.0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListTile(
              leading: CustomText(
                text: 'Weight:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: '$weight kg',
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
          Divider(
            color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.8),
            indent: 80.0,
          ),
          SizedBox(
            height: 50,
            child: ListTile(
              leading: CustomText(
                text: 'Donation Times:',
                fontWeight: FontWeight.bold,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 21,
              ),
              title: CustomText(
                text: donationTimes,
                color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Color(0xFF03001E),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
