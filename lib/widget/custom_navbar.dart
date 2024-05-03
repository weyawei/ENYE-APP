import 'package:enye_app/screens/products/products1.dart';
import 'package:enye_app/screens/screens.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../dashboardicon_icons.dart';
import 'widgets.dart';

class CustomNavBar extends StatefulWidget {
  final RemoteMessage? initialMessage;
  static const String routeName = '/';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CustomNavBar()
    );
  }

  CustomNavBar({
    super.key,
    this.initialMessage,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    RemoteMessage? message = RemoteMessage();

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    if (widget.initialMessage != null) {
      message = widget.initialMessage;

      if (message?.data["goToPage"].toString() == 'Status' ||
          message?.data["goToPage"].toString() == 'Completed' ){
        _initialIndex = 4;
      } else if (message?.data["goToPage"].toString() == 'products'){
        _initialIndex = 2;
      }
    }

    List<Widget> _buildScreens() {
      return [
        homePage(),
        systemsPage(),
        productsPage(),
        ProjectsPage(),
        ServicePage(message: message as RemoteMessage),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home, size: (screenHeight + screenWidth) / 40,),
          title: ("Home"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Dashboardicon.systems_nav, size: (screenHeight + screenWidth) / 40),
          title: ("Systems"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.shopping_cart, size: (screenHeight + screenWidth) / 40),
          title: ("Products"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Dashboardicon.projects_nav, size: (screenHeight + screenWidth) / 40),
          title: ("Projects"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.calendar_month_rounded, size: (screenHeight + screenWidth) / 40),
          title: ("Appointment"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
          textStyle: TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.bold),
        ),

      ];
    }

    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: _initialIndex);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      navBarHeight: screenHeight * 0.08,
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.deepOrange, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: const NavBarDecoration(
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style4, // Choose the nav bar style with this property.
    );

      BottomAppBar(
      color: Colors.deepOrange,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              color: Colors.white,
              tooltip: 'Home',
              icon: const Icon(Dashboardicon.home_nav, semanticLabel: 'Home'),
              onPressed: (){
                Navigator.pushNamed(context, '/');
              },),
            IconButton(
              color: Colors.white,
              tooltip: 'Systems',
              icon: const Icon(Dashboardicon.systems_nav, semanticLabel: 'Systems',),
              onPressed: (){
                Navigator.pushNamed(context, '/systems');
              },),
            IconButton(
              color: Colors.white,
              tooltip: 'Projects',
              icon: const Icon(Dashboardicon.projects_nav, semanticLabel: 'Projects',),
              onPressed: (){
                Navigator.pushNamed(context, '/projects');
              },),
            IconButton(
              color: Colors.white,
              tooltip: 'Contacts',
              icon: const Icon(Dashboardicon.contact_us_nav, semanticLabel: 'Contacts',),
              onPressed: (){
                Navigator.pushNamed(context, '/contacts');
              },),
          ],
        ),
      ),
    );
  }
}