import 'package:enye_app/config/app_router.dart';
import 'package:enye_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();   // for splash screen back button

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType){
      return MaterialApp(
        title: 'E N Y E C O N T R O L S',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Raleway',
        ),
        navigatorKey: navigatorKey,
        // splash screen preventing to go back
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
      );
    }
    );
  }
}





