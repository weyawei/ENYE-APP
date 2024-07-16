import 'dart:async';

import 'package:enye_app/screens/products/products1.dart';
import 'package:enye_app/screens/screens.dart';
import 'package:enye_app/screens/services/survey.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../config/app_checksession.dart';
import '../dashboardicon_icons.dart';
import '../screens/services/survey_data.dart';
import '../screens/services/survey_svc.dart';
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
 /* // Declare the Timer
  Timer? _modalTimer;
 Timer? _refreshTimer;
  String token = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startModalTimer(); // Start the timer when the widget is initialized
    _startRefreshTimer();
  //  _startModalTimer(); // Start the timer when the widget is initialized
  }

  Future<void> _initializeData() async {
    await _fetchToken();

    _getAnswer();
  }

  Future<void> _fetchToken() async {
    String fetchedToken = await checkSession().getToken();
    setState(() {
      token = Uri.encodeComponent(fetchedToken); // URL-encode the token
    });
    print('Fetched Token: $token');
  }



  void _startModalTimer() {

    _modalTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      // _showModalDialog();
      _checkIfUserHasAnswered();
    });

  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _getAnswer(); // Periodically refresh the answers
    });
  }

  void _checkIfUserHasAnswered() {
    _getAnswer();
    bool hasAnswered = _answer.any((answer) => answer.token_id == token);
    // Debugging logs
    print("Checking if user has answered:");
    for (var answer in _answer) {
      print("Answer token: ${answer.token_id}, User token: $token");
    }
    print("Has answered: $hasAnswered");


    if (!hasAnswered) {
      _showModalDialog();
    }
  }

  List<SurveyAnswer> _answer = [];
  _getAnswer() {
    SurveyDataServices.getAnswer().then((answer) {
      setState(() {
        _answer = answer;
      // _checkIfUserHasAnswered();
      });
    });
  }

  @override
  void dispose() {
    _modalTimer?.cancel(); // Cancel the timer when the widget is disposed
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _showModalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            children: [
              Icon(Icons.add_alert_rounded, color: Colors.deepOrangeAccent),
              SizedBox(width: 8.0),
              Text(
                "Survey",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ],
          ),
          content: Text(
            "Would you like to answer our survey now?",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.deepOrangeAccent,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                "OK",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Add additional functionality here if needed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyPage()),
                );
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.deepOrangeAccent,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.deepOrangeAccent),
                ),
              ),
              child: Text(
                "Later",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Add additional functionality here if needed
              },
            ),
          ],
        );
      },
    );
  }
*/


  @override
  Widget build(BuildContext context) {
    RemoteMessage? message = RemoteMessage();

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontExtraSmallSize = ResponsiveTextUtils.getXSmallFontSize(screenWidth);

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
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: Colors.black38,
          textStyle: TextStyle(fontSize: fontExtraSmallSize, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Dashboardicon.systems_nav, size: (screenHeight + screenWidth) / 40),
          title: ("Systems"),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: Colors.black38,
          textStyle: TextStyle(fontSize: fontExtraSmallSize, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Container(
            width: (screenHeight + screenWidth) / 10,  // Set the width of the circle
            height: (screenHeight + screenWidth) / 10, // Set the height of the circle
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle, // Optional, if you want the background to be circular

            ),
            child: Icon(
              Icons.shopping_bag,
              size: (screenHeight + screenWidth) / 35,
              color: Colors.white,
            ),
          ),
          title: "Products",
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white,
          textStyle: TextStyle(
            fontSize: fontExtraSmallSize,
            fontWeight: FontWeight.bold,
          ),
        ),

        PersistentBottomNavBarItem(
          icon: Icon(Dashboardicon.projects_nav, size: (screenHeight + screenWidth) / 40),
          title: ("Projects"),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: Colors.black38,
          textStyle: TextStyle(fontSize: fontExtraSmallSize, fontWeight: FontWeight.bold),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.calendar_month_rounded, size: (screenHeight + screenWidth) / 40),
          title: ("Services"),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: Colors.black38,
          textStyle: TextStyle(fontSize: fontExtraSmallSize, fontWeight: FontWeight.bold),
        ),

      ];
    }

    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: _initialIndex);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      navBarHeight: kBottomNavigationBarHeight,
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(1.0),
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
      navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
    );

     /* BottomAppBar(
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
    );*/
  }
}