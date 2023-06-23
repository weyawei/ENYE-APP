import 'package:enye_app/config/app_router.dart';
import 'package:enye_app/screens/screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E N Y E C O N T R O L S',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Raleway',
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }
}





