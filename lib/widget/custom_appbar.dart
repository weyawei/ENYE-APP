import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final String imagePath;


  const CustomAppBar({
    super.key,
    required this.title,
  required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    Widget appBarTitle;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    if (imagePath.isNotEmpty) {
      appBarTitle = Image.asset(
        imagePath,
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.85,
      );
    } else {
      appBarTitle = Text(title, style: TextStyle(color: Colors.white, fontSize: fontExtraSize, letterSpacing: 1.2));
    }

    return AppBar(

      backgroundColor: Colors.deepOrange,
      elevation: 0,
      centerTitle: true,
      title: appBarTitle,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        /*IconButton(onPressed: () {}, icon: Icon(Icons.favorite))*/
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}