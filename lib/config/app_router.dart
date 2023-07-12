import 'package:enye_app/screens/catalog/catalog_screen.dart';
import 'package:enye_app/screens/home/homepage.dart';
import 'package:enye_app/screens/products/products1.dart';
import 'package:enye_app/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/products/category_model.dart';
import '../screens/products/product_model.dart';
import '../screens/products/product_screen.dart';
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
      case SplashScreen.routeName:
        return SplashScreen.route();
      case SystemsPage.routeName:
        return SystemsPage.route();
      case ProjectsPage.routeName:
        return ProjectsPage.route();
      case detailedProjPage.routeName:
        return detailedProjPage.route(projects: settings.arguments as Projects);
      case ContactsPage.routeName:
        return ContactsPage.route();
      case ProductPage.routeName:
        return ProductPage.route();
      case CatalogScreen.routeName:
        return CatalogScreen.route();
      case ProductScreen.routeName:
        return ProductScreen.route(product: settings.arguments as Product);


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

