import 'package:enye_app/screens/home/homepage.dart';
import 'package:enye_app/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings){
    print('This is route:${settings.name}');

    switch (settings.name){
      case '/':
        return HomePage.route();
      case HomePage.routeName:
        return HomePage.route();
      case SystemsPage.routeName:
        return SystemsPage.route();
      case ProjectsPage.routeName:
        return ProjectsPage.route();
      case ContactsPage.routeName:
        return ContactsPage.route();

      default: 
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text('Error'),)
        )
    );
  }
}

