import 'dart:async';

import 'package:enye_app/widget/custom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/home/homepage.dart';

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
    Timer(Duration(seconds: 5),() => Navigator.of(navigatorKey.currentContext!).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CustomNavBar(),
      ),
    ),
    );
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
                  child: Image(image: AssetImage('assets/logo/splash.gif'),
                    fit: BoxFit.fill,),
                )



        ),
    );
  }
}
