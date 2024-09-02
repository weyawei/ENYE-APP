// global_controller.dart
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

final PersistentTabController navBarController = PersistentTabController();
final GlobalKey<NavigatorState> systemsNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> productsNavigatorKey = GlobalKey<NavigatorState>();