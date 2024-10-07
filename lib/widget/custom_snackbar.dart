import 'package:enye_app/screens/feedback/feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets.dart';

void custSnackbar(BuildContext context, String message, Color color, IconData iconData, Color iconColor) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;

  var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 5),
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
            child: Text(
              message,
              style: TextStyle(
                fontSize: fontNormalSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

int _snackbarDisplayCount = 0;

void showPersistentSnackBar(BuildContext context, double screenWidth, double screenHeight, double fontSize, String message) {
  if (_snackbarDisplayCount > 0) return;

  _snackbarDisplayCount++;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.blue,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      content: Row(
        children: [
          Icon(
            Icons.info,
            color: Colors.white,
            size: fontSize * 1.5,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
      duration: Duration(hours: 12), // Keeps the SnackBar visible indefinitely
      action: SnackBarAction(
        label: 'CLOSE',
        textColor: Colors.white,
        onPressed: () {
          _snackbarDisplayCount = 0;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  ).closed.then((_) {
    _snackbarDisplayCount = 0;
  });
}

void showSnackbar({
  required BuildContext context,
  required double screenWidth,
  required double screenHeight,
  required double fontSize,
  required String message,
  required Color bkColor,
  required IconData icon,
  required bool isShowingErrorSnackbar,
  required int duration,
}) {
  if (isShowingErrorSnackbar) return; // If the snackbar is already visible, do nothing

  isShowingErrorSnackbar = true;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: duration),
      backgroundColor: bkColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        bottom: screenHeight * 0.775,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: fontSize * 1.5,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ).closed.then((_) {
    isShowingErrorSnackbar = false; // Reset the flag after the snackbar is dismissed
  });
}

void showSnackbarFeedback(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    double fontSize,
    String message,
    IconData icon,
    Color bkColor,
    int duration,) {

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: duration),
      backgroundColor: bkColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        bottom: screenHeight * 0.725,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: fontSize * 1.5,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                _snackbarDisplayCount = 0;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Button background color
                onPrimary: Colors.black, // Text color
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4), // Rounded corners
                ),
                elevation: 3, // Add shadow to the button
              ),
              child: Text(
                'Report Feedback',
                style: TextStyle(
                  fontSize: fontSize,
                  color: bkColor, // Use the same background color for text
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ).closed.then((_) {
    _snackbarDisplayCount = 0;
  });
}
