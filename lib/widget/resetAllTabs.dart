import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/screens.dart';

void resetAllTabs(BuildContext context) {
  for (int i = 0; i < 5; i++) {
    // Set the current tab
    navBarController.jumpToTab(i);

    // Access the navigator for the current tab and pop all routes
    Navigator.of(context).pop((route) => route.isFirst);
  }
}