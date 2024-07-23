import 'package:flutter/material.dart';

import 'widgets.dart';

void custSnackbar(BuildContext context, String message, Color color, IconData iconData, Color iconColor) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: screenHeight * 0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      content: Row(
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: fontNormalSize * 1.5,
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: RichText(
              softWrap: true,
              textAlign: TextAlign.start,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: message,
                    style: TextStyle(
                      fontSize: fontNormalSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
