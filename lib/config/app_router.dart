import 'package:enye_app/screens/catalog/catalog_screen.dart';
import 'package:enye_app/screens/home/homepage.dart';
import 'package:enye_app/screens/products/products1.dart';
import 'package:enye_app/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/products/category_model.dart';
import '../widget/custom_navbar.dart';

class AppRouter{
  static Route onGenerateRoute(RouteSettings settings){
    print('This is route:${settings.name}');

    switch (settings.name){
      case '/':
        return CustomNavBar.route();
      case HomePage.routeName:
        return HomePage.route();
      case SecondScreen.routeName:
        return SecondScreen.route();
      case SystemsPage.routeName:
        return SystemsPage.route();
      case ProjectsPage.routeName:
        return ProjectsPage.route();
      case detailedProjPage.routeName:
        return detailedProjPage.route();
      case ContactsPage.routeName:
        return ContactsPage.route();
      case ProductPage.routeName:
        return ProductPage.route();
      case CatalogScreen.routeName:
        return CatalogScreen.route(category: settings.arguments as Category1);


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

