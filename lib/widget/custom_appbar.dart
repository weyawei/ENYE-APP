import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepOrange,
      elevation: 0,
      title: Text(title, style: TextStyle(color: Colors.white),),
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.favorite))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}