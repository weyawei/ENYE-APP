import 'package:flutter/material.dart';

import 'widgets.dart';

class BulletText extends StatelessWidget {
  final String description;

  const BulletText({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.circle_outlined,
          size: fontSmallSize,
          color: Colors.deepOrange.shade200,
        ),
        SizedBox(width: screenWidth * 0.01,),
        Expanded(
          child: Text(
            description,
            style: TextStyle(fontSize: fontNormalSize), // Adjust text style as needed
          ),
        ),
      ],
    );
  }
}
