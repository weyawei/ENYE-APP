import 'package:flutter/material.dart';

import 'widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String imagePath;
  final double appBarHeight;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.appBarHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget appBarTitle;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    if (imagePath.isNotEmpty) {
      appBarTitle = Image.asset(
        imagePath,
        width: screenWidth >= 600 ? screenWidth * 0.4 : screenWidth * 0.5,
        height: screenHeight * 0.5,
      );
    } else {
      appBarTitle = Text(title, style: TextStyle(color: Colors.white, fontSize: fontExtraSize, letterSpacing: 1.2));
    }

    return AppBar(
      backgroundColor: Colors.deepOrange,
      elevation: 0,
      centerTitle: true,
      title: appBarTitle,
      iconTheme: IconThemeData(color: Colors.white , size: fontExtraSize),
      actions: [
        /*IconButton(onPressed: () {}, icon: Icon(Icons.favorite))*/
      ],
      toolbarHeight: appBarHeight,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
