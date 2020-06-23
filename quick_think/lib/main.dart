import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickthink/db/sharedpref.dart';
import 'package:quickthink/screens/onboarding_screens/first_onboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/onboarding_screens/onboard_joined.dart';
import 'screens/splashpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPrefs sharedPrefs = SharedPrefs();
  var _checkIsFirstSeen;

  @override
  void initState() {
    super.initState();
    _checkIsFirstSeen = checkIsFirstSeen();
  }

  Future<bool> checkIsFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("seen")) {
      return true;
    } else {
      prefs.setBool("seen", true);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        title: 'QuickThink',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
          future: _checkIsFirstSeen,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data)
                return SplashPage();
              else
                return onBoardingScreensJoined();
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ));
  }
}
