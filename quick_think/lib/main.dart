import 'package:flutter/material.dart';
import 'package:quickthink/db/sharedpref.dart';
import 'package:quickthink/screens/onboarding_screens/first_onboard_screen.dart';

import 'screens/onboarding_screens/onboard_joined.dart';
import 'screens/splashpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool seen;
  SharedPrefs sharedPrefs = SharedPrefs();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: seen ? onBoardingScreensJoined() : SplashPage(),
    );
  }
}
