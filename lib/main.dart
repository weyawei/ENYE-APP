import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sizer/sizer.dart';

import 'config/config.dart';
import 'widget/widgets.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();   // for splash screen back button

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //to update token in database always everytime app opened
  dynamic token = await SessionManager().get("token");

  //this is to configure if the user already signed in
  checkSession().getUserSessionStatus().then((bool) {
    if (bool == true) {
      checkSession().getClientsData().then((value) {
        TokenServices.updateToken(token.toString(), value.client_id).then((result) {
          if('success' == result){
            print("Updated token successfully");
          } else {
            print("Error updating token");
          }
        });
      });
    } else {
      TokenServices.updateToken(token.toString(), "").then((result) {
        if('success' == result){
          print("Updated token successfully");
        } else {
          print("Error updating token");
        }
      });
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType){
      return MaterialApp(
        title: 'ENYE CONTROLS',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Raleway',
        ),
        navigatorKey: navigatorKey,
        // splash screen preventing to go back
        //onGenerateRoute: AppRouter.onGenerateRoute,
        //initialRoute: SplashScreen.routeName,
        debugShowCheckedModeBanner: false,
        home: NoInternetHandler(
            child: CustomNavBar()),
      );
    }
    );
  }
}





