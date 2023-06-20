import 'package:enye_app/screens/screens.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../widget/custom_drawer.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  static Route route(){
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => HomePage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', imagePath: 'assets/logo/enyecontrols.png',),
      drawer: CustomDrawer(),
      body: Container(
        child: TextButton(
          onPressed: (){
            PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: SecondScreen.routeName),
              screen: SecondScreen(),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );

          },
          child: Icon(Icons.arrow_forward, color: Colors.deepOrange,)
        ),
      ),
    );
  }
}