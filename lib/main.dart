import 'package:donorapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'provider/content_provider.dart';
import 'provider/theme_provider.dart';
import 'screens/about_us.dart';
import 'screens/chat_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'screens/switch_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<ContentProvider>(
          create: (_) => ContentProvider(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
      ],
      child: Consumer2<ContentProvider, ThemeNotifier>(
        builder: (context, contentProvider, themeNotifier, widgets) {
          return MaterialApp(
            theme: themeNotifier.darkTheme ? light : dark,
            title: 'Donor',
            debugShowCheckedModeBanner: false,
            initialRoute: SplashScreen.routeName,
            routes: {
              RegisterScreen.routeName : (_) => RegisterScreen(),
              LoginScreen.routeName: (_) => LoginScreen(),
              SwitchScreen.routeName: (_) => SwitchScreen(),
              HomeScreen.routeName: (_) => HomeScreen(),
              ChatScreen.routeName: (_) => ChatScreen(),
              SettingsScreen.routeName: (_) => SettingsScreen(),
              AboutScreen.routeName: (_) => AboutScreen(),
              SearchScreen.routeName: (_) => SearchScreen(),
              MessagesScreen.routeName: (_) => MessagesScreen(),
              ProfileScreen.routeName: (_) => ProfileScreen(),
              SplashScreen.routeName: (_) => SplashScreen(),
            },
          );
        },
      ),
    );
  }
}
