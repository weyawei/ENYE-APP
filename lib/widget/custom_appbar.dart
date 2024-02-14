import 'package:flutter/material.dart';

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

    //double appBarHeight = MediaQuery.of(context).size.height * 0.9; // AppBar height with system padding

    var fontExtraSize = 20.0; // Change this as per your requirement
    // You can modify fontExtraSize as you like. I set it to a constant value for demonstration purposes.

    if (imagePath.isNotEmpty) {
      appBarTitle = Image.asset(
        imagePath,
        width: screenWidth * 0.6,
        height: screenHeight * 0.85,
      );
    } else {
      appBarTitle = Text(title, style: TextStyle(color: Colors.white, fontSize: fontExtraSize, letterSpacing: 1.2));
    }

    return AppBar(
      backgroundColor: Colors.deepOrange,
      elevation: 0,
      centerTitle: true,
      title: appBarTitle,
      iconTheme: IconThemeData(color: Colors.white , size: MediaQuery.of(context).size.width * 0.03),
      actions: [
        /*IconButton(onPressed: () {}, icon: Icon(Icons.favorite))*/
      ],
      toolbarHeight: appBarHeight,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
