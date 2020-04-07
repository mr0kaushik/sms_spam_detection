import 'package:flutter/material.dart';
import 'package:sms_spam_detection/presentation/MatColor.dart';
import 'package:sms_spam_detection/screens/ImportScreen.dart';
import 'package:sms_spam_detection/screens/onboarding_screen.dart';
import 'package:sms_spam_detection/screens/splash_screen.dart';

import 'screens/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spam SMS Detection',
      theme: kDefaultTheme,
      home: Splashscreen(),
      routes: {
        '/import': (context) => ImportedScreen(),
        '/onboard': (context) => OnboardingScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }

  final ThemeData kDefaultTheme = new ThemeData(
    accentColor: MatColor.accentColor,
    primaryColor: MatColor.primaryColor,
    indicatorColor: Colors.white,
    primaryColorDark: MatColor.primaryDarkColor,
    primaryIconTheme: IconThemeData(
      color: Colors.white,
    ),
    fontFamily: 'Lato',
    textTheme: TextTheme(
      headline6: TextStyle(color: MatColor.primaryLightColor),
    ),
  );

  final ThemeData kIOSTheme = new ThemeData(
    primaryColor: MatColor.primaryLightColor,
    primaryColorBrightness: Brightness.light,
    indicatorColor: Colors.white,
    primaryColorDark: MatColor.primaryDarkColor,
    primaryIconTheme: IconThemeData(
      color: Colors.white,
    ),
    fontFamily: 'Lato',
    textTheme: TextTheme(
      headline6: TextStyle(color: MatColor.primaryLightColor),
    ),
  );
}
