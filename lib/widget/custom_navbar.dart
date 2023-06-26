import 'package:enye_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../dashboardicon_icons.dart';

class CustomNavBar extends StatefulWidget {
  @override
  _CustomNavBarState createState() => _CustomNavBarState();
  static const String routeName = '/';
  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CustomNavBar()
    );
  }

}

class _CustomNavBarState extends State<CustomNavBar> {


  int _selectedPageIndex = 0;



  @override
  Widget build(BuildContext context) {

    List<Widget> _buildScreens() {
      return [
        HomePage(),
        SystemsPage(),
        ProjectsPage(),
        ContactsPage()
      ];
    }
    void _selectPage(int index) {
      setState(() {
        _selectedPageIndex = index;
      });
    }
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Dashboardicon.home_nav),
          title: ("Home"),
          activeColorPrimary: Colors.deepOrange,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Dashboardicon.systems_nav),
          title: ("Systems"),
          activeColorPrimary: Colors.deepOrange,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Dashboardicon.projects_nav),
          title: ("Projects"),
          activeColorPrimary: Colors.deepOrange,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Dashboardicon.contact_us_nav),
          title: ("Contacts"),
          activeColorPrimary: Colors.deepOrange,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }


    List<Widget> _drawerItems = [
      // Define your app drawer items here
      ListTile(
        title: Text('Page 1'),
        onTap: () => _selectPage(0),
      ),
      ListTile(
        title: Text('Page 2'),
        onTap: () => _selectPage(1),
      ),
      ListTile(
        title: Text('Page 3'),
        onTap: () => _selectPage(2),
      ),
    ];


    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: const NavBarDecoration(

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
      navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
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