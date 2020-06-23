import 'package:flutter/material.dart';

import 'first_onboard_screen.dart';
import 'second_onboard_screen.dart';
import 'third_onboard_screen.dart';

class onBoardingScreensJoined extends StatefulWidget {
  @override
  _onBoardingScreensJoinedState createState() =>
      _onBoardingScreensJoinedState();
}

class _onBoardingScreensJoinedState extends State<onBoardingScreensJoined> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        OnBoardScreen(),
        SecondOnBoardScreen(),
        ThirdOnBoardScreen(),
      ],
    );
  }
}
