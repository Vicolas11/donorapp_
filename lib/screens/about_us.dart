import 'package:donorapp/constants/theme_colors.dart';
import 'package:donorapp/custom_widgets/customtext.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:donorapp/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatefulWidget {
  static final routeName = 'about_screen';
  AboutScreen({this.scrollController});
  final scrollController;

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    var provide = Provider.of<ContentProvider>(context);
    return SafeArea(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) =>
           Container(
             color: themeNotifier.darkTheme ? Colors.white : Color(0xFF03001E),
             child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 20
                  ),
                  child: CustomText(
                    text: 'About Donor Application',
                    color: themeNotifier.darkTheme ? Colors.black87 : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: 30
                  ),
                  child: CustomText(
                    text: provide.about,
                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white,
                    textAlign: TextAlign.justify,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: FlatButton(
                    color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: CustomText(
                      text: 'License',
                      fontSize: 15,
                      color: themeNotifier.darkTheme ? Colors.white.withOpacity(0.8) : Colors.white,
                    ),
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationIcon: Expanded(
                            child: Image.asset('images/donorlogo.png')
                        ),
                        applicationName: 'Donor APP',
                        applicationVersion: '1.0.0',
                        applicationLegalese: '(C) 2020 Company',
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                CustomText(
                  text: 'Medical Team and Developer',
                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                Flexible(
                  child: GridView(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 20.0
                    ),
                    children: provide.medPersonal.map((people) =>
                        SizedBox(
                            width: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  maxRadius: 30,
                                  backgroundImage: AssetImage(
                                    '${people.picture}',
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                                Expanded(
                                  child: CustomText(
                                    text: '${people.name}',
                                    textAlign: TextAlign.center,
                                    fontSize: 14,
                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.9) : Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: '${people.position}',
                                    textAlign: TextAlign.center,
                                    fontSize: 12,
                                    color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.7) : Colors.white,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ],
                            ))
                    ).toList(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                CustomText(
                  text: 'Appreciation',
                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('images/the60dayslogo.png'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('images/ministrylogo.png'),
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                CustomText(
                  text: 'Sponsors',
                  color: themeNotifier.darkTheme ? Colors.black.withOpacity(0.8) : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                ),
                Flexible(
                  child: GridView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 70.0,
                    ),
                    children: provide.sponsors.map((sponsor) =>
                        SizedBox(
                            width: 5, height: 5,
                            child: Image.asset(
                              'images/$sponsor',
                              width: 10, height: 10,
                              fit: BoxFit.scaleDown,
                            ))
                    ).toList(),
                  ),
                ),
              ],
          ),
           ),
        ),
      )
    );
  }
}