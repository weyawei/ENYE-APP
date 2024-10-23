import 'package:enye_app/screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'config/config.dart';
import 'widget/widgets.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();   // for splash screen back button

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //to update token in database always everytime app opened
  dynamic token = await SessionManager().get("token");

  // Create an instance of CheckSession
  checkSession sessionChecker = checkSession();

  Map<String, String?> deviceDetails = await sessionChecker.getDeviceDetails();

  // Log or use the device details as needed
  print("Device Model: ${deviceDetails['model']}");
  print("Device Brand: ${deviceDetails['id']}");

  _checkVerification(String email) async {
    var clientDataJson = await SessionManager().get("client_data");
    clientInfo clientData = clientInfo.fromJson(clientDataJson);

    // Await the result of verification
    String result = await TokenServices.verificationEmail(email, 'Update');

    if (result == 'success') {
      clientData.status = "Verified";
    } else {
      clientData.status = "Unverified";
    }

    // Save updated status to the session
    await SessionManager().set("client_data", clientData);
  }

  //this is to configure if the user already signed in
  checkSession().getUserSessionStatus().then((bool) {
    if (bool == true) {
      checkSession().getClientsData().then((value) {
        TokenServices.updateToken(token.toString(), value.email, value.login, ApiPlatform.getPlatform(), deviceDetails['model'].toString(), deviceDetails['id'].toString()).then((result) {
          if('success' == result){
            print("Updated token successfully");
          } else {
            print("Error updating token");
          }
        });
        _checkVerification(value.email);
      });
    } else {
      TokenServices.updateToken(token.toString(), "", "", ApiPlatform.getPlatform(), deviceDetails['model'].toString(), deviceDetails['id'].toString()).then((result) {
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
          fontFamily: 'Poppins',
        ),
        navigatorKey: navigatorKey,
        // splash screen preventing to go back
        //onGenerateRoute: AppRouter.onGenerateRoute,
        //initialRoute: SplashScreen.routeName,
        debugShowCheckedModeBanner: false,
        home:SplashScreen(),
      );
    }
    );
  }
}


class MainScreen extends StatelessWidget {
  final RemoteMessage? message;

  MainScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return NoInternetHandler(
      child: CustomNavBar(initialMessage: message),
    );
  }
}


