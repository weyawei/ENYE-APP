import 'dart:async';

import 'package:enye_app/widget/custom_navbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }
  const SplashScreen();

  @override
  Widget build(BuildContext context) {
    RemoteMessage message = RemoteMessage();

    if (ModalRoute.of(context)!.settings.arguments != null) {
      message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    }

    Timer(Duration(seconds: 3, milliseconds: 199),() => Navigator.of(navigatorKey.currentContext!).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainScreen(message: message),
      ),
    ),
    );
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo/splashh.gif'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
