import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:donorapp/provider/content_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:donorapp/constants/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'about_us.dart';
import 'chat_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'package:donorapp/provider/theme_provider.dart';


class SwitchScreen extends StatefulWidget {
  SwitchScreen({this.showBottomBar = false, this.uid});
  final bool showBottomBar;
  final String uid;
  static final routeName = 'switch_screen';
  @override
  _SwitchScreenState createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  int _currentScreenIdx = 2;
  ScrollController scrollController;
  bool isBottomNavVisible, showFAB, isOnTop;

  void _scrollToTop() {
    scrollController.position.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 800),
        curve: Curves.linearToEaseOut);
    setState(() {
      showFAB = true;
    });
  }

  @override
  void initState() {
    super.initState();
    isBottomNavVisible = true;
    showFAB = false;
    scrollController = ScrollController();
    scrollController.addListener(() {

      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isBottomNavVisible) {
          setState(() {
            isBottomNavVisible = false;
            ChatScreen(showListView: false,);
          });
        }
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isBottomNavVisible) {
          setState(() {
            isBottomNavVisible = true;
            ChatScreen(showListView: true,);
          });

        }
      }
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels.toInt() > 200) {
          setState(() {
            showFAB = true;
          });
        } else {
          setState(() {
            showFAB = false;
          });
        }

      }
    });//*/
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List navigateClass = [
      AboutScreen(scrollController: scrollController),
      SearchScreen(scrollController: scrollController, uid: widget.uid),
      HomeScreen(scrollController: scrollController),
      ChatScreen(scrollController: scrollController, uid: widget.uid),
      SettingsScreen(scrollController: scrollController, uid: widget.uid)];
    var provide = Provider.of<ContentProvider>(context);
    var provides = Provider.of<ThemeNotifier>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: provides.darkTheme ? kPrimaryColor : Color(0xFF03001E),
    ));
    return WillPopScope(
      onWillPop: () => Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        //Floating Button
        floatingActionButton: Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) =>
           Visibility(
            visible: showFAB,
            child: FloatingActionButton(
              tooltip: 'Return top',
              hoverColor: kPrimaryColor,
              backgroundColor: themeNotifier.darkTheme ? Colors.red.withOpacity(0.5) : Color(0xFFA5D0E6),
              onPressed: () => _scrollToTop(),
              child: Icon(FontAwesomeIcons.arrowUp, color: Colors.white.withOpacity(0.55),),
            ),
          ),
        ),
        //Bottom Navigation Bar
        bottomNavigationBar: Consumer2<ThemeNotifier, ContentProvider>(
          builder: (context, themeNotifier, contentProvider, child) =>
           AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            height: contentProvider.isBottomNavVisible ? 50.0 : 0.0,
            child: CurvedNavigationBar(
                animationDuration: Duration(milliseconds: 100),
                animationCurve: Curves.bounceInOut,
                backgroundColor: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                color: themeNotifier.darkTheme ? Color(0xfff9f8fd) : Color(0xFF03001E),
                height: contentProvider.isBottomNavVisible ? 50.0 : 0.0,
                items: provide.bottomNavIcons.map((iconItems) =>
                    Icon(
                        iconItems.icon,
                        color: themeNotifier.darkTheme ? kPrimaryColor : Color(0xFFA5D0E6),
                        size: 20.0)
                ).toList(),
                index: _currentScreenIdx,
                onTap: (index) {
                  //showTitled(index, provide);
                  setState(() {
                    _currentScreenIdx = index;
                  });
                }
            ),
          ),
        ),
        body: navigateClass[_currentScreenIdx],
      ),
    );
  }
}